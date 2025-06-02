import 'nugget_auth_info.dart';
import 'nugget_user_info.dart';

abstract class NuggetAuthUserInfo implements NuggetAuthInfo, NuggetUserInfo {
    Map<String, dynamic> toJson();
}

// Concrete implementation of the combined auth/user info interface
class NuggetAuthUserInfoImpl implements NuggetAuthUserInfo {
    
    // Define the fields required by the implemented interfaces
    @override
    final int clientID;
    @override
    final String accessToken;
    @override
    final String userID;
    @override
    final String userName;
    @override
    final String photoURL;
    @override
    final String displayName;

    NuggetAuthUserInfoImpl({
        required this.clientID,
        required this.accessToken,
        required this.userID,
        required this.userName,
        required this.photoURL,
        required this.displayName,
    });
    
    // Factory constructor to parse from a Map (e.g., from platform channel)
    factory NuggetAuthUserInfoImpl.fromJson(Map<String, dynamic> json) {
        return NuggetAuthUserInfoImpl(
            clientID: json['clientID'] as int? ?? 0,
            accessToken: json['accessToken'] as String? ?? '',
            userID: json['userID'] as String? ?? '',
            userName: json['userName'] as String? ?? '',
            photoURL: json['photoURL'] as String? ?? '',
            displayName: json['displayName'] as String? ?? '',
        );
    }

    @override
    Map<String, dynamic> toJson() {
        return {
            'clientID': clientID,
            'accessToken': accessToken,
            'userID': userID,
            'userName': userName,
            'photoURL': photoURL,
            'displayName': displayName,
        };
    }
} 