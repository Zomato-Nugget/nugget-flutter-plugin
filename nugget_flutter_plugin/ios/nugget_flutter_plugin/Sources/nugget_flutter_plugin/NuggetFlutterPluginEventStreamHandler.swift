//
//  NuggetFlutterPluginEventStreamHandler.swift
//  nugget_flutter_plugin
//
//  Created by Rajesh Budhiraja on 21/05/25.
//

import Foundation
import Flutter

public final class NuggetFlutterPluginEventStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    func sendEvent(data: Any?) {
        guard let sink = self.eventSink else {
            return
        }
        DispatchQueue.main.async {
            sink(data)
        }
    }
}
