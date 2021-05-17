import UIKit

class LearnMoreRequestCardView: UIView {
    @IBOutlet private var topIconView: UIImageView!
    @IBOutlet private var willTitleLabel: UILabel!
    @IBOutlet private var willItem1ImageView: UIImageView!
    @IBOutlet private var willItem1Label: UILabel!
    @IBOutlet private var willItem2ImageView: UIImageView!
    @IBOutlet private var willItem2Label: UILabel!
    @IBOutlet private var willItem2TopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet private var willNotTitleLabel: UILabel!
    @IBOutlet private var willNotItem1ImageView: UIImageView!
    @IBOutlet private var willNotItem1Label: UILabel!
    @IBOutlet private var willNotItem2TopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet private var willNotItem2ImageView: UIImageView!
    @IBOutlet private var willNotItem2Label: UILabel!

    var topIcon: UIImage? {
        get { topIconView.image }
        set {
            topIconView.image = newValue
            topIconView.isHidden = false
        }
    }

    var willTitleText: String {
        get {
            willTitleLabel?.text ?? ""
        }
        set {
            willTitleLabel.setLabel(with: newValue, using: .grayTitleMediumText)
        }
    }

    var willItem1Image: UIImage? {
        get { willItem1ImageView.image }
        set {
            willItem1ImageView.image = newValue
        }
    }

    var willItem1Text: String {
        get {
            willItem1Label?.text ?? ""
        }
        set {
            willItem1Label.setLabel(with: newValue, using: .grayDescriptionText)
        }
    }

    var willItem2Image: UIImage? {
        get { willItem2ImageView.image }
        set {
            willItem2ImageView.image = newValue
            willItem2ImageView.isHidden = false
        }
    }

    var willItem2Text: String {
        get {
            willItem2Label?.text ?? ""
        }
        set {
            willItem2Label.setLabel(with: newValue, using: .grayDescriptionText)
            willItem2Label.isHidden = false
            willItem2ImageView.isHidden = false
            willItem2TopSpaceConstraint.constant = 24
        }
    }

    var willNotTitleText: String {
        get {
            willNotTitleLabel?.text ?? ""
        }
        set {
            willNotTitleLabel.setLabel(with: newValue, using: .grayTitleMediumText)
        }
    }

    var willNotItem1Image: UIImage? {
        get { willNotItem1ImageView.image }
        set {
            willNotItem1ImageView.image = newValue
        }
    }

    var willNotItem1Text: String {
        get {
            willNotItem1Label?.text ?? ""
        }
        set {
            willNotItem1Label.setLabel(with: newValue, using: .grayDescriptionText)
        }
    }

    var willNotItem2Image: UIImage? {
        get { willNotItem2ImageView.image }
        set {
            willNotItem2ImageView.image = newValue
            willNotItem2ImageView.isHidden = false
        }
    }

    var willNotItem2Text: String {
        get {
            willNotItem2Label?.text ?? ""
        }
        set {
            willNotItem2Label.setLabel(with: newValue, using: .grayDescriptionText)
            willNotItem2Label.isHidden = false
            willNotItem2ImageView.isHidden = false
            willNotItem2TopSpaceConstraint.constant = 24
        }
    }
}
