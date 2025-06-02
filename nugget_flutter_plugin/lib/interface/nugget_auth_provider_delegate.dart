import 'package:nugget_flutter_plugin/interface/nugget_auth_info.dart';

abstract class NuggetAuthProviderDelegate {
    Future<NuggetAuthInfo?> requireAuthInfo();
    Future<NuggetAuthInfo?> refreshAuthInfo();
    Future<String?> fetchAccessTokenFromClient();
} 