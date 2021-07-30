import UIKit

public class UILabelWithLink: UILabel {
    weak var delegate: UILabelWithLinkDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    private func configure() {
        isUserInteractionEnabled = true
    }

    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let superBool = super.point(inside: point, with: event)

        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        guard let attributedText = attributedText else {
            return false
        }

        guard let font = font else {
            return false
        }

        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: attributedText.length))
        textStorage.addLayoutManager(layoutManager)

        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let locationOfTouchInTextContainer = CGPoint(x: point.x + textBoundingBox.origin.x, y: point.y + textBoundingBox.origin.y)
        let characterIndex = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        let lineTapped = Int(ceil(point.y / font.lineHeight)) - 1
        let rightMostPointInLineTapped = CGPoint(x: bounds.size.width, y: font.lineHeight * CGFloat(lineTapped))
        let charsInLineTapped = layoutManager.characterIndex(for: rightMostPointInLineTapped, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        guard characterIndex < charsInLineTapped else {
            return false
        }

        let attributeValue = self.attributedText?.attribute(NSAttributedString.Key.attachment, at: characterIndex, effectiveRange: nil)

        if let value = attributeValue {
            delegate?.linkClickedWithValue(value)
        }

        return superBool
    }
}

protocol UILabelWithLinkDelegate: AnyObject {
    func linkClickedWithValue(_ value: Any)
}
