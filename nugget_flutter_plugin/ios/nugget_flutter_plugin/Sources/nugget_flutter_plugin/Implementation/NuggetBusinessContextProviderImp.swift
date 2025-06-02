//
//  NuggetBusinessContextProviderImp.swift
//  nugget_flutter_plugin
//
//  Created by Rajesh Budhiraja on 29/05/25.
//

import Foundation
import Flutter
import NuggetSDK

public class NuggetBusinessContextProviderImp: NuggetBusinessContextProviderDelegate {
    
    struct BusinessContext: NuggetChatBusinessContext {
        var channelHandle: String?
        
        var ticketGroupingId: String?
        
        var ticketProperties: [String : [String]]?
        
        var botProperties: [String : [String]]?
        
        init(channelHandle: String? = nil,
             ticketGroupingId: String? = nil,
             ticketProperties: [String : [String]]? = nil,
             botProperties: [String : [String]]? = nil) {
            self.channelHandle = channelHandle
            self.ticketGroupingId = ticketGroupingId
            self.ticketProperties = ticketProperties
            self.botProperties = botProperties
        }
    }
    
    private var businessContext: BusinessContext = .init()
    
    init(businessContext: [String: Any]) {
        let channelHandle = businessContext["channelHandle"] as? String
        let ticketGroupingId = businessContext["ticketGroupingId"] as? String
        let ticketProperties: [String: [String]]? = (businessContext["ticketProperties"] as? [String: [String]])
        let botProperties: [String: [String]]? = (businessContext["botProperties"] as? [String: [String]])
        
        self.businessContext = BusinessContext(channelHandle: channelHandle,
                                               ticketGroupingId: ticketGroupingId,
                                               ticketProperties: ticketProperties,
                                               botProperties: botProperties)
    }
    
    
    
    public func chatSupportBusingessContext() -> any NuggetChatBusinessContext {
        businessContext
    }
    
    
}
