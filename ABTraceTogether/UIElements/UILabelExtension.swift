import UIKit

enum StringStyles {
    case h2
    case body
    case eyebrowText
    case stepText
    case h2LeftAligned
    case itemText
    case infoText
}

extension UILabel {
    func setLabel(
        with text: String,
        using stringStyle: StringStyles,
        localize: Bool = true
    ) {
        self.textColor = UIColor(red: 0.098, green: 0.094, blue: 0.094, alpha: 1)
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.textAlignment = .center

        var localizedText = text

        if localize {
            localizedText = NSLocalizedString(
                text,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[text] ?? "",
                comment: ""
            )
        }

        switch stringStyle {
        case .h2:
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
            self.text = localizedText.uppercased()

        case .body:
            self.font = UIFont(name: "HelveticaNeue", size: 14)
            self.text = localizedText

        case .eyebrowText:
            self.font = UIFont(name: "HelveticaNeue-LightItalic", size: 10)
            self.text = localizedText

        case .stepText:
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
            self.textColor = UIColor(red: 0.646, green: 0.646, blue: 0.646, alpha: 1)
            self.text = localizedText.uppercased()

        case .h2LeftAligned:
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
            self.text = localizedText.uppercased()
            self.textAlignment = .left

        case .itemText:
            self.font = UIFont(name: "HelveticaNeue", size: 16)
            self.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.00)
            self.text = localizedText
            self.textAlignment = .left
            self.setLineSpacing(3)

        case .infoText:
            self.font = UIFont(name: "HelveticaNeue-Italic", size: 15)
            self.textColor = UIColor(red: 0.21, green: 0.21, blue: 0.21, alpha: 1.00)
            self.text = localizedText
            self.textAlignment = .left
            self.setLineSpacing(3)
        }
    }
}

extension UILabel {
    func setCharacterSpacing(characterSpacing: CGFloat = 0.0) {
        guard let labelText = text else {
            return
        }
        let attributedString: NSMutableAttributedString
        if let labelAttributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        // Character spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length - 1))
        attributedText = attributedString
    }
    
    func setLineSpacing(_ lineSpacing: CGFloat = 0.0) {
        guard let labelText = text else {
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
