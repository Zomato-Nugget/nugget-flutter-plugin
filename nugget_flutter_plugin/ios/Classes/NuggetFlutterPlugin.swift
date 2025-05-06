import Flutter
import UIKit

public class NuggetFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "nugget_flutter_plugin", binaryMessenger: registrar.messenger())
        let instance = NuggetFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            // Initialize Nugget SDK
            result(nil)
            
        case "openChatWithCustomDeeplink":
            if let args = call.arguments as? [String: Any],
               let customDeeplink = args["customDeeplink"] as? String {
                // Open chat with the provided deeplink
                if let url = URL(string: customDeeplink) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:]) { success in
                            if success {
                                result(nil)
                            } else {
                                result(FlutterError(code: "OPEN_URL_FAILED",
                                                  message: "Failed to open URL",
                                                  details: nil))
                            }
                        }
                    } else {
                        result(FlutterError(code: "INVALID_URL",
                                          message: "Cannot open URL: \(customDeeplink)",
                                          details: nil))
                    }
                } else {
                    result(FlutterError(code: "INVALID_URL",
                                      message: "Invalid URL format",
                                      details: nil))
                }
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT",
                                  message: "customDeeplink is required",
                                  details: nil))
            }
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
} 