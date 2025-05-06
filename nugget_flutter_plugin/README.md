# nugget_flutter_plugin

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) 
<!-- TODO: Add pub.dev version badge once published -->
<!-- TODO: Add build status badge if CI is set up -->

A Flutter plugin to integrate the native NuggetSDK for iOS, enabling features like native chat UI, authentication callbacks, push notification handling, and UI customization within a Flutter application.

## Features

*   Initialize the native NuggetSDK.
*   Present the native Nugget chat UI (attempting push navigation first, falling back to modal).
*   Embed the native Nugget chat UI within the Flutter layout using Platform Views (`NuggetChatView`).
*   Handle native authentication callbacks (`requireAuthInfo`, `refreshAuthInfo`) via Dart.
*   Receive push notification tokens (`onTokenUpdated`) and permission status (`onPermissionStatusUpdated`) from native iOS callbacks.
*   Receive callbacks for ticket creation success/failure (`onTicketCreationSucceeded`, `onTicketCreationFailed`).
*   Customize the native UI theme and fonts via Dart (`NuggetThemeData`, `NuggetFontData`).

## Platform Support

*   **iOS:** Supported
*   **Android:** Not yet implemented

## Installation

1.  **Add Dependency:** Add the plugin to your `pubspec.yaml` file:

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      nugget_flutter_plugin: ^0.0.1 # Replace with the actual version or path/git dependency
    ```

2.  **iOS Setup (Crucial):** The native `NuggetSDK` is distributed via Swift Package Manager (SPM). You need to declare this dependency in your **consuming Flutter application's** `ios/Podfile`.

    Add the following line inside your main `target` block in `ios/Podfile`:

    ```ruby
    # ios/Podfile

    target 'Runner' do
      use_frameworks!
      use_modular_headers!

      flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

      # --> Add NuggetSDK SPM Dependency <--
      # Replace 'https://github.com/your-org/NuggetSDK.git' with the actual repository URL
      # Replace '.upToNextMajor(from: "1.0.0")' with the correct version constraint
      swift_package 'NuggetSDK', :git => 'https://github.com/your-org/NuggetSDK.git', .upToNextMajor(from: "1.0.0") 

      target 'RunnerTests' do
        inherit! :search_paths
        # Pods for testing
      end
    end
    ```

    After adding the `swift_package` line, run `pod install` in your `ios` directory:

    ```bash
    cd ios
    pod install 
    # Or potentially: bundle exec pod install
    ```

    **Note on CocoaPods Environment:** Some users (especially on M1/M2 Macs) have encountered issues where `pod install` fails with `undefined method 'swift_package'`. This often points to conflicts between system Ruby, Homebrew Ruby, and CocoaPods versions or architectures. Ensure your CocoaPods version is 1.10.0 or higher (preferably the latest) and that your terminal environment is correctly configured. Using `arch -x86_64 pod install` or managing Ruby via `rvm`/`rbenv` might be necessary workarounds if you face this issue.

## Usage

**1. Import:**

```dart
import 'package:nugget_flutter_plugin/nugget_flutter_plugin.dart';
```

**2. Initialize Native Callback Handler (Early):**

Call this **once** in your `main()` function before `runApp()` to allow Dart to receive calls *from* the native side (like auth requests).

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Required before calling handler
  NuggetPluginNativeCallbackHandler.initializeHandler(); 
  runApp(MyApp());
}
```

**3. Initialize the Plugin:**

Call this (typically once) before using other plugin features. You can optionally pass theme and font data.

```dart
final _plugin = NuggetFlutterPlugin();

Future<void> initializeNugget() async {
  try {
    final theme = NuggetThemeData(
      tintColorHex: "#00AEEF", // Example tint color
      interfaceStyle: NuggetInterfaceStyle.light,
    );
    // final font = NuggetFontData(...); // Optional font data

    await _plugin.initialize(
      theme: theme,
      // font: font, 
    );
    print("Nugget SDK Initialized");
  } catch (e) {
    print("Nugget SDK Initialization Failed: $e");
  }
}
```

**4. Implement Native Callback Handling (Auth Example):**

You need to implement the logic for methods called *by* the native plugin. This is done in the static `_handleNativeMethodCall` within `NuggetPluginNativeCallbackHandler` (or by separating the logic into your own classes called from there).

