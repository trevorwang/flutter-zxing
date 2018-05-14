package mingsin.fzxing

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.util.Log
import com.google.zxing.integration.android.IntentIntegrator
import com.tbruyelle.rxpermissions2.RxPermissions
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar

const val keyIsContinuous = "isContinuous"
const val keyScan = "scan"
const val keyIsBeep = "isBeep"
const val keyContinuousInterval = "continuousInterval"

class FzxingPlugin(private val registrar: Registrar) : MethodCallHandler {

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "fzxing")
            val plugin = FzxingPlugin(registrar)
            channel.setMethodCallHandler(plugin)
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
        val argumentsMap = call.arguments as Map<*, *>
        val isBeep = argumentsMap[keyIsBeep] as? Boolean ?: true
        val isContinuous = argumentsMap[keyIsContinuous] as? Boolean ?: false
        val scanInterval = argumentsMap[keyContinuousInterval] as? Int ?: 1000
        val config = Config(isBeep, isContinuous, scanInterval)
        Log.d(keyIsBeep, isBeep.toString())
        Log.d(keyIsContinuous, isContinuous.toString())
        startCapture(config, result)
    }

    private fun startCapture(config: Config, result: Result) {
        val activity = registrar.activity()
        RxPermissions(activity)
                .request(Manifest.permission.CAMERA)
                .subscribe({ granted ->
                    if (granted) {
                        startScan(result, activity, config)
                    } else {
                        result.error("", "", "")
                    }
                })
    }

    private fun startScan(result: Result, activity: Activity?, config: Config) {
        if (listener.result == null) {
            registrar.addActivityResultListener(listener)
        }
        listener.result = result

        IntentIntegrator(activity)
                .setDesiredBarcodeFormats(IntentIntegrator.ONE_D_CODE_TYPES)
                .setCaptureActivity(CaptureActivity::class.java)
                .setBeepEnabled(config.isBeep)
                .addExtra(keyIsContinuous, config.isContinuous)
                .addExtra(keyContinuousInterval, config.scanInterval)
                .initiateScan()
    }

    private val listener = object : PluginRegistry.ActivityResultListener {
        var result: Result? = null
        override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent?): Boolean {
            val array = intent?.getStringArrayListExtra("result") ?: arrayListOf()
            result?.success(array)
            return true
        }

    }

    internal data class Config(val isBeep: Boolean, val isContinuous: Boolean, val scanInterval: Int)

}
