//
//  NuggetFlutterFontProviderImp.swift
//  nugget_flutter_plugin
//
//  Created by Rajesh Budhiraja on 21/05/25.
//

import Foundation
import Flutter
import NuggetSDK

final class NuggetFlutterFontProviderImp: NuggetFontProviderDelegate {
    var customFontMapping: (any NuggetFontPropertiesMapping)?
    
    func fontPropertiesMapping() -> (any NuggetFontPropertiesMapping)? {
        return customFontMapping
    }
    
    init(customFontMapping: (any NuggetFontPropertiesMapping)? = nil) {
        self.customFontMapping = customFontMapping
    }
}
