import Flutter
import UIKit
import NuggetSDK

<<<<<<< HEAD
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
    private var tokenHandler: NuggetFlutterPluginEventStreamHandler?
    
    private static var instance: NuggetFlutterPlugin?
    
    // Other properties
    let channel: FlutterMethodChannel
    var nuggetFactory: NuggetFactory?

    // permissionHandler remains internally managed as it's specific to plugin's event channels not SDK init
    private let permissionHandler = NuggetFlutterPluginEventStreamHandler()
    
    private var tokenObserver: NSObjectProtocol?
    private var permissionObserver: NSObjectProtocol?
    
    // Add property to retain chat view controller during presentation
    private var presentedChatViewController: UIViewController?
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
        addNotificationObservers()
    }
    
    private func addNotificationObservers() {
        let tokenNotificationName = Notification.Name("AppDidReceivePushToken")
        let permissionNotificationName = Notification.Name("AppPushPermissionStatusUpdated")
        
        tokenObserver = NotificationCenter.default.addObserver(forName: tokenNotificationName, object: nil, queue: nil) { [weak self] notification in
            if let token = notification.userInfo?["token"] as? String {
                self?.tokenHandler?.sendEvent(data: token)
            }
        }
        
        permissionObserver = NotificationCenter.default.addObserver(forName: permissionNotificationName, object: nil, queue: nil) { [weak self] notification in
            if let status = notification.userInfo?["status"] as? Int {
                self?.permissionHandler.sendEvent(data: status)
            }
        }
    }
    
=======
// Define constants for method channel names and arguments
// ... existing code ...

// Conform to FlutterPlugin and the required NuggetSDK delegates
public class NuggetFlutterPlugin: NSObject, FlutterPlugin, 
                                    NuggetAuthProviderDelegate, 
                                    NuggetThemeProviderDelegate, // Use the actual protocol name
                                    NuggetFontProviderDelegate,  // Use the actual protocol name
                                    NuggetTicketCreationDelegate { // <-- REMOVED Push Delegate
    
    // Hold the channel for sending messages back to Dart
    let channel: FlutterMethodChannel
    // Hold the factory instance returned by the SDK initialization
    var nuggetFactory: NuggetFactory? // Assuming NuggetFactory is the type returned
    // Store theme/font data if needed for delegates
    var themeDataMap: [String: Any]?
    var fontDataMap: [String: Any]?
    
    // --- ADDED: Stream Handlers ---
    private let ticketSuccessHandler = EventStreamHandler()
    private let ticketFailureHandler = EventStreamHandler()
    private let tokenHandler = EventStreamHandler()          // <-- ADDED
    private let permissionHandler = EventStreamHandler()     // <-- ADDED
    // TODO: Add handlers for token and permission status later
    // private let tokenHandler = BasicStreamHandler<String>()
    // private let permissionHandler = BasicStreamHandler<Int>()
    // --- END ADDED ---

    // --- Notification Observers ---
    private var tokenObserver: NSObjectProtocol?
    private var permissionObserver: NSObjectProtocol?
    // --- END Notification Observers ---

    // Initializer to store the channel
    init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
        // Add observers when the plugin instance is created
        addNotificationObservers()
    }

    // --- ADDED: NotificationCenter Handling ---
    private func addNotificationObservers() {
        // Define Notification names locally (or import if defined globally)
        let tokenNotificationName = Notification.Name("AppDidReceivePushToken")
        let permissionNotificationName = Notification.Name("AppPushPermissionStatusUpdated")

        tokenObserver = NotificationCenter.default.addObserver(forName: tokenNotificationName, object: nil, queue: nil) { [weak self] notification in
            print("NuggetFlutterPlugin received AppDidReceivePushToken notification")
            if let token = notification.userInfo?["token"] as? String {
                self?.tokenHandler.sendEvent(data: token)
            } else {
                print("NuggetFlutterPlugin Error: Could not extract token from notification")
            }
        }

        permissionObserver = NotificationCenter.default.addObserver(forName: permissionNotificationName, object: nil, queue: nil) { [weak self] notification in
            print("NuggetFlutterPlugin received AppPushPermissionStatusUpdated notification")
            if let status = notification.userInfo?["status"] as? Int { // Assuming status is Int
                self?.permissionHandler.sendEvent(data: status)
            } else {
                 print("NuggetFlutterPlugin Error: Could not extract status from notification")
            }
        }
    }

