import '../interface/nugget_auth_info.dart';

final class NuggetAuthInfoImp implements NuggetAuthInfo {
    final int? clientID;
    final String accessToken;
    final String? userID;
    final String? photoURL;
    final String? displayName;
    final String? userName;
    final String requestId;
    final int httpStatusCode;

    NuggetAuthInfoImp({
        required this.accessToken,
        required this.httpStatusCode,
        required this.requestId,
        this.userID,
        this.photoURL,
        this.displayName,
        this.userName,
        this.clientID,
    });

    @override
    Map<String, dynamic> toJson() {
        return {
            'clientID': clientID ?? 1,
            'accessToken': accessToken,
            'userID': userID ?? '',
            'photoURL': photoURL ?? '',
            'displayName': displayName ?? '',
            'userName': userName ?? '',
            "requestId": requestId,
            "httpStatusCode": httpStatusCode,
        };
    }
}