import UIKit

class LearnMoreCardView: UIView {
    @IBOutlet private var cardImageView: UIImageView!
    @IBOutlet private var label: UILabel!

    var text: String {
        get {
            label?.text ?? ""
        }
        set {
            label.setLabel(with: newValue, using: .grayDescriptionCenteredText)
        }
    }

    var image: UIImage? {
        get { cardImageView.image }
        set { cardImageView.image = newValue }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let resizedImage = cardImageView.image?.resizeTopAlignedToFill(newWidth: self.frame.width) {
            cardImageView.image = resizedImage
        }
    }
}
