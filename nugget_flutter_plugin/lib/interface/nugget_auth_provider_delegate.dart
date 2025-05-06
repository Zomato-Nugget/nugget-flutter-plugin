import 'nugget_auth_user_info.dart';

abstract class NuggetAuthProviderDelegate {
    Future<NuggetAuthUserInfo?> requireAuthInfo();
    Future<NuggetAuthUserInfo?> refreshAuthInfo();
} 