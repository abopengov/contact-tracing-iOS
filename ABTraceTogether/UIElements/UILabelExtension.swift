import UIKit

enum StringStyles {
    case h2
    case body
    case boldBodyText
    case eyebrowText
    case stepText
    case h2LeftAligned
    case itemText
    case infoText
    case blackBigTitleText
    case whiteBigTitleText
    case blackTitleText
    case whiteTitleText
    case whiteSubtitleText
    case blackDescriptionText
    case blackDescriptionCenteredText
    case whiteDescriptionText
    case grayTitleText
    case grayTitleMediumText
    case grayDescriptionText
    case grayDescriptionCenteredText
    case grayItalicText
    case grayCenterText
    case blueText
    case blueLinkText
}

extension UILabel {
    // swiftlint:disable:next cyclomatic_complexity
    func setLabel(
        with text: String,
        using stringStyle: StringStyles,
        localize: Bool = true
    ) {
        self.textColor = UIColor(red: 0.098, green: 0.094, blue: 0.094, alpha: 1)
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.textAlignment = .center

        var localizedText = localize ? getLocalizedText(text) : text

        switch stringStyle {
        case .h2:
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
            self.text = localizedText.uppercased()

        case .body:
            self.font = UIFont(name: "HelveticaNeue", size: 14)
            self.text = localizedText

        case .boldBodyText:
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
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

        case .blackBigTitleText:
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            self.text = localizedText
            self.textColor = UIColor.black
            self.textAlignment = .left

        case .whiteBigTitleText:
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            self.text = localizedText
            self.textColor = UIColor.white
            self.textAlignment = .left

        case .blackTitleText:
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
            self.text = localizedText
            self.textColor = UIColor.black
            self.textAlignment = .left
            self.setLineSpacing(3)

        case .whiteTitleText:
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
            self.text = localizedText
            self.textColor = UIColor.white
            self.textAlignment = .left

        case .whiteSubtitleText:
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
            self.text = localizedText
            self.textColor = UIColor.white
            self.textAlignment = .left

        case .blackDescriptionText:
            self.font = UIFont(name: "HelveticaNeue", size: 16)
            self.text = localizedText
            self.textColor = UIColor.black
            self.setLineSpacing(3)

        case .blackDescriptionCenteredText:
            self.font = UIFont(name: "HelveticaNeue", size: 16)
            self.text = localizedText
            self.textColor = UIColor.black
            self.setLineSpacing(3, alignment: .center)

        case .whiteDescriptionText:
            self.font = UIFont(name: "HelveticaNeue", size: 14)
            self.text = localizedText
            self.textColor = UIColor.white
            self.setLineSpacing(3)

        case .grayTitleText:
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
            self.textColor = UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00)
            self.text = localizedText
            self.setLineSpacing(3, alignment: .center)

        case .grayTitleMediumText:
            self.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
            self.textColor = UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00)
            self.text = localizedText
            self.textAlignment = .left
            self.setLineSpacing(3)

        case .grayDescriptionText:
            self.font = UIFont(name: "HelveticaNeue", size: 16)
            self.text = localizedText
            self.textColor = UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00)
            self.setLineSpacing(3)

        case .grayDescriptionCenteredText:
            self.font = UIFont(name: "HelveticaNeue", size: 16)
            self.textColor = UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00)
            self.text = localizedText
            self.setLineSpacing(3, alignment: .center)

        case .grayItalicText:
            self.font = UIFont(name: "HelveticaNeue-LightItalic", size: 14)
            self.textColor = UIColor(red: 0.41, green: 0.41, blue: 0.41, alpha: 1.00)
            self.text = localizedText
            self.setLineSpacing(3, alignment: .center)

        case .grayCenterText:
            self.font = UIFont(name: "HelveticaNeue", size: 14)
            self.textColor = UIColor(red: 0.41, green: 0.41, blue: 0.41, alpha: 1.00)
            self.text = localizedText
            self.setLineSpacing(3, alignment: .center)

        case .blueText:
            self.font = UIFont(name: "HelveticaNeue", size: 16)
            self.textColor = UIColor(red: 0.00, green: 0.44, blue: 0.77, alpha: 1.00)
            self.text = localizedText
            self.setLineSpacing(3, alignment: .left)

        case .blueLinkText:
            self.font = UIFont(name: "HelveticaNeue", size: 14)
            self.textColor = UIColor(red: 0.00, green: 0.44, blue: 0.77, alpha: 1.00)
            self.text = localizedText
            self.setLineSpacing(3, alignment: .center)
        }
    }

    private func getLocalizedText(_ text: String) -> String {
        NSLocalizedString(
            text,
            tableName: "",
            bundle: BKLocalizationManager.sharedInstance.currentBundle,
            value: BKLocalizationManager.sharedInstance.defaultStrings[text] ?? "",
            comment: ""
        )
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

        attributedString.addAttribute(
            NSAttributedString.Key.kern,
            value: characterSpacing,
            range: NSRange(location: 0, length: attributedString.length - 1)
        )
        attributedText = attributedString
    }

    func setLineSpacing(_ lineSpacing: CGFloat = 0.0, alignment: NSTextAlignment = .left) {
        guard let labelText = text else {
            return
        }

        let attributedString: NSMutableAttributedString
        if let labelAttributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment

        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length - 1)
        )
        self.attributedText = attributedString
    }

    func addLink(textToFind: String, linkURL: String) {
        if let attributedText = self.attributedText {
            let linkedText = NSMutableAttributedString(attributedString: attributedText)
            linkedText.setAsLink(textToFind: getLocalizedText(textToFind), linkURL: linkURL)
            self.attributedText = linkedText
        }
    }

    func underline() {
        if let attributedText = self.attributedText {
            let attributedString = NSMutableAttributedString(attributedString: attributedText)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
    }
}