>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
    private func removeNotificationObservers() {
        if let observer = tokenObserver {
            NotificationCenter.default.removeObserver(observer)
            tokenObserver = nil
        }
        if let observer = permissionObserver {
            NotificationCenter.default.removeObserver(observer)
            permissionObserver = nil
        }
    }
<<<<<<< HEAD
    
    deinit {
        removeNotificationObservers()
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
    
=======

    deinit {
        // Ensure observers are removed when the plugin instance is deallocated
        removeNotificationObservers()
    }
    // --- END NotificationCenter Handling ---

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "nugget_flutter_plugin", binaryMessenger: registrar.messenger())
        // Create instance, passing the channel
        let instance = NuggetFlutterPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)

        // --- ADDED: Event Channels for Native -> Dart streams ---
        let ticketSuccessEventChannel = FlutterEventChannel(name: "nugget_flutter_plugin/onTicketCreationSucceeded", binaryMessenger: registrar.messenger())
        ticketSuccessEventChannel.setStreamHandler(instance.ticketSuccessHandler)
        
        let ticketFailureEventChannel = FlutterEventChannel(name: "nugget_flutter_plugin/onTicketCreationFailed", binaryMessenger: registrar.messenger())
        ticketFailureEventChannel.setStreamHandler(instance.ticketFailureHandler)
        
        // Register token and permission channels
        let tokenEventChannel = FlutterEventChannel(name: "nugget_flutter_plugin/onTokenUpdated", binaryMessenger: registrar.messenger())
        tokenEventChannel.setStreamHandler(instance.tokenHandler)
        
        let permissionEventChannel = FlutterEventChannel(name: "nugget_flutter_plugin/onPermissionStatusUpdated", binaryMessenger: registrar.messenger())
        permissionEventChannel.setStreamHandler(instance.permissionHandler)
        // --- END ADDED ---

        // Register the Platform View Factory
        let viewFactory = NuggetChatViewFactory(messenger: registrar.messenger(), pluginInstance: instance)
        registrar.register(viewFactory, withId: "com.yourcompany.nugget/chat_view") // Must match viewType in Dart
    }
    
    // Handle calls FROM Dart
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            handleInitialize(call: call, result: result)
        case "openChatWithCustomDeeplink":
            handleOpenChatWithCustomDeeplink(call: call, result: result)
<<<<<<< HEAD
        case "syncFCMToken":
            handleSyncFCMToken(call: call, result: result)
        case "accessTokenResponse":
            break
=======
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
        default:
            result(FlutterMethodNotImplemented)
        }
    }
