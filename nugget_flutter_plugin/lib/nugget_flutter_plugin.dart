import 'package:nugget_flutter_plugin/models/nugget_font_data.dart';
import 'package:nugget_flutter_plugin/models/nugget_theme_data.dart';
import 'package:nugget_flutter_plugin/nugget_flutter_plugin_method_channel.dart';

import 'models/nugget_business_context.dart';
import 'nugget_flutter_plugin_platform_interface.dart';

// Export the handler setup so users can access it via the main plugin import.
// export 'nugget_plugin_callback_handler.dart';
export 'nugget_flutter_plugin_platform_interface.dart' show 
  NuggetInterfaceStyle,
  NuggetFontWeight, 
  NuggetFontSize;

class NuggetFlutterPlugin {
  /// Initializes the Nugget SDK with necessary configurations.
  /// Delegates to the platform-specific implementation.
  Future<void> initialize(String namespace,
      NuggetBusinessContext? businessContext,
      NuggetFontData? fontData,
      NuggetThemeData? themeData,
      bool? handleDeeplinkInsideApp) async {
    return NuggetFlutterPluginPlatform.instance.initialize(namespace, businessContext, fontData, themeData, handleDeeplinkInsideApp);
  }

  /// Stream providing the conversation ID when a ticket is successfully created.
  /// Listen to this stream to get notified of successful ticket creation.
  Stream<String> get onTicketCreationSucceeded =>
      NuggetFlutterPluginPlatform.instance.onTicketCreationSucceeded;

  /// Stream providing an optional error message when ticket creation fails.
  /// Listen to this stream to get notified of failed ticket creation attempts.
  Stream<String?> get onTicketCreationFailed => NuggetFlutterPluginPlatform.instance.onTicketCreationFailed;

  /// Stream providing push notification token updates.
  /// Listen to this stream to get notified of token updates.
  Stream<String> get onTokenUpdated => NuggetFlutterPluginPlatform.instance.onTokenUpdated;

  /// Stream providing push notification permission status updates.
  /// Listen to this stream to get notified of permission status changes.
  Stream<int> get onPermissionStatusUpdated => NuggetFlutterPluginPlatform.instance.onPermissionStatusUpdated;

  /// Cient passes the required Nugget deeplink to render SDK.
  /// This dart file delegates it to corresponding platform-specific implementation.
  Future<void> openChatWithCustomDeeplink({required String customDeeplink}) {
    return NuggetFlutterPluginPlatform.instance.openChatWithCustomDeeplink(
      customDeeplink: customDeeplink,
    );
  }

  /// Syncs client's FCM token with Nugget server.
  void syncFCMToken(String token, bool notifsEnabled){
    return NuggetFlutterPluginPlatform.instance.syncFCMToken(token, notifsEnabled);
  }

  /// Sends access token API response to Nugget server back.
  void sendAccessTokenResponse(String accessToken , int httpCode , String requestId) {
    return NuggetFlutterPluginPlatform.instance.sendAccessTokenResponse(accessToken, httpCode, requestId);
  }

  /// Checks the current dark theme status in client app and returns the same to native files
  void sendCurrentDarkThemeStatus(bool isDarkModeEnabled) {
    return NuggetFlutterPluginPlatform.instance.sendCurrentDarkThemeStatus(isDarkModeEnabled);
  }

}
