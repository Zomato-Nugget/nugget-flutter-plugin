import UIKit

class FontListViewController: UIViewController {
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont(name: "AmericanTypewriter", size: 14)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayFontList()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func displayFontList() {
        var output = ""
        
        // Get all font family names
        let fontFamilies = UIFont.familyNames.sorted()
        
        output += "=== Installed Fonts ===\n\n"
        
        // Iterate through each font family
        for family in fontFamilies {
            output += "Family: \(family)\n"
            
            // Get all font names in this family
            let fontNames = UIFont.fontNames(forFamilyName: family).sorted()
            
            // Print each font name in the family
            for fontName in fontNames {
                output += "  - \(fontName)\n"
            }
            output += "\n"
        }
        
        // Add American Typewriter specific details
        output += "\n=== American Typewriter Font Details ===\n"
        let americanTypewriterFonts = UIFont.fontNames(forFamilyName: "American Typewriter")
        
        if americanTypewriterFonts.isEmpty {
            output += "American Typewriter font family not found\n"
        } else {
            output += "Available styles:\n"
            for fontName in americanTypewriterFonts {
                output += "  - \(fontName)\n"
                
                // Create a font instance to get more details
                if let font = UIFont(name: fontName, size: 12) {
                    output += "    PostScript Name: \(font.fontName)\n"
                    output += "    Family Name: \(font.familyName)\n"
                    output += "    Point Size: \(font.pointSize)\n"
                    output += "    Line Height: \(font.lineHeight)\n"
                }
            }
        }
        
        textView.text = output
    }
} 