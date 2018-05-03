package mingsin.fzxing

import android.Manifest
import android.util.Log
import com.google.zxing.integration.android.IntentIntegrator
import com.tbruyelle.rxpermissions2.RxPermissions
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe

const val keyIsContinuous = "isContinuous"
const val keyScan = "scan"
const val keyIsBeep = "isBeep"

class FzxingPlugin: MethodCallHandler {

  companion object {
    @JvmField
    var REGISTRAR: Registrar? = null

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      REGISTRAR = registrar
      val channel = MethodChannel(registrar.messenger(), "fzxing")
      channel.setMethodCallHandler(FzxingPlugin())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      keyScan -> {
        handleScan(call, result)
      }
      else -> result.notImplemented()

    }
  }


  private fun handleScan(call: MethodCall, result: Result) {
    val barcodeHandler = object {
      @Subscribe
      fun onBarcode(barcode: BarcodeEvent) {
        Log.d("barcode", "barcode:" + barcode.barcode)
        result.success(barcode.barcode)
      }
    }


    val argumentsMap = call.arguments as Map<*, *>
    val isBeep = argumentsMap[keyIsBeep] as Boolean
    val isContinuous = argumentsMap[keyIsContinuous] as Boolean
    Log.d(keyIsBeep, isBeep.toString())
    Log.d(keyIsContinuous, isContinuous.toString())

    EventBus.getDefault().register(barcodeHandler)

    REGISTRAR?.let {
      val activity = it.activity()
      RxPermissions(activity)
              .request(Manifest.permission.CAMERA)
              .subscribe({ granted ->
                if (granted) {
                  it.addViewDestroyListener({
                    EventBus.getDefault().unregister(barcodeHandler)
                    true
                  })

                  IntentIntegrator(activity)
                          .setDesiredBarcodeFormats(IntentIntegrator.ONE_D_CODE_TYPES)
                          .setCaptureActivity(CaptureActivity::class.java)
                          .setBeepEnabled(isBeep)
                          .addExtra(keyIsContinuous, isContinuous)
                          .initiateScan()
                } else {
                  //TODO set error
                  result.error("", "", "")
                }
              })
    }
  }
}
