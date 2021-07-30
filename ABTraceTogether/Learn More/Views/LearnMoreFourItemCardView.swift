import UIKit

class LearnMoreFourItemCardView: UIView {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var item1ImageView: UIImageView!
    @IBOutlet private var item1Label: UILabelWithLink!
    @IBOutlet private var item2ImageView: UIImageView!
    @IBOutlet private var item2Label: UILabelWithLink!
    @IBOutlet private var item3ImageView: UIImageView!
    @IBOutlet private var item3Label: UILabelWithLink!
    @IBOutlet private var item4ImageView: UIImageView!
    @IBOutlet private var item4Label: UILabelWithLink!

    weak var delegate: LearnMoreFourItemCardViewDelegate?

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

    var item4Text: String {
        get {
            item4Label?.text ?? ""
        }
        set {
            item4Label.setLabel(with: newValue, using: .grayDescriptionText)
        }
    }

    var item4Image: UIImage? {
        get { item4ImageView.image }
        set { item4ImageView.image = newValue }
    }

    func addLinkToItem(itemIndex: Int, textToFind: String, linkURL: String) {
        if let itemLabel = getItemLabelForIndex(itemIndex: itemIndex) {
            itemLabel.addLink(textToFind: textToFind, value: linkURL)
            itemLabel.delegate = self
        }
    }

    private func getItemLabelForIndex(itemIndex: Int) -> UILabelWithLink? {
        switch itemIndex {
        case 1:
            return item1Label

        case 2:
            return item2Label

        case 3:
            return item3Label

        case 4:
            return item4Label

        default:
            return nil
        }
    }
}

extension LearnMoreFourItemCardView: UILabelWithLinkDelegate {
    func linkClickedWithValue(_ value: Any) {
        self.delegate?.linkClickedWithValue(value)
    }
}

protocol LearnMoreFourItemCardViewDelegate: AnyObject {
    func linkClickedWithValue(_ value: Any)
}
