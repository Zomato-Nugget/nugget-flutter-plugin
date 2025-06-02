import 'dart:async';

import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter/services.dart';
import 'package:nugget_flutter_plugin/interface/nugget_auth_info.dart';
import 'package:nugget_flutter_plugin/interface/nugget_auth_provider_delegate.dart';
import 'package:nugget_flutter_plugin/models/nugget_auth_info_imp.dart';
import 'package:nugget_flutter_plugin/models/nugget_business_context.dart';
import 'package:nugget_flutter_plugin/models/nugget_font_data.dart';
import 'package:nugget_flutter_plugin/models/nugget_theme_data.dart';
import 'package:nugget_flutter_plugin/nugget_flutter_plugin_method_channel.dart';
import 'package:nugget_flutter_plugin/nugget_flutter_plugin.dart';

final _plugin = NuggetFlutterPlugin();
const String namespace = "namespace";

final class DummyTokenProvider implements NuggetAuthProviderDelegate {
  final String accessToken = "";
  final int httpStatusCode = 200;
  final String requestId = "-1";

  @override
  Future<NuggetAuthInfo?> requireAuthInfo() async {
    fetchAccessTokenFromClient();
    return NuggetAuthInfoImp(
        accessToken: accessToken,
        httpStatusCode: httpStatusCode,
        requestId: requestId);
  }

  @override
  Future<NuggetAuthInfo?> refreshAuthInfo() async {
    fetchAccessTokenFromClient();
    return NuggetAuthInfoImp(
        accessToken: accessToken,
        httpStatusCode: httpStatusCode,
        requestId: requestId);
  }

