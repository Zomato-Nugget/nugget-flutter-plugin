<<<<<<< HEAD
import 'package:nugget_flutter_plugin/interface/nugget_auth_info.dart';

abstract class NuggetAuthProviderDelegate {
    Future<NuggetAuthInfo?> requireAuthInfo();
    Future<NuggetAuthInfo?> refreshAuthInfo();
    Future<String?> fetchAccessTokenFromClient();
=======
import 'nugget_auth_user_info.dart';

abstract class NuggetAuthProviderDelegate {
    Future<NuggetAuthUserInfo?> requireAuthInfo();
    Future<NuggetAuthUserInfo?> refreshAuthInfo();
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
} 