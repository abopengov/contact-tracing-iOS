import UIKit

class LearnMoreThreeItemCardView: UIView {
    @IBOutlet private var cardImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var item1ImageView: UIImageView!
    @IBOutlet private var item1Label: UILabel!
    @IBOutlet private var item2ImageView: UIImageView!
    @IBOutlet private var item2Label: UILabel!
    @IBOutlet private var item3ImageView: UIImageView!
    @IBOutlet private  var item3Label: UILabel!

    var image: UIImage? {
        get { cardImageView.image }
        set { cardImageView.image = newValue }
    }

    var titleText: String {
        get {
            titleLabel?.text ?? ""
        }
        set {
            titleLabel.setLabel(with: newValue, using: .grayTitleMediumText)
        }
    }

    var item1Text: String {
        get {
            item1Label?.text ?? ""
        }
        set {
            item1Label.setLabel(with: newValue, using: .grayDescriptionText)
        }
    }

    var item1Image: UIImage? {
        get { item1ImageView.image }
        set { item1ImageView.image = newValue }
    }

    var item2Text: String {
        get {
            item2Label?.text ?? ""
        }
        set {
            item2Label.setLabel(with: newValue, using: .grayDescriptionText)
        }
    }

    var item2Image: UIImage? {
        get { item2ImageView.image }
        set { item2ImageView.image = newValue }
    }
    
    var item3Text: String {
        get {
            item3Label?.text ?? ""
        }
        set {
            item3Label.setLabel(with: newValue, using: .grayDescriptionText)
        }
    }

    var item3Image: UIImage? {
        get { item3ImageView.image }
        set { item3ImageView.image = newValue }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let resizedImage = cardImageView.image?.resizeTopAlignedToFill(newWidth: self.frame.width) {
            cardImageView.image = resizedImage
        }
    }
}
