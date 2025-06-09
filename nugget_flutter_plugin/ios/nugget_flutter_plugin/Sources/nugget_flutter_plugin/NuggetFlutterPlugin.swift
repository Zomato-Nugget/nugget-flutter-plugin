import Flutter
import UIKit
import NuggetSDK

class FontProviderImpl: NuggetFontProviderDelegate {
    var customFontMapping: (any NuggetFontPropertiesMapping)?
    
    init(customFontMapping: (any NuggetFontPropertiesMapping)? = nil) {
        self.customFontMapping = customFontMapping
    }
}

class ThemeProviderImpl: NuggetThemeProviderDelegate {
    var defaultLightModeAccentHexColor: String
    var defaultDarktModeAccentHexColor: String
    var deviceInterfaceStyle: UIUserInterfaceStyle
    
    init(defaultLightModeAccentHexColor: String,
         defaultDarktModeAccentHexColor: String,
         deviceInterfaceStyle: UIUserInterfaceStyle) {
        self.defaultLightModeAccentHexColor = defaultLightModeAccentHexColor
        self.defaultDarktModeAccentHexColor = defaultDarktModeAccentHexColor
        self.deviceInterfaceStyle = deviceInterfaceStyle
    }
}

public class NuggetFlutterPlugin: NSObject, FlutterPlugin {
    
    private var nuggetAuthProvider: NuggetAuthProviderDelegate?
    private var notificationDelegate: NuggetPushNotificationsListener?
    private lazy var sdkConfigurationDelegate: NuggetSDkConfigurationDelegate = NuggetSDKConfigurationImplementation(channel: channel)
    private var customThemeProviderDelegate: NuggetThemeProviderDelegate?
    private var customFontProviderDelegate: NuggetFontProviderDelegate?
    private var businessContextProviderDelegate: NuggetBusinessContextProviderDelegate?
    private var ticketCreationDelegate: NuggetTicketCreationDelegate?
    
    private static var instance: NuggetFlutterPlugin?
    
    // Other properties
    let channel: FlutterMethodChannel
    var nuggetFactory: NuggetFactory?
    
