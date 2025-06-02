//
//  NuggetFluterThemeProviderImp.swift
//  nugget_flutter_plugin
//
//  Created by Rajesh Budhiraja on 21/05/25.
//

import Foundation
import Flutter
import NuggetSDK

final class NuggetFluterThemeProviderImp: NuggetThemeProviderDelegate {
    var defaultLightModeAccentHexColor: String
    var defaultDarktModeAccentHexColor: String
    var deviceInterfaceStyle: UIUserInterfaceStyle
    
    init(defaultLightModeAccentHexColor: String,
         defaultDarkModeAccentHexColor: String,
         deviceInterfaceStyle: UIUserInterfaceStyle) {
        self.defaultLightModeAccentHexColor = defaultLightModeAccentHexColor
        self.defaultDarktModeAccentHexColor = defaultDarkModeAccentHexColor
        self.deviceInterfaceStyle = deviceInterfaceStyle
    }
    
    init(themeData: [String: Any]) {
        if let defaultDarkModeAccentHexColor = themeData["defaultDarkModeAccentHexColor"] as? String,
           let deviceInterfaceStyleString = themeData["deviceInterfaceStyle"] as? String,
           let defaultLightModeAccentHexColor = themeData["defaultLightModeAccentHexColor"] as? String {
            let deviceInterfaceStyle: UIUserInterfaceStyle
            switch deviceInterfaceStyleString {
            case "system":
                deviceInterfaceStyle = .unspecified
            case "dark":
                deviceInterfaceStyle = .dark
            default:
                deviceInterfaceStyle = .light
            }
            self.defaultLightModeAccentHexColor = defaultLightModeAccentHexColor
            self.defaultDarktModeAccentHexColor = defaultDarkModeAccentHexColor
            self.deviceInterfaceStyle = deviceInterfaceStyle
        } else {
            self.defaultLightModeAccentHexColor = "#6B46C1"
            self.defaultDarktModeAccentHexColor = "#6B46C1"
            self.deviceInterfaceStyle = .unspecified
        }
    }
}