<<<<<<< HEAD
    
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
=======

    // --- Method Call Handlers --- 

    private func handleInitialize(call: FlutterMethodCall, result: @escaping FlutterResult) {
        // Ensure args is a dictionary, but don't require apiKey
        guard let args = call.arguments as? [String: Any] else {
            // Return a generic invalid arguments error if casting fails
            result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments received for initialize method", details: nil))
            return
        }
        
        // Store theme/font data if provided
        self.themeDataMap = args["theme"] as? [String: Any]
        self.fontDataMap = args["font"] as? [String: Any]
        
        print("NuggetFlutterPlugin Swift: Initializing NuggetSDK...")
        
        // *** TODO: Create a separate instance for NuggetPushNotificationsListener ***
        // let notificationListener = ... // This needs to be created and managed
        // let notificationListener = NuggetPushListener() // Create an instance <- COMMENTED OUT
        
        // Call the native SDK initialization
        // IMPORTANT: Pass `self` for delegates the plugin implements
        // *** TODO: Update the notificationDelegate argument below ***
        self.nuggetFactory = NuggetSDK.initializeNuggetFactory(
            authDelegate: self, 
            notificationDelegate: NuggetPushNotificationsListener(),
            customThemeProviderDelegate: self,
            customFontProviderDelegate: self, 
            ticketCreationDelegate: self 
        )

        if self.nuggetFactory != nil {
             print("NuggetFlutterPlugin Swift: NuggetSDK Initialized Successfully.")
            result(nil) // Indicate success to Dart
        } else {
             print("NuggetFlutterPlugin Swift: NuggetSDK Initialization Failed.")
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
            result(FlutterError(code: "INIT_FAILED", message: "Native NuggetSDK initialization returned nil", details: nil))
        }
    }

    private func handleOpenChatWithCustomDeeplink(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let customDeeplink = args["customDeeplink"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing required argument: customDeeplink", details: nil))
            return
        }
        
<<<<<<< HEAD
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
=======
        print("NuggetFlutterPlugin Swift: Opening chat with deeplink: \(customDeeplink)")

        guard let factory = self.nuggetFactory else {
             print("NuggetFlutterPlugin Swift: Error - NuggetFactory is not initialized.")
            result(FlutterError(code: "NOT_INITIALIZED", message: "Nugget SDK is not initialized. Call initialize first.", details: nil))
            return
        }

        // Get the chat view controller from the SDK factory
        // Assuming the method exists and returns a UIViewController
        guard let chatViewController = factory.contentViewController(deeplink: customDeeplink) else {
            print("NuggetFlutterPlugin Swift: Error - Failed to get contentViewController from NuggetFactory.")
            result(FlutterError(code: "FACTORY_ERROR", message: "Failed to retrieve chat view controller from NuggetFactory", details: nil))
            return
        }
        
        // Present the view controller
        DispatchQueue.main.async {
            guard let rootViewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
                 print("NuggetFlutterPlugin Swift: Error - Could not find root view controller.")
                result(FlutterError(code: "UI_ERROR", message: "Could not find root view controller to present/push chat", details: nil))
                return
            }
            
            // Attempt to find the topmost navigation controller
            var topNavController: UINavigationController? = nil
            var currentVC = rootViewController
            while let presented = currentVC.presentedViewController {
                currentVC = presented
            }
            
            if let navController = currentVC as? UINavigationController {
                topNavController = navController
            } else if let tabBarController = currentVC as? UITabBarController, 
                      let selectedNavController = tabBarController.selectedViewController as? UINavigationController {
                topNavController = selectedNavController
            } else {
                // If root itself isn't a nav controller, check its children (might be embedded)
                topNavController = currentVC.children.compactMap { $0 as? UINavigationController }.first
            }

            // Push if a navigation controller is found, otherwise present modally
            if let navController = topNavController {
                 print("NuggetFlutterPlugin Swift: Found UINavigationController. Pushing chat view controller...")
                navController.pushViewController(chatViewController, animated: true)
                result(nil) // Indicate success back to Dart
            } else {
                 print("NuggetFlutterPlugin Swift: No UINavigationController found. Presenting modally as fallback...")
                // Fallback to modal presentation
                chatViewController.modalPresentationStyle = .fullScreen // Or .automatic, .pageSheet etc.
                rootViewController.present(chatViewController, animated: true) {
                     print("NuggetFlutterPlugin Swift: Chat view controller presented modally (fallback).")
                    result(nil) // Indicate success back to Dart (even though it was modal)
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
                }
            }
        }
    }

