import Flutter
import UIKit
import LBXScan
    
public class SwiftFzxingPlugin: NSObject, FlutterPlugin {
    let keyScan = "scan"
    private static var _registrar : FlutterPluginRegistrar!
    private var _rootViewController: UIViewController!
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        _registrar = registrar
        let channel = FlutterMethodChannel(name: "fzxing", binaryMessenger: registrar.messenger())
        let instance = SwiftFzxingPlugin()
        instance._rootViewController = UIApplication.shared.delegate?.window??.rootViewController
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case keyScan:
            handleScan(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleScan(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let vc = CaptureViewController()
        
        let style = LBXScanViewStyle()
        style.photoframeAngleStyle = .outer
        style.anmiationStyle = .lineMove
        vc.style = style
        vc.libraryType = SCANLIBRARYTYPE.SLT_ZXing
        vc.scanResult =  {
            result($0)
        }
        _rootViewController.present(vc, animated: true)
    }
}

