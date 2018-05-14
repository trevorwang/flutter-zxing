package mingsin.fzxing

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.KeyEvent
import com.google.zxing.ResultPoint
import com.google.zxing.client.android.BeepManager
import com.google.zxing.client.android.Intents
import com.journeyapps.barcodescanner.BarcodeCallback
import com.journeyapps.barcodescanner.BarcodeResult
import com.journeyapps.barcodescanner.DecoratedBarcodeView

class CaptureActivity : Activity() {
    private var lastBarcode = "INVALID_STRING_STATE"
    private lateinit var scannerView: DecoratedBarcodeView
    private val list = arrayListOf<String>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_capture)
        val isContinuous = intent.extras[keyIsContinuous] as Boolean
        val isBeep = intent.getBooleanExtra(Intents.Scan.BEEP_ENABLED, true)
        val interval = intent.extras[keyContinuousInterval] as? Int ?: 1000
        var lastTime = System.currentTimeMillis()
        val beepManager = BeepManager(this)
        scannerView = findViewById(R.id.scanner_view)
        scannerView.setStatusText("")
        list.clear()

        if (isContinuous) {
            scannerView.decodeContinuous(object : BarcodeCallback {
                override fun barcodeResult(result: BarcodeResult?) {
                    result?.text?.let {
                        val now = System.currentTimeMillis()
                        if (now - lastTime < interval && lastBarcode == it) {
                            return
                        }
                        if (isBeep) {
                            beepManager.playBeepSound()
                        }
                        lastBarcode = it
                        list.add(it)
                        lastTime = System.currentTimeMillis()
                    }
                }

                override fun possibleResultPoints(resultPoints: List<ResultPoint>) {
                }
            })
        } else {
            scannerView.decodeSingle(object : BarcodeCallback {
                override fun barcodeResult(result: BarcodeResult?) {
                    result?.text?.let {
                        if (isBeep) {
                            beepManager.playBeepSound()
                        }
                        list.add(it)
                        setResult()
                        finish()
                    }
                }

                override fun possibleResultPoints(resultPoints: List<ResultPoint>) {
                }
            })
        }
    }

    private fun setResult() {
        val data = Intent()
        data.putExtra("result", list)
        setResult(RESULT_OK, data)
    }

    override fun onBackPressed() {
        setResult()
        super.onBackPressed()
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