<<<<<<< HEAD
    private func handleSyncFCMToken(call: FlutterMethodCall, result: @escaping FlutterResult) {
         guard let args = call.arguments as? [String: Any] else {
            return
         }
         let token = args["fcmToken"]
         let isNotificationsEnabled = args["notifsEnabled"]
         self.tokenHandler?.sendEvent(data: token)
         self.permissionHandler.sendEvent(data: isNotificationsEnabled)
    }
}
=======
   // MARK: - NuggetAuthProviderDelegate Implementation
    public func authManager(requiresAuthInfo completion: @escaping (NuggetAuthUserInfo?, Error?) -> Void) {
        print("NuggetFlutterPlugin Swift: Delegate method requiresAuthInfo called by SDK. Ensuring call to Dart is on main thread...")
        // Ensure the invokeMethod call happens on the main thread
        DispatchQueue.main.async { // <-- WRAP HERE
            self.channel.invokeMethod("requireAuthInfo", arguments: nil) { flutterResult in
                // ADD PRINT: Confirm this callback block is executed
                print("NuggetFlutterPlugin Swift: invokeMethod callback received for requireAuthInfo. Result type: \(type(of: flutterResult))")
                // The result handler from Flutter might not be on main thread,
                // Call handleAuthCompletion directly from here
                self.handleAuthCompletion(flutterResult: flutterResult, sdkCompletion: completion)
            }
        } // <-- END WRAP
    }

     public func authManager(requestRefreshAuthInfo completion: @escaping (NuggetAuthUserInfo?, Error?) -> Void) {
        print("NuggetFlutterPlugin Swift: Delegate method requestRefreshAuthInfo called by SDK. Ensuring call to Dart is on main thread...")
        // Ensure the invokeMethod call happens on the main thread
        DispatchQueue.main.async { // <-- WRAP HERE
            self.channel.invokeMethod("refreshAuthInfo", arguments: nil) { flutterResult in
                print("NuggetFlutterPlugin Swift: invokeMethod callback received for refreshAuthInfo. Result type: \(type(of: flutterResult))") // Added log for consistency
                 // Call handleAuthCompletion directly from here
                 self.handleAuthCompletion(flutterResult: flutterResult, sdkCompletion: completion)
            }
        } // <-- END WRAP
    }
    
    // handleAuthCompletion remains unchanged, but the comment about its thread is less relevant
    // as we now ensure it's called on the main thread from the invokeMethod result handler.
    private func handleAuthCompletion(flutterResult: Any?, sdkCompletion: @escaping (NuggetAuthUserInfo?, Error?) -> Void) {
        // ADD PRINT: Confirm function entry
        print("NuggetFlutterPlugin Swift: Entering handleAuthCompletion.")

        guard let resultData = flutterResult else {
             print("NuggetFlutterPlugin Swift: Auth completion - Dart returned nil result (unexpected).")
             let error = NSError(domain: "PluginError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Auth failed: Dart returned nil"])
             sdkCompletion(nil, error)
             return
         }

         // ADD THIS PRINT: Log the raw result
         print("NuggetFlutterPlugin Swift: Auth completion - Received flutterResult: \(resultData)")

         if let error = resultData as? FlutterError {
             print("NuggetFlutterPlugin Swift: Auth completion - Dart returned error: \(error.code) - \(error.message ?? "")")
             // Convert FlutterError to NSError for the SDK completion handler
             let nsError = NSError(domain: "FlutterError", 
                                 code: Int(error.code) ?? -1, 
                                 userInfo: [NSLocalizedDescriptionKey: error.message ?? "Error from Dart auth",
                                            "FlutterErrorDetails": error.details ?? "N/A"])
             sdkCompletion(nil, nsError)
         } else if let dict = resultData as? [String: Any] {
             // ADD THIS PRINT: Log the dictionary before parsing
             print("NuggetFlutterPlugin Swift: Auth completion - Dart returned data. Attempting to parse dictionary: \(dict)") 
             // Attempt to parse the dictionary using the Swift struct
             // *** TODO: Verify SwiftNuggetAuthUserInfo matches NuggetAuthUserInfo protocol ***
             if let userInfo = SwiftNuggetAuthUserInfo(fromDictionary: dict) {
                  print("NuggetFlutterPlugin Swift: Auth completion - Parsed successfully.")
                 sdkCompletion(userInfo, nil) // SUCCESS! Call SDK completion with Swift object
             } else {
                 print("NuggetFlutterPlugin Swift: Auth completion - Failed to parse dictionary from Dart.")
                 let error = NSError(domain: "PluginError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Auth failed: Could not parse auth info from Dart"])
                 sdkCompletion(nil, error)
             }
         } else {
              print("NuggetFlutterPlugin Swift: Auth completion - Dart returned unexpected type: \(type(of: resultData))")
              let error = NSError(domain: "PluginError", code: -4, userInfo: [NSLocalizedDescriptionKey: "Auth failed: Received unexpected data type from Dart"])
              sdkCompletion(nil, error)
         }
    }

    // MARK: - NuggetTicketCreationDelegate Implementation
    public func ticketCreationSucceeded(with conversationID: String) {
        print("NuggetFlutterPlugin Swift: Delegate ticketCreationSucceeded. Sending event to Dart...")
        ticketSuccessHandler.sendEvent(data: conversationID)
    }

    public func ticketCreationFailed(withError errorMessage: String?) {
        print("NuggetFlutterPlugin Swift: Delegate ticketCreationFailed. Sending event to Dart...")
        ticketFailureHandler.sendEvent(data: errorMessage)
    }
    
    // MARK: - NuggetThemeProviderDelegate Implementation 
    // *** TODO: Verify actual protocol requirements ***
    public var customThemePaletteString: String? {
        return self.themeDataMap?["paletteHexString"] as? String
    }
    
    public var customThemeTintString: String? {
        return self.themeDataMap?["tintColorHex"] as? String
    }
    
    public var interfaceStyle: UIUserInterfaceStyle {
        guard let styleString = self.themeDataMap?["interfaceStyle"] as? String else {
            return .unspecified // Default if not provided or invalid
        }
        switch styleString {
            case "light": return .light
            case "dark": return .dark
            default: return .unspecified // Maps Dart 'system' to unspecified
        }
    }

    // MARK: - NuggetFontProviderDelegate Implementation
    // *** TODO: Verify FontPropertiesMapping protocol requirements ***
    public var customFontMapping: NuggetFontPropertiesMapping? {
        guard let fontMap = self.fontDataMap else {
            return nil
        }
        return SwiftNuggetFontMapping(fromDictionary: fontMap)
    }
}

