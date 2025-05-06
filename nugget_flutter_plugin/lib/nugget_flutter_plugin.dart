import 'nugget_flutter_plugin_platform_interface.dart';

// Export the handler setup so users can access it via the main plugin import.
export 'nugget_plugin_callback_handler.dart';
export 'nugget_flutter_plugin_platform_interface.dart' show 
  NuggetThemeData, 
  NuggetFontData, 
  NuggetPushPermissionStatus, 
  NuggetInterfaceStyle, 
  NuggetFontWeight, 
  NuggetFontSize,
  NuggetAuthProviderDelegate; // Updated to use NuggetAuthProviderDelegate

// Export the native view widget
export 'nugget_chat_view.dart';

// Export the auth provider delegate
export 'nugget_auth_provider_delegate.dart';

class NuggetFlutterPlugin {

  /// Initializes the Nugget SDK with necessary configurations.
  ///
  /// Delegates to the platform-specific implementation.
  Future<void> initialize({
    NuggetThemeData? theme,
    NuggetFontData? font,
  }) {
    // Pass parameters, converting optional data classes to Maps using toJson
    return NuggetFlutterPluginPlatform.instance.initialize(
      theme: theme,
      font: font,
    );
  }

  /// Stream providing the latest APNS token as a String.
  /// Listen to this stream to get notified when the push token changes.
  Stream<String> get onTokenUpdated => NuggetFlutterPluginPlatform.instance.onTokenUpdated;

  /// Stream providing the latest push notification permission status.
  /// Listen to this stream to get notified when the permission status changes.
  Stream<NuggetPushPermissionStatus> get onPermissionStatusUpdated => NuggetFlutterPluginPlatform.instance.onPermissionStatusUpdated;

  /// Stream providing the conversation ID when a ticket is successfully created.
  /// Listen to this stream to get notified of successful ticket creation.
  Stream<String> get onTicketCreationSucceeded => NuggetFlutterPluginPlatform.instance.onTicketCreationSucceeded;

  /// Stream providing an optional error message when ticket creation fails.
  /// Listen to this stream to get notified of failed ticket creation attempts.
  Stream<String?> get onTicketCreationFailed => NuggetFlutterPluginPlatform.instance.onTicketCreationFailed;

  /// Opens the Nugget chat UI modally, optionally navigating to a specific
  /// state defined by the [customDeeplink].
  /// 
  /// Delegates to the platform-specific implementation.
  Future<void> openChatWithCustomDeeplink({required String customDeeplink}) {
    return NuggetFlutterPluginPlatform.instance.openChatWithCustomDeeplink(
      customDeeplink: customDeeplink,
    );
  }
}
