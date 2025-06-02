//
//  NuggetFlutterFontSizeMapping.swift
//  nugget_flutter_plugin
//
//  Created by Rajesh Budhiraja on 21/05/25.
//

import Foundation
import NuggetSDK
import Flutter

final class NuggetFlutterFontSizeMapping: NuggetFontPropertiesMapping {
    let fontName: String
    let fontFamily: String
    let fontWeightMapping: [NuggetFontWeights : String]
    let fontSizeMappingDict: [String: Int]
    
    init?(fromDictionary dict: [String: Any]) {
        guard let fontName = dict["fontName"] as? String,
              let fontFamily = dict["fontFamily"] as? String,
              let rawWeightMap = dict["fontWeightMapping"] as? [String: String],
              let rawSizeMap = dict["fontSizeMapping"] as? [String: Int],
              let fontsData = dict["fontsData"] as? [FlutterStandardTypedData]
        else {
            return nil
        }
        
        fontsData.forEach { fontData in
            if let provider = CGDataProvider(data: fontData.data as CFData),
               let font = CGFont(provider) {
                CTFontManagerRegisterGraphicsFont(font, nil)
            }
        }
        
        // Validate font name and family are not empty
        guard !fontName.isEmpty, !fontFamily.isEmpty else {
            return nil
        }
        
        self.fontName = fontName
        self.fontFamily = fontFamily
        
        // Validate size mapping has required entries
        let requiredSizes = ["font050", "font100", "font200", "font300", "font400", "font500", "font600", "font700", "font800", "font900"]
        let hasAllSizes = requiredSizes.allSatisfy { rawSizeMap[$0] != nil }
        guard hasAllSizes else {
            return nil
        }
        self.fontSizeMappingDict = rawSizeMap
        
        // Create weight mapping with validation
        var finalWeightMap: [NuggetFontWeights: String] = [:]
        for (key, value) in rawWeightMap {
            if let weightEnum = NuggetFontWeights(string: key) {
                guard !value.isEmpty else {
                    continue
                }
                finalWeightMap[weightEnum] = value
            }
        }
        
        // Ensure we have at least regular weight
        guard finalWeightMap[.regular] != nil else {
            return nil
        }
        
        self.fontWeightMapping = finalWeightMap
    }
    
    func fontSizeMapping(fontSize: NuggetFontSizes) -> Int {
        let key = fontSize.stringValue
        let defaultSize = 14 // Default size for regular text
        let size = fontSizeMappingDict[key] ?? defaultSize
        return max(8, min(size, 40)) // Ensure size is within reasonable bounds
    }
}

extension NuggetFontWeights {
    init?(string: String) {
        switch string.lowercased() {
        case "light": self = .light
        case "regular": self = .regular
        case "medium": self = .medium
        case "semibold": self = .semiBold
        case "bold": self = .bold
        case "extrabold": self = .extraBold
        case "black": self = .black
        default:
            return nil
        }
    }
}

extension NuggetFontSizes {
    var stringValue: String {
        switch self {
        case .font050: return "font050"
        case .font100: return "font100"
        case .font200: return "font200"
        case .font300: return "font300"
        case .font400: return "font400"
        case .font500: return "font500"
        case .font600: return "font600"
        case .font700: return "font700"
        case .font800: return "font800"
        case .font900: return "font900"
        }
    }
}
