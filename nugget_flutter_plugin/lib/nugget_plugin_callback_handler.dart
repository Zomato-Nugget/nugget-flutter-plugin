// lib/nugget_plugin_callback_handler.dart

import 'dart:async'; // Imports Dart's library for asynchronous programming (Futures, Streams).
import 'package:flutter/services.dart'; // Imports Flutter's services layer, including platform channels (MethodChannel, PlatformException).

// Import your data models if needed
// import 'models/my_actual_auth_user_info.dart';

/// Handles method calls initiated FROM the native iOS/Android side TO Dart.
/// This acts as the receiving end in Dart for requests made by the native plugin code,
/// often triggered by a native SDK's delegate callback.
class NuggetPluginNativeCallbackHandler {
  // `static const`:
  // - `static`: This variable belongs to the class `NuggetPluginNativeCallbackHandler` itself,
  //   not to any specific instance of the class. You access it using ClassName.variableName
  //   (e.g., NuggetPluginNativeCallbackHandler._channel). Think of Swift's `static`.
  // - `const`: The variable is a compile-time constant. Its value (`MethodChannel(...)`) is fixed
  //   at compile time. This is stricter than `final` (which is runtime constant, like Swift's `let`).
  //
  // `MethodChannel`: This is the Flutter mechanism for sending messages between Dart and
  // native code (Swift/Kotlin). It's like a named communication pipe.
  // The string 'nugget_flutter_plugin' is the channel name – it MUST match the name
  // used in the native Swift/Kotlin code to ensure messages go to the right place.
  static const MethodChannel _channel = MethodChannel('nugget_flutter_plugin');

  // `_` prefix: In Dart, starting a variable or method name with an underscore `_` marks it
  // as library-private (similar concept to `private` in Swift, but scoped to the file/library).
  // `static bool`: A static boolean flag, belonging to the class, used to track initialization.
  // `= false`: Initializes the boolean variable to false.
  static bool _isHandlerInitialized = false;

  /// Initializes the handler for receiving method calls from the native platform (iOS/Android).
  ///
  /// This MUST be called once, early in your application's main() function,
  /// typically before `runApp()`, to ensure Dart is ready to listen before the
  /// native side attempts to send messages.
  ///
  /// Why call early? Native SDKs might be configured right away and try to call
  /// their delegate (your Swift plugin proxy) immediately. The Dart listener
  /// needs to be active by then.
  static void initializeHandler() {
    // Prevents setting the handler multiple times if this function is accidentally called again.
    if (_isHandlerInitialized) {
      print("NuggetPlugin Callback Handler: Already initialized.");
      return; // Exit the function early.
    }

    // `setMethodCallHandler`: This is the core function. It registers a callback (`_handleNativeMethodCall`)
    // that will be invoked whenever the native code (Swift/Kotlin) sends a message
    // over the `_channel` using `invokeMethod` pointed *towards* Dart.
    // It takes a function that accepts a `MethodCall` object and returns a `Future`.
    _channel.setMethodCallHandler(_handleNativeMethodCall);

    // Mark initialization as complete.
    _isHandlerInitialized = true;
    print("NuggetPlugin Callback Handler: Initialized successfully.");
  }

