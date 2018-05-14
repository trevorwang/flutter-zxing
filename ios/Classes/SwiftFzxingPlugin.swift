import Flutter
import UIKit
import LBXScan

public class SwiftFzxingPlugin: NSObject, FlutterPlugin {
    
    private static var _registrar : FlutterPluginRegistrar!
    private var _rootViewController: UIViewController?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        _registrar = registrar
        let channel = FlutterMethodChannel(name: "fzxing", binaryMessenger: registrar.messenger())
        let instance = SwiftFzxingPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self._rootViewController = UIApplication.shared.keyWindow?.rootViewController
        switch call.method {
        case "scan":
            handleScan(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleScan(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let map = call.arguments as? Dictionary<String, Any>
        let isBeep = map?["isBeep"] as? Bool ?? false
        let isContinuous = map?["isContinuous"] as? Bool ?? false
        let continuousInterval = map?["continuousInterval"] as? Int ?? 1000
        
        let vc = CaptureViewController()
        vc.isBeep = isBeep
        vc.isContinuous = isContinuous
        vc.continuousInterval = continuousInterval
        vc.scanResult =  {
            print($0)
            result($0)
        }
        
        let nav  = UINavigationController(rootViewController: vc)
        self._rootViewController?.present(nav, animated: true, completion: nil)
        
    }
}