// Placeholder class for the push notification listener
/*  <- COMMENT OUT START
class NuggetPushListener: NuggetPushNotificationsListener {
    // TODO: Implement required methods if any, and add logic 
    //       to communicate back to NuggetFlutterPlugin (e.g., via closures or NotificationCenter)
    // For now, just providing a basic class instance.
    override init() {
        super.init()
        print("NuggetPushListener initialized")
    }
    
    // Example of potential methods (replace with actual required methods)
    // override func onTokenUpdated(token: String) { ... }
    // override func onPermissionStatusUpdated(granted: Bool) { ... }
}
*/ // <- COMMENT OUT END

// MARK: - Platform View Factory
class NuggetChatViewFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger
    private weak var pluginInstance: NuggetFlutterPlugin?

    init(messenger: FlutterBinaryMessenger, pluginInstance: NuggetFlutterPlugin) {
        self.messenger = messenger
        self.pluginInstance = pluginInstance
        super.init()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return NuggetChatPlatformView(frame: frame, 
                                      viewIdentifier: viewId, 
                                      arguments: args, 
                                      pluginInstance: pluginInstance)
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

// MARK: - Platform View
class NuggetChatPlatformView: NSObject, FlutterPlatformView {
    private let _view: UIView
    private var chatViewController: UIViewController?

    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, pluginInstance: NuggetFlutterPlugin?) {
        _view = UIView(frame: frame)
        _view.backgroundColor = .lightGray 
        super.init()

        guard let factory = pluginInstance?.nuggetFactory else {
            print("NuggetChatPlatformView Error: NuggetFactory not available.")
            // ... add error label ...
            return
        }

        // Parse arguments to get deeplink, default to empty string if not provided
        let creationArgs = args as? [String: Any]
        let deeplink = creationArgs?["deeplink"] as? String ?? "" // Default to empty string
        print("NuggetChatPlatformView: Initializing with deeplink: '\(deeplink)'")

        // Get the Chat View Controller from the Nugget SDK Factory using the deeplink
        guard let chatVC = factory.contentViewController(deeplink: deeplink) else { 
             print("NuggetChatPlatformView Error: Failed to get chat view controller from factory.contentViewController(deeplink:).")
             // TODO: Add error display to _view
             return
        }
        
        self.chatViewController = chatVC
        
        // Add the native view controller's view to our container view
        if let chatView = chatVC.view {
            chatView.frame = _view.bounds 
            // Fix: Explicitly specify UIView.AutoresizingMask
            chatView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            _view.addSubview(chatView)
             print("NuggetChatPlatformView: Native chat view added.")
        } else {
            print("NuggetChatPlatformView Error: Chat view controller's view is nil.")
            // TODO: Add error display to _view
        }
    }

    func view() -> UIView {
        return _view
    }
    
    deinit {
         print("NuggetChatPlatformView: Deinit")
    }
}

// MARK: - Swift Data Structures

// *** TODO: Verify this matches NuggetAuthUserInfo protocol ***
struct SwiftNuggetAuthUserInfo: NuggetAuthUserInfo {
    let clientID: Int
    let accessToken: String
    let userID: String
    let userName: String? // MADE OPTIONAL
    let photoURL: String
    let displayName: String
    
