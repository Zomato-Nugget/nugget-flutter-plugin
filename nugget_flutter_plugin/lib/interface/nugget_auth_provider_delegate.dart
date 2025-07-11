import 'package:nugget_flutter_plugin/interface/nugget_auth_info.dart';
import 'dart:collection';

abstract class NuggetAuthProviderDelegate {
    Future<NuggetAuthInfo?> requireAuthInfo(String requestId , HashMap<String,String>? payload);
    Future<NuggetAuthInfo?> refreshAuthInfo(String requestId , HashMap<String,String>? payload);
    Future<String?> fetchAccessTokenFromClient();
    Future<String> handleDeeplinkInsideApp(String deeplink);
} 