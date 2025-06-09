import UIKit

class FontList {
    static func listInstalledFonts() {
        // Get all font family names
        let fontFamilies = UIFont.familyNames.sorted()
        
        print("=== Installed Fonts ===")
        
        // Iterate through each font family
        for family in fontFamilies {
            print("\nFamily: \(family)")
            
            // Get all font names in this family
            let fontNames = UIFont.fontNames(forFamilyName: family).sorted()
            
            // Print each font name in the family
            for fontName in fontNames {
                print("  - \(fontName)")
                
                // Try to create a font instance to verify it's loadable
                if let font = UIFont(name: fontName, size: 12) {
                    print("    ✓ Loadable")
                    print("    PostScript Name: \(font.fontName)")
                    print("    Family Name: \(font.familyName)")
                } else {
                    print("    ✗ Not loadable")
                }
            }
        }
    }
    
    static func checkAmericanTypewriter() {
        print("\n=== American Typewriter Font Details ===")
        
        // Check if American Typewriter is available
        let fontNames = UIFont.fontNames(forFamilyName: "American Typewriter")
        
        if fontNames.isEmpty {
            print("American Typewriter font family not found")
        } else {
            print("Available styles:")
            for fontName in fontNames {
                print("  - \(fontName)")
                
                // Create a font instance to get more details
                if let font = UIFont(name: fontName, size: 12) {
                    print("    PostScript Name: \(font.fontName)")
                    print("    Family Name: \(font.familyName)")
                    print("    Point Size: \(font.pointSize)")
                    print("    Line Height: \(font.lineHeight)")
                }
            }
        }
    }
}

// Usage example:
// FontList.listInstalledFonts()
// FontList.checkAmericanTypewriter() 