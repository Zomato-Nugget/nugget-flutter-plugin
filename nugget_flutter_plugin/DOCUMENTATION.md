# Nugget Flutter Plugin Documentation

## Overview
The Nugget Flutter Plugin provides a seamless integration of the Nugget SDK into Flutter applications. It offers a platform-agnostic interface for chat functionality, push notifications, and ticket management.

## Table of Contents
1. [Installation](#installation)
2. [Setup](#setup)
3. [Configuration](#configuration)
4. [Usage](#usage)
5. [Features](#features)
6. [Platform-Specific Setup](#platform-specific-setup)
7. [Error Handling](#error-handling)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)
10. [API Reference](#api-reference)

## Installation

### Using GitHub
Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  nugget_flutter_plugin:
    git:
      url: https://github.com/your-username/nugget_flutter_plugin.git
      ref: main  # or specific version tag
```

Then run:
```bash
flutter pub get
```

## Setup

### 1. Initialize the Plugin
Create a service class to handle Nugget initialization:

```dart
// lib/services/nugget_service.dart
import 'package:nugget_flutter_plugin/nugget_flutter_plugin.dart';

class NuggetService {
  static final NuggetFlutterPlugin _plugin = NuggetFlutterPlugin();
  static bool _isInitialized = false;
  
  /// Initialize the Nugget plugin with theme and font configurations.
  /// This must be called before using any other plugin features.
  static Future<void> initialize() async {
    if (_isInitialized) {
      print('Nugget plugin is already initialized');
      return;
    }

    try {
      final theme = NuggetThemeData(
        paletteHexString: '#FF0000', // Your brand color
        tintColorHex: '#0000FF',     // Your accent color
        interfaceStyle: NuggetInterfaceStyle.system,
      );
      
      final font = NuggetFontData(
        fontName: 'Helvetica Neue',
        fontFamily: 'Helvetica Neue',
        fontWeightMapping: {
          NuggetFontWeight.regular: 'Regular',
          NuggetFontWeight.bold: 'Bold',
        },
        fontSizeMapping: {
          NuggetFontSize.font100: 12,
          NuggetFontSize.font400: 16,
        },
      );
      
      await _plugin.initialize(
        theme: theme,
        font: font,
      );
      
      _isInitialized = true;
      _setupListeners();
    } catch (e) {
      print('Failed to initialize Nugget plugin: $e');
      rethrow;
    }
  }
  
  /// Check if the plugin is initialized
  static bool get isInitialized => _isInitialized;
  
  /// Open the chat interface. Throws an exception if plugin is not initialized.
  static Future<void> openChat({String? customDeeplink}) async {
    if (!_isInitialized) {
      throw Exception('Nugget plugin must be initialized before opening chat');
    }

    try {
      await _plugin.openChatWithCustomDeeplink(
        customDeeplink: customDeeplink ?? 'default',
      );
    } catch (e) {
      print('Error opening chat: $e');
      rethrow;
    }
  }
  
  static void _setupListeners() {
    if (!_isInitialized) {
      throw Exception('Nugget plugin must be initialized before setting up listeners');
    }

    // Listen for token updates
    _plugin.onTokenUpdated.listen((token) {
      print('Token updated: $token');
      // Store token or send to your server
      // Example: _storeToken(token);
    });
    
    // Listen for permission status changes
    _plugin.onPermissionStatusUpdated.listen((status) {
      print('Permission status: $status');
      // Handle permission changes
      // Example: _handlePermissionStatus(status);
    });
    
    // Listen for successful ticket creation
    _plugin.onTicketCreationSucceeded.listen((conversationId) {
      print('Ticket created with ID: $conversationId');
      // Handle successful ticket creation
      // Example: _handleTicketCreated(conversationId);
    });
    
    // Listen for failed ticket creation
    _plugin.onTicketCreationFailed.listen((error) {
      print('Ticket creation failed: $error');
      // Handle ticket creation failure
      // Example: _handleTicketCreationFailed(error);
    });
  }
  
  // Optional: Add methods to handle the events
  static void _storeToken(String token) {
    if (!_isInitialized) {
      throw Exception('Nugget plugin must be initialized before storing token');
    }
    // Implement token storage logic
    // Example: SharedPreferences, secure storage, etc.
  }
  
  static void _handlePermissionStatus(NuggetPushPermissionStatus status) {
    if (!_isInitialized) {
      throw Exception('Nugget plugin must be initialized before handling permissions');
    }
    // Implement permission status handling
    // Example: Update UI, show prompts, etc.
  }
  
  static void _handleTicketCreated(String conversationId) {
    if (!_isInitialized) {
      throw Exception('Nugget plugin must be initialized before handling ticket creation');
    }
    // Implement ticket creation success handling
    // Example: Show success message, update UI, etc.
  }
  
  static void _handleTicketCreationFailed(String? error) {
    if (!_isInitialized) {
      throw Exception('Nugget plugin must be initialized before handling ticket creation failures');
    }
    // Implement ticket creation failure handling
    // Example: Show error message, retry logic, etc.
  }
}
```

### 2. Initialize in Your App
```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NuggetService.initialize();
  runApp(MyApp());
}
```

## Configuration

### Theme Configuration
```dart
final theme = NuggetThemeData(
  paletteHexString: '#FF0000', // Brand color
  tintColorHex: '#0000FF',     // Accent color
  interfaceStyle: NuggetInterfaceStyle.system,
);
```

### Font Configuration
```dart
final font = NuggetFontData(
  fontName: 'Helvetica Neue',
  fontFamily: 'Helvetica Neue',
  fontWeightMapping: {
    NuggetFontWeight.regular: 'Regular',
    NuggetFontWeight.bold: 'Bold',
  },
  fontSizeMapping: {
    NuggetFontSize.font100: 12,
    NuggetFontSize.font400: 16,
  },
);
```

## Usage

### Opening Chat
```dart
// Using the service
await NuggetService.openChat(customDeeplink: 'your-custom-deeplink');

// Using the widget
NuggetChatButton(
  customDeeplink: 'your-custom-deeplink',
)
```

### Handling Events
```dart
// Token updates
_plugin.onTokenUpdated.listen((token) {
  // Handle token updates
});

// Permission status
_plugin.onPermissionStatusUpdated.listen((status) {
  // Handle permission changes
});

// Ticket creation
_plugin.onTicketCreationSucceeded.listen((conversationId) {
  // Handle successful ticket creation
});

_plugin.onTicketCreationFailed.listen((error) {
  // Handle ticket creation failure
});
```

## Features

### 1. Chat Interface
- Customizable UI
- Deep linking support
- Platform-specific optimizations

### 2. Push Notifications
- Token management
- Permission handling
- Platform-specific implementations

### 3. Ticket Management
- Creation tracking
- Error handling
- Status monitoring

## Platform-Specific Setup

### iOS Setup
Add to `ios/Runner/Info.plist`:
```xml
<key>NSUserNotificationUsageDescription</key>
<string>We need to send you notifications</string>
```

### Android Setup
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<!-- Add other necessary permissions -->
```

## Error Handling

### Common Errors
1. **Initialization Failed**
   - Check network connectivity
   - Verify configuration parameters
   - Check platform-specific setup

2. **Push Notification Issues**
   - Verify token registration
   - Check permission status
   - Review platform-specific configurations

### Error Handling Implementation
```dart
try {
  await NuggetService.initialize();
} catch (e) {
  // Handle initialization error
  print('Error initializing Nugget: $e');
}
```

## Troubleshooting

### 1. Chat Not Opening
- Verify initialization
- Check custom deeplink format
- Review platform logs

### 2. Push Notifications Not Working
- Check token registration
- Verify permissions
- Review platform-specific setup

### 3. Theme Not Applying
- Verify theme configuration
- Check color format
- Review platform-specific limitations

## Best Practices

### 1. Initialization
- Initialize early in app lifecycle
- Handle initialization errors
- Monitor initialization status

### 2. Error Handling
- Implement comprehensive error handling
- Log errors appropriately
- Provide user feedback

### 3. State Management
- Use proper state management
- Handle platform-specific states
- Monitor connection status

### 4. Performance
- Optimize initialization
- Handle background states
- Manage resources efficiently

## API Reference

### NuggetFlutterPlugin
```dart
class NuggetFlutterPlugin {
  Future<void> initialize({
    NuggetThemeData? theme,
    NuggetFontData? font,
  });
  
  Stream<String> get onTokenUpdated;
  Stream<NuggetPushPermissionStatus> get onPermissionStatusUpdated;
  Stream<String> get onTicketCreationSucceeded;
  Stream<String?> get onTicketCreationFailed;
  
  Future<void> openChatWithCustomDeeplink({required String customDeeplink});
}
```

### Data Classes
```dart
class NuggetThemeData {
  final String? paletteHexString;
  final String? tintColorHex;
  final NuggetInterfaceStyle interfaceStyle;
}

class NuggetFontData {
  final String fontName;
  final String fontFamily;
  final Map<NuggetFontWeight, String> fontWeightMapping;
  final Map<NuggetFontSize, int> fontSizeMapping;
}
```

### Enums
```dart
enum NuggetPushPermissionStatus {
  notDetermined,
  denied,
  authorized,
  provisional,
  ephemeral
}

enum NuggetInterfaceStyle {
  system,
  light,
  dark
}

enum NuggetFontWeight {
  light,
  regular,
  medium,
  semiBold,
  bold,
  extraBold,
  black
}

enum NuggetFontSize {
  font050,
  font100,
  font200,
  font300,
  font400,
  font500,
  font600,
  font700,
  font800,
  font900
}
```

## Support
For support, please contact:
- Email: support@example.com
- GitHub Issues: [GitHub Repository](https://github.com/your-username/nugget_flutter_plugin/issues)

## License
This plugin is licensed under the MIT License. See the LICENSE file for details.

## Authentication Setup

### 1. Initialize the Auth Provider
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the auth provider delegate
  NuggetAuthProviderDelegate.initialize();
  
  // Initialize the Nugget plugin
  await NuggetService.initialize();
  
  runApp(MyApp());
}
```

### 2. Configure Authentication
The plugin uses `NuggetAuthProviderDelegate` to handle authentication. You can customize the authentication by implementing your own auth provider:

```dart
class CustomAuthProvider implements NuggetAuthProviderDelegate {
  @override
  Future<NuggetAuthUserInfo?> requireAuthInfo() async {
    // Return the current auth info
    return NuggetAuthUserInfoImpl(
      clientID: 1,
      accessToken: 'current_token',
      userID: 'user_id',
      userName: 'username',
      photoURL: '',
      displayName: 'User Name',
    );
  }

  @override
  Future<NuggetAuthUserInfo?> refreshAuthInfo() async {
    // Refresh and return new auth info
    return NuggetAuthUserInfoImpl(
      clientID: 1,
      accessToken: 'new_token',
      userID: 'user_id',
      userName: 'username',
      photoURL: '',
      displayName: 'User Name',
    );
  }
}
```

### 3. Required Auth Fields
The auth provider must return a map with the following fields:

```dart
{
  'clientID': int,          // Required: Your client ID
  'accessToken': String,    // Required: User's access token
  'userID': String,         // Required: User's unique identifier
  'displayName': String,    // Optional: User's display name
  'userName': String,       // Optional: User's username
  'photoURL': String,       // Optional: URL to user's profile photo
}
```

### 4. Error Handling
The auth provider should handle errors appropriately:

```dart
try {
  final authInfo = await authProvider.getAuthInfo();
  // Use auth info
} catch (e) {
  print('Authentication error: $e');
  // Handle error
}
``` 