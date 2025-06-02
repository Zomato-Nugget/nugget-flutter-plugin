//
//  NuggetFlutterAuthProviderImp.swift
//  nugget_flutter_plugin
//
//  Created by Rajesh Budhiraja on 21/05/25.
//

import Foundation
import NuggetSDK
import Flutter

final class NuggetFlutterAuthProviderImp: NuggetAuthProviderDelegate {
    
    private var channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    public func authManager(requiresAuthInfo completion: @escaping (NuggetAuthUserInfo?, Error?) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            channel.invokeMethod("requireAuthInfo", arguments: nil) { [weak self] flutterResult in
                self?.handleAuthCompletion(flutterResult: flutterResult, sdkCompletion: completion)
            }
        }
    }
    
    public func authManager(requestRefreshAuthInfo completion: @escaping (NuggetAuthUserInfo?, Error?) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            channel.invokeMethod("refreshAuthInfo", arguments: nil) { [weak self] flutterResult in
                self?.handleAuthCompletion(flutterResult: flutterResult, sdkCompletion: completion)
            }
        }
    }
    
    private func handleAuthCompletion(flutterResult: Any?, sdkCompletion: @escaping (NuggetAuthUserInfo?, Error?) -> Void) {
        guard let resultData = flutterResult else {
            let error = NSError(domain: "PluginError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Auth failed: Dart returned nil"])
            sdkCompletion(nil, error)
            return
        }
        
        if let error = resultData as? FlutterError {
            let nsError = NSError(domain: "FlutterError",
                                  code: Int(error.code) ?? -1,
                                  userInfo: [NSLocalizedDescriptionKey: error.message ?? "Error from Dart auth",
                                             "FlutterErrorDetails": error.details ?? "N/A"])
            sdkCompletion(nil, nsError)
        } else if let dict = resultData as? [String: Any] {
            if let userInfo = NuggetFlutterPluginAuthUserInfo(fromDictionary: dict) {
                sdkCompletion(userInfo, nil)
            } else {
                let error = NSError(domain: "PluginError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Auth failed: Could not parse auth info from Dart"])
                sdkCompletion(nil, error)
            }
        } else {
            let error = NSError(domain: "PluginError", code: -4, userInfo: [NSLocalizedDescriptionKey: "Auth failed: Received unexpected data type from Dart"])
            sdkCompletion(nil, error)
        }
    }
}
