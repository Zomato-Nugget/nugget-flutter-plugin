import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nugget_flutter_plugin/models/nugget_business_context.dart';
import 'package:nugget_flutter_plugin/models/nugget_font_data.dart';
import 'package:nugget_flutter_plugin/models/nugget_theme_data.dart';
import 'dart:async';
import 'dart:collection';

import 'interface/nugget_auth_provider_delegate.dart';
import 'nugget_flutter_plugin_platform_interface.dart';

/// An implementation of [NuggetFlutterPluginPlatform] that uses method channels.
class MethodChannelNuggetFlutterPlugin extends NuggetFlutterPluginPlatform {
  /// The method channel used to interact with the native platform for invoking methods.
  @visibleForTesting
  final methodChannel = const MethodChannel('nugget_flutter_plugin');

  static String _namespace = "";
  static NuggetAuthProviderDelegate? _authProviderDelegate;

  static void setAuthProvider(NuggetAuthProviderDelegate delegate) {
    _authProviderDelegate = delegate;
  }

  // Event Channels for receiving streams from native
  // Use distinct names for each stream
  static const EventChannel _tokenUpdatedChannel = EventChannel(
    'nugget_flutter_plugin/onTokenUpdated',
  );
  static const EventChannel _permissionStatusChannel = EventChannel(
    'nugget_flutter_plugin/onPermissionStatusUpdated',
  );
  static const EventChannel _ticketSuccessChannel = EventChannel(
    'nugget_flutter_plugin/onTicketCreationSucceeded',
  );
  static const EventChannel _ticketFailureChannel = EventChannel(
    'nugget_flutter_plugin/onTicketCreationFailed',
  );

  Stream<String>? _onTicketCreationSucceeded;
  Stream<String?>? _onTicketCreationFailed;
  Stream<String>? _onTokenUpdated;
  Stream<int>? _onPermissionStatusUpdated;

  @override
  Future<void> initialize(String namespace,
      NuggetBusinessContext? businessContext,
      NuggetFontData? nuggetFontData,
      NuggetThemeData? nuggetThemeData,
      bool? handleDeeplinkInsideApp) async {
    MethodChannelNuggetFlutterPlugin._namespace = namespace;
    methodChannel.setMethodCallHandler(_handleMethodCall);
    await methodChannel.invokeMethod('initialize', {
      "namespace" : namespace,
      "fontData": nuggetFontData?.toJson(),
      "themeData":  nuggetThemeData?.toJson(),
      "businessContext": businessContext?.toJson(),
      "handleDeeplinkInsideApp": handleDeeplinkInsideApp
    });
  }

  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'requireAuthInfo' || 'fetchAccessTokenFromClient':
        try {
          final args = call.arguments;
          final requestId = (args is Map<dynamic, dynamic>)
              ? args['requestId'] as String? ?? "-1"
              : "-1";
          final payloadArgs = (args is Map && args['payload'] is Map)
              ? HashMap<String, String>.from(args['payload'] as Map)
              : HashMap<String, String>();

          if (_authProviderDelegate == null) {
            throw PlatformException(
              code: 'AUTH_ERROR',
              message: 'Auth provider delegate is not available',
            );
          }

          final authInfo = await _authProviderDelegate!.requireAuthInfo(
              requestId, payloadArgs);
          if (authInfo == null) {
            throw PlatformException(
              code: 'AUTH_ERROR',
              message: 'Auth provider returned null',
            );
          }

          return authInfo.toJson();
        } catch (e, stackTrace) {
          throw PlatformException(
            code: 'AUTH_ERROR',
            message: 'Error getting auth info: ${e.toString()}',
          );
        }

      case 'refreshAuthInfo':
        try {
          final args = call.arguments;
          final String requestId = (args is Map)
              ? args['requestId'] as String? ?? "-1"
              : "-1";
          final payloadArgs = (args is Map && args['payload'] is Map)
              ? HashMap<String, String>.from(args['payload'] as Map)
              : HashMap<String, String>();

          if (_authProviderDelegate == null) {
            throw PlatformException(
              code: 'REFRESH_ERROR',
              message: 'Auth provider delegate is not available',
            );
          }

          final authInfo = await _authProviderDelegate!.refreshAuthInfo(
              requestId, payloadArgs);
          if (authInfo == null) {
            throw PlatformException(
              code: 'REFRESH_ERROR',
              message: 'Auth provider returned null during refresh',
            );
          }

          return authInfo.toJson();
        } catch (e) {
          throw PlatformException(
            code: 'REFRESH_ERROR',
            message: 'Error refreshing auth info: $e',
          );
        }


      case 'jumboConfiguration':
        return {"namespace": MethodChannelNuggetFlutterPlugin._namespace};

      case 'handleDeeplinkInsideApp' :
        final args = call.arguments as Map;
        final String deeplink = args['deeplink'] as String? ?? "";
        final result = await _authProviderDelegate?.handleDeeplinkInsideApp(deeplink);
        return result ?? "no_result";

      default:
        throw MissingPluginException('Method ${call.method} not implemented');
    }
  }

  @override
  Future<void> openChatWithCustomDeeplink({
    required String customDeeplink,
  }) async {
    // Prepare arguments map
    await methodChannel.invokeMethod('openChatWithCustomDeeplink', {
      "customDeeplink": customDeeplink,
    });
  }

  Stream<String> get onTicketCreationSucceeded {
    _onTicketCreationSucceeded ??= _ticketSuccessChannel
        .receiveBroadcastStream()
        .map<String>((dynamic event) => event as String);
    return _onTicketCreationSucceeded!;
  }

  @override
  Stream<String?> get onTicketCreationFailed {
    _onTicketCreationFailed ??= _ticketFailureChannel
        .receiveBroadcastStream()
        .map<String?>((dynamic event) => event as String?);
    return _onTicketCreationFailed!;
  }

  @override
  Stream<String> get onTokenUpdated {
    _onTokenUpdated ??= _tokenUpdatedChannel.receiveBroadcastStream().map((event) => event.toString());
    return _onTokenUpdated!;
  }

  @override
  Stream<int> get onPermissionStatusUpdated {
    _onPermissionStatusUpdated ??= _permissionStatusChannel.receiveBroadcastStream().map((event) => event as int);
    return _onPermissionStatusUpdated!;
  }

  @override
  void startChat() {
    methodChannel.invokeMethod<bool>('startChat');
  }

  @override
  void sendAccessTokenResponse(
    String accessToken,
    int httpCode,
    String requestId,
  ) {
    methodChannel.invokeMethod("accessTokenResponse", {
      "token": accessToken, // access token received from your API
      "httpCode": httpCode, // http code of request,
      "requestId": requestId, // requestId to identify the request
    });
  }

  @override
  void syncFCMToken(String token, bool notifsEnabled) {
    methodChannel.invokeMethod("syncFCMToken" , {
      "fcmToken" : token,
      "notifsEnabled" : notifsEnabled
    });
  }

  @override
  void sendCurrentDarkThemeStatus(bool isDarkTheme) {
    methodChannel.invokeMethod("clientDarkThemeStatus" , {
      "darkThemeEnabled" : isDarkTheme
    });
  }

}