  // This is the function registered by `setMethodCallHandler`.
  // `static`: Can be called directly on the class.
  // `Future<dynamic>`: The return type.
  // - `Future`: Represents a value or error that will be available at some point in the future.
  //   Similar to Swift's Combine `Future` or using completion handlers, but built into the language
  //   syntax with `async`/`await`. Dart uses Futures extensively for async operations.
  // - `dynamic`: Means the Future can complete with a value of any type. Often used with platform
  //   channels when the exact return type might vary or needs conversion (e.g., returning a Map
  //   that represents your auth object). Could be typed more strictly, like `Future<Map<String, dynamic>?>`.
  // `_handleNativeMethodCall`: The underscore makes it library-private.
  // `MethodCall call`: An object representing the message received from the native side.
  //   - `call.method`: A String containing the name of the method the native side invoked (e.g., "requireAuthInfo").
  //   - `call.arguments`: Any arguments sent along with the method call from native (can be various types, often Maps).
  // `async`: This keyword marks the function as asynchronous. It allows the use of `await` inside it.
  //   An `async` function automatically returns a `Future`.
  static Future<dynamic> _handleNativeMethodCall(MethodCall call) async {
    print(
      "NuggetPlugin Callback Handler: Dart received native call: ${call.method}",
    );

    // Use `call.method` (the string name sent from Swift) to determine which action to take.
    switch (call.method) {
      case 'requireAuthInfo':
        try {
          print("NuggetPlugin: Dart executing requireAuthInfo logic...");
          // You can keep or remove the delay
          // await Future.delayed(Duration(milliseconds: 3));

          // Define the map to be returned
          final Map<String, dynamic> authInfoMap = {
            'clientID': 1,
            'accessToken': '',
            'userID': 'dart_user_id_456', // Correct key
            'displayName': 'Darter',
            'userName': 'darter',
            'photoURL': '',
          };

          // *** ADD THIS PRINT STATEMENT ***
          print("NuggetPlugin: Dart returning auth map: $authInfoMap");

          // Return the created map
          return authInfoMap;
        } catch (e) {
          // Handle errors during the Dart execution.
          print("NuggetPlugin: Error in requireAuthInfo: $e");
          // `PlatformException`: A specific exception type used to send structured error
          // information back across the platform channel to the native side.
          // The `code` and `message` will be available in the `FlutterError` object
          // on the Swift side.
          throw PlatformException(
            code: 'AUTH_ERROR', // An identifier for the error type
            message:
                "Error getting auth info in Dart: ${e.toString()}", // Descriptive message
            // details: // Optional: Can include additional structured details
          );
        }

      case 'refreshAuthInfo':
        try {
          // Placeholder logic
          print("NuggetPlugin: Dart executing refreshAuthInfo logic...");
          // await Future.delayed(Duration(milliseconds: 3));

          // Define the map to be returned (also correct key here)
          final Map<String, dynamic> refreshedInfoMap = {
            'clientID': 1,
            'accessToken': '',
            'userID': 'dart_user_id_456', // Correct key
            'displayName': 'Darter',
            'userName': 'darter',
            'photoURL': '',
          };

          // *** ADD PRINT HERE TOO for consistency ***
          print(
            "NuggetPlugin: Dart returning refreshed auth map: $refreshedInfoMap",
          );

          return refreshedInfoMap;
        } catch (e) {
          print("NuggetPlugin: Error in refreshAuthInfo: $e");
          throw PlatformException(
            code: 'REFRESH_ERROR',
            message: "Error refreshing auth info in Dart: ${e.toString()}",
          );
        }

      // Handle any other method calls the native side might make
      default:
        // `MissingPluginException`: A standard exception indicating that the received
        // method call name is not implemented on the Dart side.
        throw MissingPluginException(
          'Method "${call.method}" not implemented on Dart side.',
        );
    }
  }

  // --- Example Helper Method Placeholders ---
  // It's good practice to separate the actual logic from the channel handling.
  // These would return your Dart model object (e.g., MyActualAuthUserInfo)

  // static Future<MyActualAuthUserInfo?> _getAuthInfoFromDart() async {
  //   // ... your Dart logic to fetch/create auth info ...
  // }
  //
  // static Future<MyActualAuthUserInfo?> _refreshAuthInfoFromDart() async {
  //   // ... your Dart logic to refresh auth info ...
  // }
  //
  // // Helper to combine logic and conversion
  // static Future<Map<String, dynamic>?> _getAuthInfoFromDartAndConvertToMap() async {
  //    MyActualAuthUserInfo? info = await _getAuthInfoFromDart();
  //    return info?.toJson(); // Safely call toJson() if info is not null
  // }
  // static Future<Map<String, dynamic>?> _refreshAuthInfoFromDartAndConvertToMap() async {
  //    MyActualAuthUserInfo? info = await _refreshAuthInfoFromDart();
  //    return info?.toJson();
  // }
}

// --- Example Usage Reminder (in the Flutter App's main.dart) ---
// import 'package:flutter/material.dart';
// import 'package:your_plugin_package/nugget_plugin_callback_handler.dart'; // Adjust import path
//
// void main() {
//   // `WidgetsFlutterBinding.ensureInitialized()`: REQUIRED if you call platform channel
//   // methods or other Flutter framework features *before* `runApp()`. It ensures the
//   // necessary low-level Flutter engine bindings are ready.
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Call your static initializer method ONCE before the app starts.
//   NuggetPluginNativeCallbackHandler.initializeHandler();
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget { // ... }
