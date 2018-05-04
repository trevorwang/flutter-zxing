import Flutter
import UIKit
import LBXScan

let fzxing = "fzxing"

public class SwiftFzxingPlugin: NSObject, FlutterPlugin {
    let keyScan = "scan"
    
    private static var _registrar : FlutterPluginRegistrar!
    private var _rootViewController: UIViewController?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        _registrar = registrar
        let channel = FlutterMethodChannel(name: fzxing, binaryMessenger: registrar.messenger())
        let instance = SwiftFzxingPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self._rootViewController = UIApplication.shared.keyWindow?.rootViewController
        switch call.method {
        case keyScan:
            handleScan(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleScan(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let map = call.arguments as? Dictionary<String, Any>
        let isBeep = map?["isBeep"] as? Bool ?? false
        
        let vc = CaptureViewController()
        vc.isBeep = isBeep
        vc.scanResult =  {
            result($0)
        }
        
        let nav  = UINavigationController(rootViewController: vc)
        self._rootViewController?.present(nav, animated: true, completion: nil)
        
    }
}

