//
//  NuggetFlutterTicketCreationImp.swift
//  nugget_flutter_plugin
//
//  Created by Rajesh Budhiraja on 21/05/25.
//

import Foundation
import Flutter
import NuggetSDK

public final class NuggetFlutterTicketCreationImp: NuggetTicketCreationDelegate {
    
    let ticketSuccessHandler = NuggetFlutterPluginEventStreamHandler()
    let ticketFailureHandler = NuggetFlutterPluginEventStreamHandler()
    
    public func ticketCreationSucceeded(with conversationID: String) {
        ticketSuccessHandler.sendEvent(data: conversationID)
    }
    
    public func ticketCreationFailed(withError errorMessage: String?) {
        ticketFailureHandler.sendEvent(data: errorMessage)
    }
}
