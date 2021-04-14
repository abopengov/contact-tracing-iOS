import UIKit

extension UITextView {
    // swiftlint:disable:next function_parameter_count
    func setAttributedEmailLink(
        with startText: String,
        linkText: String,
        linkurl: String,
        middleText: String,
        secondLinkText: String,
        secondLinkurl: String,
        secondMiddleText: String,
        firstEmailLink: String,
        endText: String,
        secondEmailLink: String
    ) {
        let attributedEmailString = NSMutableAttributedString(string: firstEmailLink)
        attributedEmailString.addAttribute(.link, value: "mailto:" + firstEmailLink, range: NSRange(location: 0, length: firstEmailLink.count))

        let linkString = NSMutableAttributedString(string: linkText)
        linkString.addAttribute(.link, value: linkurl, range: NSRange(location: 0, length: linkText.count))

        let secondLinkString = NSMutableAttributedString(string: secondLinkText)
        secondLinkString.addAttribute(.link, value: secondLinkurl, range: NSRange(location: 0, length: secondLinkText.count))

        let attributedEmailStringTwo = NSMutableAttributedString(string: secondEmailLink)
        attributedEmailStringTwo.addAttribute(.link, value: "mailto:" + secondEmailLink, range: NSRange(location: 0, length: secondEmailLink.count))

        let fullAttributedString = NSMutableAttributedString(string: startText)
        fullAttributedString.append(linkString)
        fullAttributedString.append(NSMutableAttributedString(string: middleText))
        fullAttributedString.append(secondLinkString)
        fullAttributedString.append(NSMutableAttributedString(string: secondMiddleText))
        fullAttributedString.append(attributedEmailString)
        fullAttributedString.append(NSMutableAttributedString(string: endText))
        fullAttributedString.append(attributedEmailStringTwo)
        fullAttributedString.append(NSMutableAttributedString(string: "."))

        self.textColor = UIColor(red: 0.098, green: 0.094, blue: 0.094, alpha: 1)
        self.textAlignment = .left
        self.attributedText = fullAttributedString
        self.font = UIFont(name: "HelveticaNeue", size: 14)
    }

    func setTextView(with text: String) {
        self.textColor = UIColor(red: 0.098, green: 0.094, blue: 0.094, alpha: 1)
        self.font = UIFont(name: "HelveticaNeue", size: 14)
        // let fontMetrics = UIFontMetrics(forTextStyle: .body)
        self.text = text
        self.sizeToFit()
        self.isScrollEnabled = false
        self.isSelectable = true
        self.textAlignment = .left
        self.isEditable = false
        self.dataDetectorTypes = UIDataDetectorTypes.all
    }
}