```dart
// Inside lib/nugget_plugin_callback_handler.dart (or wherever you centralize the logic)

static Future<dynamic> _handleNativeMethodCall(MethodCall call) async {
  switch (call.method) {
    case 'requireAuthInfo':
    case 'refreshAuthInfo':
      try {
        // --- TODO: Replace with your actual auth logic ---
        print("NuggetPlugin: Dart providing auth info for ${call.method}...");
        const String accessToken = "YOUR_ACCESS_TOKEN"; 
        const int clientId = YOUR_CLIENT_ID; 
        const String userId = "YOUR_USER_ID";
        const String displayName = "YOUR_DISPLAY_NAME";
        const String photoUrl = "URL_TO_USER_PHOTO";
        const String? userName = "OPTIONAL_USERNAME";
        // --- End TODO ---

        final authInfo = ZChatAuthUserInfoImpl(
          accessToken: accessToken,
          clientID: clientId,
          userID: userId,
          displayName: displayName,
          photoURL: photoUrl,
          userName: userName, 
        );
        final Map<String, dynamic> authInfoMap = authInfo.toJson();
        print("NuggetPlugin: Dart returning auth map: $authInfoMap");
        return authInfoMap; // Return Map to native side

      } catch (e) {
        print("NuggetPlugin: Error providing auth info: $e");
        throw PlatformException(code: 'AUTH_ERROR', message: "Error providing auth info: ${e.toString()}");
      }
    // Handle other cases like 'onTicketCreationSucceeded', 'onTicketCreationFailed' if using MethodChannel for them
    default:
      throw MissingPluginException('Method "${call.method}" not implemented.');
  }
}
```

**5. Open Chat (Push/Modal):**

Call this method to present the native chat UI.

```dart
Future<void> openChat() async {
  try {
    // Optionally provide a deeplink path
    await _plugin.openChatWithCustomDeeplink(customDeeplink: "/conversations/123"); 
  } catch (e) {
    print("Error opening chat: $e");
    // Handle error (e.g., show SnackBar)
  }
}
```

**6. Embed Chat UI:**

Use the `NuggetChatView` widget within your Flutter layout.

```dart
// In your Widget build method:
Widget build(BuildContext context) {
  // ...
  return Container(
    height: 400, // Give it specific dimensions
    child: NuggetChatView(
      // Optional: Pass initial deeplink if needed for the embedded view
      // initialDeeplink: "/home", 
    ),
  );
  // ...
}
```

**7. Listen to Streams:**

Subscribe to the streams to receive asynchronous updates from native.

```dart
StreamSubscription? _tokenSubscription;
StreamSubscription? _permissionStatusSubscription;
StreamSubscription? _ticketSuccessSubscription;
StreamSubscription? _ticketFailureSubscription;

void listenToStreams() {
  _tokenSubscription = _plugin.onTokenUpdated.listen((token) {
    print("Push Token Updated: $token");
    // Update your app state / send to server
  });

  _permissionStatusSubscription = _plugin.onPermissionStatusUpdated.listen((status) {
    print("Permission Status Updated: $status"); 
    // status is a NuggetPushPermissionStatus enum (e.g., .authorized, .denied)
  });
  
  _ticketSuccessSubscription = _plugin.onTicketCreationSucceeded.listen((conversationId) {
     print("Ticket Created: $conversationId");
  });

  _ticketFailureSubscription = _plugin.onTicketCreationFailed.listen((errorMessage) {
     print("Ticket Creation Failed: ${errorMessage ?? 'Unknown error'}");
  });
}

// Remember to cancel subscriptions in your State's dispose method:
@override
void dispose() {
  _tokenSubscription?.cancel();
  _permissionStatusSubscription?.cancel();
  _ticketSuccessSubscription?.cancel();
  _ticketFailureSubscription?.cancel();
  super.dispose();
}
```

## Example App

See the `example/` directory for a working application demonstrating the plugin's features.

## API Reference

(TODO: Link to Dartdoc generated documentation)

Key classes:
*   `NuggetFlutterPlugin`: Main plugin class for invoking methods.
*   `NuggetPluginNativeCallbackHandler`: Handles callbacks *from* native.
*   `NuggetChatView`: Widget for embedding the native UI.
*   `NuggetThemeData`, `NuggetFontData`: Data classes for customization.
*   `ZChatAuthUserInfoImpl`: Data class for authentication info.
*   Enums: `NuggetPushPermissionStatus`, `NuggetInterfaceStyle`, etc.

## Contributing

(TODO: Add contribution guidelines if desired)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

