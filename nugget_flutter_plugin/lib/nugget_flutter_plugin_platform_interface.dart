import 'dart:ffi';

import 'package:nugget_flutter_plugin/models/nugget_business_context.dart';
import 'package:nugget_flutter_plugin/models/nugget_font_data.dart';
import 'package:nugget_flutter_plugin/models/nugget_theme_data.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'nugget_flutter_plugin_method_channel.dart';

// Export the necessary enums and data classes
export 'enums/NuggetInterfaceStyle.dart';
export 'enums/NuggetFontWeight.dart';
export 'enums/NuggetFontSize.dart';

abstract class NuggetFlutterPluginPlatform extends PlatformInterface {
  /// Constructs a NuggetFlutterPluginPlatform.
  NuggetFlutterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static NuggetFlutterPluginPlatform _instance =
      MethodChannelNuggetFlutterPlugin();

  /// The default instance of [NuggetFlutterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelNuggetFlutterPlugin].
  static NuggetFlutterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NuggetFlutterPluginPlatform] when
  /// they register themselves.
  static set instance(NuggetFlutterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes the Nugget SDK with necessary configurations.
  ///
  /// Must be called once before using other SDK features.
  Future<void> initialize(String namespace,
      NuggetBusinessContext? businessContext,
      NuggetFontData? fontData,
      NuggetThemeData? nuggetThemeData) {
    throw UnimplementedError('initialize() has not been implemented');
  }

  /// Start a chat session with the given user ID
  void startChat() {
    throw UnimplementedError('startChat() has not been implemented.');
  }

  /// Sending access token response to plugin
  void sendAccessTokenResponse(String accessToken , int httpCode , String requestId) {
    throw UnimplementedError('sendAccessTokenResponse() has not been implemented.');
  }

  /// Syncing FCM token with server
  void syncFCMToken(String token, bool notifsEnabled){
    throw UnimplementedError('syncFCMToken() has not been implemented.');
  }

  /// Stream providing the conversation ID when a ticket is successfully created.
  Stream<String> get onTicketCreationSucceeded {
    throw UnimplementedError(
        'onTicketCreationSucceeded has not been implemented.');
  }

  /// Stream providing an optional error message when ticket creation fails.
  Stream<String?> get onTicketCreationFailed {
    throw UnimplementedError(
        'onTicketCreationFailed has not been implemented.');
  }

  /// Stream providing push notification token updates
  Stream<String> get onTokenUpdated {
    throw UnimplementedError('onTokenUpdated has not been implemented.');
  }

  /// Stream providing push notification permission status updates
  Stream<int> get onPermissionStatusUpdated {
    throw UnimplementedError('onPermissionStatusUpdated has not been implemented.');
  }

  /// Opens the Nugget chat UI modally, optionally navigating to a specific
  /// state defined by the [customDeeplink].
  ///
  /// This method presents the native UIViewController directly.
  ///
  /// If the SDK is not initialized, this will likely fail.
  Future<void> openChatWithCustomDeeplink({required String customDeeplink}) {
    throw UnimplementedError(
        'openChatWithCustomDeeplink() has not been implemented');
  }
}
