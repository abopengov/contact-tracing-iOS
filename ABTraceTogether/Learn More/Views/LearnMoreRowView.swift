import UIKit

class LearnMoreRowView: UIView {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var label: UILabel!

    var text: String {
        get {
            label?.text ?? ""
        }
        set {
            label.setLabel(with: newValue, using: .blueText)
        }
    }

    var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
