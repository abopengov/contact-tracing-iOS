import UIKit

enum ButtonStyle {
    case primary
    case secondary
    case secondaryMedium
    case underline

    var textColor: UIColor {
        switch self {
        case .primary:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)

        case .secondary, .secondaryMedium:
            return UIColor(red: 0, green: 0.439, blue: 0.769, alpha: 1)

        case .underline:
            return UIColor(red: 0, green: 0.439, blue: 0.769, alpha: 1)
        }
    }
}

enum ButtonImage {
    case arrow
    case check
    case clickout
    case secondaryClickout
    case secondaryArrow
    case secondaryShare

    var name: String {
        switch self {
        case .arrow:
            return "Arrow"

        case .check:
            return "Checkmark"

        case .secondaryClickout:
            return "TakeMeIcon"

        case .clickout:
            return "TakeMeIconWhite"

        case .secondaryArrow:
            return "Secondary Arrow"

        case .secondaryShare:
            return "ShareArrowBlue"
        }
    }
}

extension UIButton {
    func setButton(with text: String, and buttonImage: ButtonImage? = nil, buttonStyle: ButtonStyle = .primary) {
        let fontName = buttonStyle == .underline
            ? "HelveticaNeue"
            : buttonStyle == .secondaryMedium
            ? "HelveticaNeue-Medium"
            : "HelveticaNeue-Bold"
        let fontSize = (buttonStyle == .underline || buttonStyle == .secondaryMedium) ? CGFloat(16) : CGFloat(18)

        guard let font = UIFont(name: fontName, size: fontSize) else {
            return
        }

        switch buttonStyle {
        case .primary:
            if self.isEnabled {
                self.backgroundColor = UIColor(red: 0, green: 0.439, blue: 0.769, alpha: 1)
            } else {
                self.backgroundColor = UIColor(red: 0.646, green: 0.646, blue: 0.646, alpha: 1)
            }

        case .secondary, .secondaryMedium:
            self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            self.borderWidth = 1
            self.borderColor = UIColor(red: 0, green: 0.439, blue: 0.769, alpha: 1)

        case .underline:
            self.backgroundColor = UIColor.clear
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: buttonStyle.textColor,
            .paragraphStyle: paragraphStyle
        ]

        if buttonStyle == .underline {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }

        let localizedText = NSLocalizedString(
            text,
            tableName: "",
            bundle: BKLocalizationManager.sharedInstance.currentBundle,
            value: BKLocalizationManager.sharedInstance.defaultStrings[text] ?? "",
            comment: ""
        )

        let fullString = NSMutableAttributedString(
            string: localizedText,
            attributes: attributes
        )

        fullString.append(NSAttributedString(string: "  "))

        guard let buttonImageName = buttonImage?.name else {
            self.setAttributedTitle(fullString, for: .normal)
            self.layoutIfNeeded()
            return
        }

        if let buttonImage = UIImage(named: buttonImageName) {
            let image1Attachment = textAttachment(font: font, image: buttonImage)

            let image1String = NSAttributedString(attachment: image1Attachment)

            fullString.append(image1String)
            self.setAttributedTitle(fullString, for: .normal)
        }

        self.layoutIfNeeded()
    }

    private func textAttachment(font: UIFont, image: UIImage) -> NSTextAttachment {
        let font = font
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        let mid = font.descender + font.capHeight
        textAttachment.bounds = CGRect(x: 0, y: font.descender - image.size.height / 2 + mid + 2, width: image.size.width, height: image.size.height).integral
        return textAttachment
    }
}
