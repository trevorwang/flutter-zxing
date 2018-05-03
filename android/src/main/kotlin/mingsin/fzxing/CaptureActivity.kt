package mingsin.fzxing
import android.app.Activity
import android.os.Bundle
import android.view.KeyEvent
import com.google.zxing.ResultPoint
import com.google.zxing.client.android.BeepManager
import com.google.zxing.client.android.Intents
import com.journeyapps.barcodescanner.BarcodeCallback
import com.journeyapps.barcodescanner.BarcodeResult
import com.journeyapps.barcodescanner.DecoratedBarcodeView
import org.greenrobot.eventbus.EventBus

class CaptureActivity : Activity() {
    private var lastBarcode = "INVALID_STRING_STATE"
    private lateinit var scannerView: DecoratedBarcodeView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_capture)
        val isContinuous = intent.extras[keyIsContinuous] as Boolean
        val isBeep = intent.getBooleanExtra(Intents.Scan.BEEP_ENABLED, true)
        scannerView = findViewById(R.id.scanner_view)
        scannerView.setStatusText("")
        val beepManager = BeepManager(this)

        if (isContinuous) {
            scannerView.decodeContinuous(object : BarcodeCallback {
                override fun barcodeResult(result: BarcodeResult?) {
                    result?.text?.let {
                        lastBarcode = it

                        if (isBeep) {
                            beepManager.playBeepSound()
                        }

                        EventBus.getDefault().post(BarcodeEvent(result.text))
                    }
                }

                override fun possibleResultPoints(resultPoints: List<ResultPoint>) {
                }
            })
        } else {
            scannerView.decodeSingle(object : BarcodeCallback {
                override fun barcodeResult(result: BarcodeResult?) {
                    result?.text?.let {
                        lastBarcode = it

                        if (isBeep) {
                            beepManager.playBeepSound()
                        }

                        EventBus.getDefault().post(BarcodeEvent(result.text))
                        finish()
                    }
                }

                override fun possibleResultPoints(resultPoints: List<ResultPoint>) {
                }
            })
        }

    }

    override fun onResume() {
        super.onResume()
        scannerView.resume()
    }

    override fun onPause() {
        super.onPause()
        scannerView.pause()
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        return scannerView.onKeyDown(keyCode, event) || super.onKeyDown(keyCode, event)
    }

}