//
//  NuggetFlutterPluginAuthUserInfo.swift
//  nugget_flutter_plugin
//
//  Created by Rajesh Budhiraja on 21/05/25.
//

import Foundation
import NuggetSDK
import Flutter

struct NuggetFlutterPluginAuthUserInfo: NuggetAuthUserInfo {
    let clientID: Int
    let accessToken: String
    let userID: String
    let userName: String?
    let photoURL: String
    let displayName: String
    
    init?(fromDictionary dict: [String: Any]) {
        guard let clientID = dict["clientID"] as? Int,
              let accessToken = dict["accessToken"] as? String,
              let userID = dict["userID"] as? String,
              let photoURL = dict["photoURL"] as? String,
              let displayName = dict["displayName"] as? String
        else {
            return nil
        }
        self.clientID = clientID
        self.accessToken = accessToken
        self.userID = userID
        self.userName = dict["userName"] as? String
        self.photoURL = photoURL
        self.displayName = displayName
    }
}
