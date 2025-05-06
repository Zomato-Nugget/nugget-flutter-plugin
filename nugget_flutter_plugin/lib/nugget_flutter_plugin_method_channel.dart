import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'nugget_flutter_plugin_platform_interface.dart';

/// An implementation of [NuggetFlutterPluginPlatform] that uses method channels.
class MethodChannelNuggetFlutterPlugin extends NuggetFlutterPluginPlatform {
  /// The method channel used to interact with the native platform for invoking methods.
  @visibleForTesting
  final methodChannel = const MethodChannel('nugget_flutter_plugin');

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
  }

  @override
  Stream<String?> get onTicketCreationFailed {
    _onTicketCreationFailed ??= _ticketFailureChannel
        .receiveBroadcastStream()
        .map<String?>((dynamic event) => event as String?);
    return _onTicketCreationFailed!;
  }
}
