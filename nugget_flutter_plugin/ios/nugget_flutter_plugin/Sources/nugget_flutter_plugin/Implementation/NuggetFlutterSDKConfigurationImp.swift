//
//  NuggetFlutterSDKConfigurationImp.swift
//  nugget_flutter_plugin
//
//  Created by Rajesh Budhiraja on 21/05/25.
//

import Foundation
import Flutter
import NuggetSDK

final class NuggetSDKConfigurationImplementation: NuggetSDKConfigurationDelegate {
    
    private let channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    func jumboConfiguration(completion: @escaping (NuggetJumboConfiguration) -> Void) {
        channel.invokeMethod("jumboConfiguration", arguments: nil) { flutterResult in
            if let error = flutterResult as? FlutterError {
                completion(.init(nameSpace: ""))
            } else {
                let dict = flutterResult as? [String: Any]
                let name = dict?["namespace"] as? String ?? ""
                completion(.init(nameSpace: name))
            }
        }
    }
    
    func chatScreenClosedCallback() {}
}
