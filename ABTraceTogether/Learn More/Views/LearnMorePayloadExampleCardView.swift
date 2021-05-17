import UIKit

class LearnMorePayloadExampleCardView: UIView {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var payloadExampleLabel: UILabel!
    @IBOutlet private var cardImageView: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.setLabel(with: infoExchangedPage3Title, using: .grayTitleMediumText)

        guard let normalFont = UIFont(name: "HelveticaNeue", size: 16.0), let boldFont = UIFont(name: "HelveticaNeue-Bold", size: 16.0) else {
            return
        }

        let attributedString = NSMutableAttributedString(string: "Temporary ID = \"IaN9KiGGqA...\"\n\nPhone Model = \"Android\"\n\nSignal Strengh = \"-61\"\n\nTransmit Power = \"12\"", attributes: [
            .font: normalFont
        ])

        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: 12))
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 32, length: 11))
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 57, length: 14))
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 81, length: 14))
        payloadExampleLabel.attributedText = attributedString
        payloadExampleLabel.textColor = UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00)

        if let resizedImage = cardImageView.image?.resizeTopAlignedToFill(newWidth: self.frame.width) {
            cardImageView.image = resizedImage
        }
    }
}
