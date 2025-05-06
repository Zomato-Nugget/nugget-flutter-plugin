import Flutter
import UIKit
import UserNotifications
// Make sure NuggetSDK is imported if needed by GeneratedPluginRegistrant or other logic
// import NuggetSDK 

// Define Notification names
extension Notification.Name {
    static let AppDidReceivePushToken = Notification.Name("AppDidReceivePushToken")
    static let AppPushPermissionStatusUpdated = Notification.Name("AppPushPermissionStatusUpdated")
}

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Proceed with default Flutter plugin registration FIRST
    GeneratedPluginRegistrant.register(with: self)

    // Request notification permission and register
    self.registerForPushNotifications()

    // Get the FlutterViewController created by FlutterAppDelegate
    guard let controller = window?.rootViewController as? FlutterViewController else {
      fatalError("rootViewController is not type FlutterViewController")
    }

    // Create a UINavigationController with the FlutterViewController as its root
    let navigationController = UINavigationController(rootViewController: controller)
    // Optionally hide the navigation bar if Flutter handles all navigation UI.
    // You might want to keep it visible if you expect native screens (like the chat)
    // to show a navigation bar with a back button.
    // navigationController.isNavigationBarHidden = true 

    // Set the UINavigationController as the window's root view controller
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible() // Ensure the window is set up correctly

    // Call the superclass implementation AFTER setting up the rootViewController
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // --- Push Notification Registration --- 
  
  func registerForPushNotifications() {
      UNUserNotificationCenter.current().delegate = self // Set delegate for foreground notifications
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
          print("Permission granted: \(granted)")
          guard granted else { return }
          // Optional: Update permission status stream immediately after request
          self?.getNotificationSettings()
          // Register with APNs on main thread
          DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
          }
      }
  }
  
  func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
          print("Notification settings: \(settings)")
          // Post notification with status
          let status = settings.authorizationStatus.rawValue
          NotificationCenter.default.post(
              name: .AppPushPermissionStatusUpdated,
              object: nil,
              userInfo: ["status": status]
          )
      }
  }

  // --- AppDelegate Push Notification Callbacks --- 

  override func application(_ application: UIApplication, 
                           didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let tokenString = tokenParts.joined()
      print("Device Token: \(tokenString)")
      
      // Post notification with token string
      NotificationCenter.default.post(
          name: .AppDidReceivePushToken, 
          object: nil, 
          userInfo: ["token": tokenString]
      )
  }

  override func application(_ application: UIApplication, 
                           didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register for remote notifications: \(error.localizedDescription)")
      // Optional: Send error to Flutter
      // if let plugin = self.getNuggetFlutterPlugin() {
      //     plugin.tokenHandler.sendEvent(data: FlutterError(code: "TOKEN_ERROR", message: error.localizedDescription, details: nil))
      // }
  }
  
  // --- UNUserNotificationCenterDelegate Methods (Now inside AppDelegate class) ---
  // Receive displayed notifications for iOS 10 devices.
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    print("Will present notification: \(userInfo)")
    // TODO: Handle foreground notification - maybe show alert, maybe pass to Flutter?
    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]]) // .badge? .list? etc.
  }

  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    print("Did receive notification response: \(userInfo)")
    // TODO: Handle notification tap - maybe navigate in Flutter?
    completionHandler()
  }
}
