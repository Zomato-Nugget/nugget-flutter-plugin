import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import the main plugin file, which now exports the handler
import 'package:nugget_flutter_plugin/nugget_flutter_plugin.dart';

void main() {
  // Ensure bindings are initialized before calling plugin code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the handler for native -> Dart calls
  NuggetPluginNativeCallbackHandler.initializeHandler();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _plugin = NuggetFlutterPlugin();
  final _deeplinkController = TextEditingController();
  static const _deeplinkPrefKey = 'saved_deeplink';

  bool _isInitialized = false;
  String _status = 'SDK Not Initialized';
  
  // --- ADDED State for Push Info ---
  String? _latestToken = "Not received yet";
  NuggetPushPermissionStatus? _latestPermissionStatus;
  // --- END ADDED State ---
  
  // REMOVED Callbacks state (Keep if needed for Ticket/Other callbacks)
  // final List<String> _callbackMessages = [];
  // StreamSubscription? _ticketSuccessSubscription;
  // StreamSubscription? _ticketFailureSubscription;
  
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
    _listenToPushEvents();
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
  }

  // Updated to handle initialization check and call
  Future<void> _openChatModally(BuildContext scaffoldContext) async {
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
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(content: Text('Error opening chat: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Start of MaterialApp widget
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
          builder: (builderContext) { // Use a different name like builderContext
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
                  Text('Status: $_status'),
                  const SizedBox(height: 10),
                  Text('Push Token: ${_latestToken ?? "N/A"}'), // Display token
                  const SizedBox(height: 10),
                  // Display permission status nicely
                  Text('Permission Status: ${_latestPermissionStatus?.name ?? "N/A"}'), 
                ], // End of children list for Column
              ), // End of Column
            ); // End of Padding (Return value for Builder's builder function)
          }, // End of builder function for Builder
        ), // End of Builder widget
      ), // End of Scaffold widget
    ); // End of MaterialApp widget
  } // End of build method

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
} // End of _MyAppState class
