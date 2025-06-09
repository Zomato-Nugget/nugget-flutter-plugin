abstract class NuggetAuthInfo {
    String get accessToken;
    String get requestId;
    int get httpStatusCode;
    /// Serializes this NuggetAuthInfo instance to a JSON map.
    Map<String, dynamic> toJson();
} 