  // Method to handle fetchAccessTokenFromClient
  @override
  Future<String?> fetchAccessTokenFromClient() async {
    _plugin.sendAccessTokenResponse(accessToken, httpStatusCode, requestId);
    return accessToken;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dummyTokenProvider = DummyTokenProvider();
  MethodChannelNuggetFlutterPlugin.setAuthProvider(dummyTokenProvider);

  Future<NuggetFontData> getFontConfiguration() async {
    final Map<NuggetFontWeight, String> weightMap = {
      NuggetFontWeight.light: 'NunitoSans-12ptExtraLight',
      NuggetFontWeight.regular: 'NunitoSans-12ptExtraLight',
      NuggetFontWeight.medium: 'NunitoSans-12ptExtraLight',
      NuggetFontWeight.semiBold: 'NunitoSans-12ptExtraLight',
      NuggetFontWeight.bold: 'NunitoSans-12ptExtraLight',
      NuggetFontWeight.extraBold: 'NunitoSans-12ptExtraLight',
      NuggetFontWeight.black: 'NunitoSans-12ptExtraLight',
    };

    final Map<NuggetFontSize, int> sizeMap = {
      NuggetFontSize.font050: 10,
      NuggetFontSize.font100: 12,
      NuggetFontSize.font200: 14,
      NuggetFontSize.font300: 16,
      NuggetFontSize.font400: 18,
      NuggetFontSize.font500: 20,
      NuggetFontSize.font600: 24,
      NuggetFontSize.font700: 28,
      NuggetFontSize.font800: 32,
      NuggetFontSize.font900: 36,
    };

    final playwriteData = await rootBundle.load('assets/fonts/PlaywriteHU-Thin.ttf');
    final playwriteBytes = playwriteData.buffer.asUint8List();

    final nunitoSans = await rootBundle.load('assets/fonts/nunito_sans.ttf');
    final nunitoSansBytes = nunitoSans.buffer.asUint8List();

    return NuggetFontData(
        fontName: 'NunitoSans',
        fontFamily: 'Medium',
        fontWeightMapping: weightMap,
        fontSizeMapping: sizeMap,
        fontsData: [playwriteBytes, nunitoSansBytes]);
  }

  NuggetThemeData getThemeConfiguration() {
    return NuggetThemeData(
        defaultDarkModeAccentHexColor: "#1A73E8",
        defaultLightModeAccentHexColor: "#34A853",
        deviceInterfaceStyle: NuggetInterfaceStyle.system);
  }

  NuggetBusinessContext getBusinessContext() {
    return NuggetBusinessContext(
        channelHandle: "channelHandle",
        botProperties: {
          "ABC": ["DEF"]
        });
  }

  _plugin.initialize(namespace,
      null,
      await getFontConfiguration(),
      getThemeConfiguration());
=======
import 'package:shared_preferences/shared_preferences.dart';
// Import the main plugin file, which now exports the handler
import 'package:nugget_flutter_plugin/nugget_flutter_plugin.dart';

void main() {
  // Ensure bindings are initialized before calling plugin code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the handler for native -> Dart calls
  NuggetPluginNativeCallbackHandler.initializeHandler();

>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
<<<<<<< HEAD
=======

>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
<<<<<<< HEAD
  final _deeplinkController = TextEditingController();
  static const _deeplinkPrefKey = 'saved_deeplink';

  bool _isFontConfigured = false; // Add new state variable

  // --- ADDED State for Push Info ---
  final String _latestToken = "Not received yet";
  // --- END ADDED State ---

=======
  final _plugin = NuggetFlutterPlugin();
  final _deeplinkController = TextEditingController();
  static const _deeplinkPrefKey = 'saved_deeplink';

  bool _isInitialized = false;
  String _status = 'SDK Not Initialized';
  
  // --- ADDED State for Push Info ---
  String? _latestToken = "Not received yet";
  NuggetPushPermissionStatus? _latestPermissionStatus;
  // --- END ADDED State ---
  
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
  // REMOVED Callbacks state (Keep if needed for Ticket/Other callbacks)
  // final List<String> _callbackMessages = [];
  // StreamSubscription? _ticketSuccessSubscription;
  // StreamSubscription? _ticketFailureSubscription;
<<<<<<< HEAD

=======
  
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
  // --- ADDED Subscriptions for Push Info ---
  StreamSubscription? _tokenSubscription;
  StreamSubscription? _permissionStatusSubscription;
  // --- END ADDED Subscriptions ---

  // TODO: Add subscriptions for auth and other streams if needed
  // (If callbacks are needed for other logic, keep the listeners but remove UI)

  @override
  void initState() {
    super.initState();
    _loadSavedDeeplink();
<<<<<<< HEAD
=======
    _listenToPushEvents();
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
  }

  @override
  void dispose() {
    _deeplinkController.dispose();
    // Cancel push subscriptions
    _tokenSubscription?.cancel();
    _permissionStatusSubscription?.cancel();
    super.dispose();
  }

  // _listenToCallbacks method removed

  Future<void> _loadSavedDeeplink() async {
<<<<<<< HEAD
    // final prefs = await SharedPreferences.getInstance();
    // final savedDeeplink = prefs.getString(_deeplinkPrefKey);
    // if (savedDeeplink != null && mounted) {
    //   _deeplinkController.text = savedDeeplink;
    // }
=======
    final prefs = await SharedPreferences.getInstance();
    final savedDeeplink = prefs.getString(_deeplinkPrefKey);
    if (savedDeeplink != null && mounted) {
      _deeplinkController.text = savedDeeplink;
    }
  }

  Future<void> _initializeSdk() async {
    setState(() {
      _status = 'Initializing...';
      // _callbackMessages.clear(); // Removed
    });
    try {
      // Example Theme/Font data (replace with actual data if needed)
      final theme = NuggetThemeData(
        tintColorHex: "#FF0000", // Example: Red tint
        interfaceStyle: NuggetInterfaceStyle.light,
      );
      // final font = NuggetFontData(...); // Define if needed

      await _plugin.initialize(
        theme: theme,
        // font: font,
      );
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _status = 'SDK Initialized Successfully';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialized = false;
          _status = 'SDK Initialization Failed: $e';
        });
      }
    }
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
  }

  // Updated to handle initialization check and call
  Future<void> _openChatModally(BuildContext scaffoldContext) async {
<<<<<<< HEAD
    // Check font configuration
    if (!_isFontConfigured) {
      try {
        if (mounted) {
          setState(() {
            _isFontConfigured = true;
          });
        }
      } catch (fontError) {
        // Show warning but continue
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(
              content: Text(
                  'Warning: Font configuration failed. Chat may have display issues.'),
              duration: Duration(seconds: 2)),
        );
      }
    }

    final deeplink = _deeplinkController.text.trim();

    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString(_deeplinkPrefKey, deeplink);

    try {
      await _plugin.openChatWithCustomDeeplink(customDeeplink: deeplink);
    } catch (e) {
      if (mounted) {
=======
    // Check if initialized, if not, try to initialize
    if (!_isInitialized) {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        const SnackBar(content: Text('SDK not initialized. Attempting initialization...'), duration: Duration(seconds: 1)),
      );
      // Wait for initialization attempt to complete
      await _initializeSdk(); 

      // Check again after initialization attempt
      if (!_isInitialized) {
         ScaffoldMessenger.of(scaffoldContext).showSnackBar(
           const SnackBar(content: Text('Initialization failed. Cannot open chat.'), duration: Duration(seconds: 2)),
         );
         return; // Stop if initialization failed
      }
      // If we reach here, initialization was successful
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
         const SnackBar(content: Text('Initialization successful. Opening chat...'), duration: Duration(seconds: 1)),
       );
       // Add a small delay for the snackbar to be visible before navigation/presentation
       await Future.delayed(const Duration(milliseconds: 800)); 
    }

    // --- Proceed with opening chat (if initialized) ---
    final deeplink = _deeplinkController.text.trim();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_deeplinkPrefKey, deeplink);

    // No need for another "Opening chat..." SnackBar here as the init one covers it
    // ScaffoldMessenger.of(scaffoldContext).showSnackBar(
    //   SnackBar(content: Text('Opening chat with deeplink: "$deeplink"...')),
    // );
    try {
      await _plugin.openChatWithCustomDeeplink(customDeeplink: deeplink);
      // Optionally show success message
      // ScaffoldMessenger.of(scaffoldContext).showSnackBar(
      //   const SnackBar(content: Text('Chat open request sent.')),
      // );
    } catch (e) {
      // Show error message
      if (mounted) { 
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(content: Text('Error opening chat: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
=======
    // Start of MaterialApp widget
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
    return MaterialApp(
      // MaterialApp has a `home` property
      home: Scaffold(
        // Scaffold has an `appBar` property
        appBar: AppBar(
          title: const Text('Nugget Plugin Example'),
        ), // End of appBar
        // Scaffold has a `body` property
        // Use Builder to get the correct context for ScaffoldMessenger
        body: Builder(
          // Builder has a `builder` property which is a function
<<<<<<< HEAD
          builder: (builderContext) {
            // Use a different name like builderContext
=======
          builder: (builderContext) { // Use a different name like builderContext
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
            // This function MUST return a Widget
            return Padding(
              padding: const EdgeInsets.all(16.0),
              // Padding has a `child` property
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // Column has a `children` property which is a List<Widget>
                children: [
                  TextField(
                    controller: _deeplinkController,
                    decoration: const InputDecoration(
                      labelText: 'Custom Deeplink (Optional)',
                      hintText: 'e.g., /profile or leave blank',
                    ),
                  ), // End of TextField
                  const SizedBox(height: 10),
                  ElevatedButton(
                    // Use the context from the Builder (builderContext)
                    // Use a lambda to match the required void Function()?
                    onPressed: () => _openChatModally(builderContext),
                    child: const Text('Open Chat (via Deeplink)'),
                  ), // End of ElevatedButton (Open Chat)
                  const SizedBox(height: 10),
<<<<<<< HEAD
                  Text('Push Token: ${_latestToken ?? "N/A"}'), // Display token
                  const SizedBox(height: 10),
                  // Display permission status nicely
=======
                  Text('Status: $_status'),
                  const SizedBox(height: 10),
                  Text('Push Token: ${_latestToken ?? "N/A"}'), // Display token
                  const SizedBox(height: 10),
                  // Display permission status nicely
                  Text('Permission Status: ${_latestPermissionStatus?.name ?? "N/A"}'), 
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
                ], // End of children list for Column
              ), // End of Column
            ); // End of Padding (Return value for Builder's builder function)
          }, // End of builder function for Builder
        ), // End of Builder widget
      ), // End of Scaffold widget
    ); // End of MaterialApp widget
  } // End of build method
<<<<<<< HEAD
=======

  // --- ADDED Push Event Listener Setup ---
  void _listenToPushEvents() {
    _tokenSubscription = _plugin.onTokenUpdated.listen(
      (token) {
        if (mounted) {
          setState(() {
            _latestToken = token;
          });
          print("Example App: Received Token: $token");
        }
      },
      onError: (error) {
         if (mounted) {
          setState(() {
            _latestToken = "Error: $error";
          });
           print("Example App: Token Stream Error: $error");
        }
      },
      onDone: () {
         if (mounted) { // Should not happen for broadcast streams unless plugin is disposed
           setState(() {
              _latestToken = "Stream Closed";
           });
            print("Example App: Token Stream Closed");
         }
      }
    );

    _permissionStatusSubscription = _plugin.onPermissionStatusUpdated.listen(
      (status) {
         if (mounted) {
          setState(() {
            _latestPermissionStatus = status;
          });
           print("Example App: Received Permission Status: $status");
        }
      },
       onError: (error) {
         if (mounted) {
           setState(() {
             _latestPermissionStatus = null; // Indicate error state
             // Maybe display error differently?
           });
           print("Example App: Permission Status Stream Error: $error");
         }
       },
       onDone: () {
          if (mounted) {
            print("Example App: Permission Status Stream Closed");
          }
       }
    );
  }
  // --- END ADDED Listener Setup ---
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
} // End of _MyAppState class