    // Add property to retain chat view controller during presentation
    private var presentedChatViewController: UIViewController?
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "nugget_flutter_plugin", binaryMessenger: registrar.messenger())
        let instance = NuggetFlutterPlugin(channel: channel)
        Self.instance = instance
        
        // Create and set up the auth provider and notification delegate
        let authProvider = NuggetFlutterAuthProviderImp(channel: channel)
        instance.nuggetAuthProvider = authProvider
        
        // Create and set up the notification delegate
        instance.notificationDelegate = NuggetPushNotificationsListener(apnsToken: "")
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            handleInitialize(call: call, result: result)
        case "openChatWithCustomDeeplink":
            handleOpenChatWithCustomDeeplink(call: call, result: result)
        case "syncFCMToken":
            handleSyncFCMToken(call: call, result: result)
        case "accessTokenResponse":
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleInitialize(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let nuggetAuthProvider = Self.instance?.nuggetAuthProvider else {
            result(FlutterError(code: "INIT_FAILED", message: "Missing required nuggetAuthProvider delegate", details: nil))
            return
        }
        
        guard let notificationDelegate = Self.instance?.notificationDelegate else {
            result(FlutterError(code: "INIT_FAILED", message: "Missing required notification delegate", details: nil))
            return
        }
        
        guard let sdkConfigurationDelegate = Self.instance?.sdkConfigurationDelegate else {
            result(FlutterError(code: "INIT_FAILED", message: "Missing required delegate instances", details: nil))
            return
        }
        
        
        if let arguments = call.arguments as? [String: Any],
           let fontData = arguments["fontData"] as? [String: Any] {
            let fontMapping = NuggetFlutterFontSizeMapping(fromDictionary: fontData)
            customFontProviderDelegate = NuggetFlutterFontProviderImp(customFontMapping: fontMapping)
        } else {
            customFontProviderDelegate = nil
        }
        
        if let arguments = call.arguments as? [String: Any],
           let themeData = arguments["themeData"] as? [String: Any] {
            customThemeProviderDelegate = NuggetFluterThemeProviderImp(themeData: themeData)
        } else {
            customThemeProviderDelegate = nil
        }
        
        if let arguments = call.arguments as? [String: Any],
           let businessContext = arguments["businessContext"] as? [String: Any] {
            businessContextProviderDelegate = NuggetBusinessContextProviderImp(businessContext: businessContext)
        } else {
            businessContextProviderDelegate = nil
        }
        
        self.nuggetFactory = NuggetSDK.initializeNuggetFactory(
            authDelegate: nuggetAuthProvider,
            notificationDelegate: notificationDelegate,
            sdkConfigurationDelegate: sdkConfigurationDelegate,
            chatBusinessContextDelegate: businessContextProviderDelegate,
            customThemeProviderDelegate: customThemeProviderDelegate,
            customFontProviderDelegate: customFontProviderDelegate,
            ticketCreationDelegate: Self.instance?.ticketCreationDelegate
        )
        
        if self.nuggetFactory != nil {
            result(nil)
        } else {
            result(FlutterError(code: "INIT_FAILED", message: "Native NuggetSDK initialization returned nil", details: nil))
        }
    }
    
    private func handleOpenChatWithCustomDeeplink(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let customDeeplink = args["customDeeplink"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing required argument: customDeeplink", details: nil))
            return
        }
        
        // Validate current state and factory
        guard let currentInstance = Self.instance else {
            result(FlutterError(code: "INVALID_STATE", message: "Plugin instance not found", details: nil))
            return
        }
        
        guard let factory = currentInstance.nuggetFactory else {
            result(FlutterError(code: "NOT_INITIALIZED", message: "Nugget SDK is not initialized. Call initialize first.", details: nil))
            return
        }
        
        // Get chat view controller
        guard let chatViewController = factory.contentViewController(deeplink: customDeeplink) else {
            result(FlutterError(code: "FACTORY_ERROR", message: "Failed to create chat view controller", details: nil))
            return
        }
        
        // Ensure UI updates happen on main thread
        DispatchQueue.main.async {
            // Find the root view controller
            guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
                  let rootViewController = keyWindow.rootViewController else {
                result(FlutterError(code: "UI_ERROR", message: "Could not find root view controller", details: nil))
                return
            }
            
            // Get the topmost view controller
            var topmostViewController = rootViewController
            while let presented = topmostViewController.presentedViewController {
                topmostViewController = presented
            }
            
            // Handle different presentation styles based on container type
            if let navigationController = topmostViewController as? UINavigationController {
                // Push if we're in a navigation controller
                navigationController.pushViewController(chatViewController, animated: true)
                result(nil)
            } else if let navigationController = topmostViewController.navigationController {
                // Push if the topmost has a navigation controller
                navigationController.pushViewController(chatViewController, animated: true)
                result(nil)
            } else {
                // Present modally if no navigation controller is available
                chatViewController.modalPresentationStyle = .fullScreen
                
                // Retain strong reference to chat view controller until presentation is complete
                currentInstance.presentedChatViewController = chatViewController
                
                topmostViewController.present(chatViewController, animated: true) { [weak currentInstance] in
                    // Clear reference after presentation
                    currentInstance?.presentedChatViewController = nil
                    result(nil)
                }
            }
        }
    }
    
    private func handleSyncFCMToken(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            return
        }
        let token = args["fcmToken"] as? String ?? ""
        let isNotificationsEnabled = args["notifsEnabled"] as? Bool ?? false
        self.notificationDelegate?.tokenUpdated(to: token)
        self.notificationDelegate?.permissionStatusUpdated(to: isNotificationsEnabled ? .authorized : .denied)
    }
}
