import 'package:nugget_flutter_plugin/interface/nugget_auth_info.dart';

abstract class NuggetAuthProviderDelegate {
    Future<NuggetAuthInfo?> requireAuthInfo(String requestId);
    Future<NuggetAuthInfo?> refreshAuthInfo(String requestId);
    Future<String?> fetchAccessTokenFromClient();
} 