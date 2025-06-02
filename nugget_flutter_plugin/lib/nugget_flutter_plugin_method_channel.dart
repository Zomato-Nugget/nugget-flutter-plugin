import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
<<<<<<< HEAD
import 'package:nugget_flutter_plugin/models/nugget_business_context.dart';
import 'package:nugget_flutter_plugin/models/nugget_font_data.dart';
import 'package:nugget_flutter_plugin/models/nugget_theme_data.dart';
import 'dart:async';

import 'interface/nugget_auth_provider_delegate.dart';
=======
import 'dart:async';

>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
import 'nugget_flutter_plugin_platform_interface.dart';

/// An implementation of [NuggetFlutterPluginPlatform] that uses method channels.
class MethodChannelNuggetFlutterPlugin extends NuggetFlutterPluginPlatform {
  /// The method channel used to interact with the native platform for invoking methods.
  @visibleForTesting
  final methodChannel = const MethodChannel('nugget_flutter_plugin');

<<<<<<< HEAD
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
      NuggetThemeData? nuggetThemeData) async {
    MethodChannelNuggetFlutterPlugin._namespace = namespace;
    methodChannel.setMethodCallHandler(_handleMethodCall);
    await methodChannel.invokeMethod('initialize', {
      "namespace" : namespace,
      "fontData": nuggetFontData?.toJson(),
      "themeData":  nuggetThemeData?.toJson(),
      "businessContext": businessContext?.toJson(),
    });
  }

  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'requireAuthInfo' || 'fetchAccessTokenFromClient':
        try {
          final authInfo = await _authProviderDelegate?.requireAuthInfo();
          if (authInfo == null) {
            throw PlatformException(
              code: 'AUTH_ERROR',
              message: 'Auth provider returned null',
            );
          }
          return authInfo.toJson();
        } catch (e) {
          throw PlatformException(
            code: 'AUTH_ERROR',
            message: 'Error getting auth info: $e',
          );
        }

      case 'refreshAuthInfo':
        try {
          final authInfo = await _authProviderDelegate?.refreshAuthInfo();
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
=======
  // Event Channels for receiving streams from native
  // Use distinct names for each stream
  static const EventChannel _tokenUpdatedChannel =
      EventChannel('nugget_flutter_plugin/onTokenUpdated');
  static const EventChannel _permissionStatusChannel =
      EventChannel('nugget_flutter_plugin/onPermissionStatusUpdated');
  static const EventChannel _ticketSuccessChannel =
      EventChannel('nugget_flutter_plugin/onTicketCreationSucceeded');
  static const EventChannel _ticketFailureChannel =
      EventChannel('nugget_flutter_plugin/onTicketCreationFailed');

  // Cached stream instances to avoid creating new streams on every access
  Stream<String>? _onTokenUpdated;
  Stream<NuggetPushPermissionStatus>? _onPermissionStatusUpdated;
  Stream<String>? _onTicketCreationSucceeded;
  Stream<String?>? _onTicketCreationFailed;

  @override
  Future<void> initialize({
    NuggetThemeData? theme,
    NuggetFontData? font,
  }) async {
    // Prepare arguments map, including JSON maps for theme/font if provided
    final Map<String, dynamic> arguments = {
      'theme': theme?.toJson(), // Call toJson() if theme is not null
      'font': font?.toJson(),   // Call toJson() if font is not null
    };
    arguments.removeWhere((key, value) => value == null);
    await methodChannel.invokeMethod('initialize', arguments);
  }

  @override
  Future<void> openChatWithCustomDeeplink({required String customDeeplink}) async {
    // Prepare arguments map
    final Map<String, dynamic> arguments = {
      'customDeeplink': customDeeplink,
    };
    await methodChannel.invokeMethod('openChatWithCustomDeeplink', arguments);
  }

  @override
  Stream<String> get onTokenUpdated {
    _onTokenUpdated ??= _tokenUpdatedChannel
        .receiveBroadcastStream()
        .map<String>((dynamic event) => event as String);
    return _onTokenUpdated!;
  }

  @override
  Stream<NuggetPushPermissionStatus> get onPermissionStatusUpdated {
    _onPermissionStatusUpdated ??= _permissionStatusChannel
        .receiveBroadcastStream()
        .map<NuggetPushPermissionStatus>((dynamic event) {
            // Native side should send the raw integer value of the status
            int statusValue = event is int ? event : int.tryParse(event.toString()) ?? 0;
            // Convert integer to enum (ensure enum order matches native values)
            return NuggetPushPermissionStatus.values.firstWhere(
              (e) => e.index == statusValue, 
              orElse: () => NuggetPushPermissionStatus.notDetermined // Default fallback
            );
        });
    return _onPermissionStatusUpdated!;
  }

  @override
  Stream<String> get onTicketCreationSucceeded {
     _onTicketCreationSucceeded ??= _ticketSuccessChannel
        .receiveBroadcastStream()
        .map<String>((dynamic event) => event as String);
     return _onTicketCreationSucceeded!;
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
  }

  @override
  Stream<String?> get onTicketCreationFailed {
    _onTicketCreationFailed ??= _ticketFailureChannel
        .receiveBroadcastStream()
        .map<String?>((dynamic event) => event as String?);
    return _onTicketCreationFailed!;
  }
<<<<<<< HEAD

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
=======
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
}