    init?(fromDictionary dict: [String: Any]) {
        // ADD THESE PRINTS: Log dictionary and raw token value/type
        print("SwiftNuggetAuthUserInfo init: Attempting to parse dict: \(dict)")
        let rawToken = dict["accessToken"]
        print("SwiftNuggetAuthUserInfo init: Raw value for key 'accessToken': \(String(describing: rawToken)), Type: \(type(of: rawToken))")

        guard let clientID = dict["clientID"] as? Int,
              let accessToken = dict["accessToken"] as? String,
              let userID = dict["userID"] as? String, 
              let photoURL = dict["photoURL"] as? String,
              let displayName = dict["displayName"] as? String
        else {
            print("SwiftNuggetAuthUserInfo: Failed to parse dictionary from Dart (Guard failed)") // Added note
            return nil
        }
        self.clientID = clientID
        self.accessToken = accessToken
        self.userID = userID
        self.userName = dict["userName"] as? String // Assign optional value
        self.photoURL = photoURL
        self.displayName = displayName
        print("SwiftNuggetAuthUserInfo init: Parsing successful.") // Added success log
    }
}

// *** TODO: Verify this matches NuggetFontPropertiesMapping protocol ***
class SwiftNuggetFontMapping: NuggetFontPropertiesMapping {
    let fontName: String
    let fontFamily: String
    let fontWeightMapping: [NuggetFontWeights : String]
    let fontSizeMappingDict: [String: Int]
    
    init?(fromDictionary dict: [String: Any]) {
        guard let fontName = dict["fontName"] as? String,
              let fontFamily = dict["fontFamily"] as? String,
              let rawWeightMap = dict["fontWeightMapping"] as? [String: String],
              let rawSizeMap = dict["fontSizeMapping"] as? [String: Int]
        else {
            print("SwiftNuggetFontMapping: Failed to parse dictionary from Dart")
            return nil
        }
        self.fontName = fontName
        self.fontFamily = fontFamily
        self.fontSizeMappingDict = rawSizeMap
        
        var finalWeightMap: [NuggetFontWeights: String] = [:]
        for (key, value) in rawWeightMap {
            if let weightEnum = NuggetFontWeights(string: key) {
                finalWeightMap[weightEnum] = value
            } else {
                 print("SwiftNuggetFontMapping: Warning - Unknown font weight key '\(key)' from Dart")
            }
        }
        self.fontWeightMapping = finalWeightMap
    }
    
    func fontSizeMapping(fontSize: NuggetFontSizes) -> Int {
        let key = fontSize.stringValue 
        return fontSizeMappingDict[key] ?? 14
    }
}

// *** TODO: Verify these extensions match SDK enums/protocols ***
extension NuggetFontWeights {
    init?(string: String) {
        switch string.lowercased() {
            case "light": self = .light
            case "regular": self = .regular
            case "medium": self = .medium
            case "semibold": self = .semiBold 
            case "bold": self = .bold
            case "extrabold": self = .extraBold
            case "black": self = .black
            default: return nil
        }
    }
}

extension NuggetFontSizes {
    var stringValue: String {
        switch self {
            case .font050: return "font050"
            case .font100: return "font100"
            case .font200: return "font200"
            case .font300: return "font300"
            case .font400: return "font400"
            case .font500: return "font500"
            case .font600: return "font600"
            case .font700: return "font700"
            case .font800: return "font800"
            case .font900: return "font900"
        }
    }
}

// --- ADDED: Generic Stream Handler ---
/// A basic stream handler that stores the event sink and provides a method to send events.
class EventStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    /// Called when Flutter starts listening.
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        print("TicketStreamHandler: onListen called")
        self.eventSink = events
        return nil // No error
    }

    /// Called when Flutter stops listening.
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("TicketStreamHandler: onCancel called")
        self.eventSink = nil
        return nil // No error
    }

    /// Sends data to the Flutter side via the event sink.
    /// Make sure `onListen` has been called before sending events.
    func sendEvent(data: Any?) {
        guard let sink = self.eventSink else {
            print("TicketStreamHandler: Warning - eventSink is nil. Cannot send event.")
            return
        }
        // Ensure we send on the main thread if needed, though EventChannel handles this often
        DispatchQueue.main.async {
            sink(data)
        }
    }
}
// --- END ADDED ---
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
