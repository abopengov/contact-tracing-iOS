import Foundation
import SafariServices
import UIKit

class GuidanceView: UIView {
    weak var homeViewControllerDelegate: HomeViewControllerDelegate?

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!

    var title: String {
        get {
            titleLabel?.text ?? ""
        }
        set {
            titleLabel.setLabel(with: newValue, using: .whiteTitleText)
        }
    }

    var text: String {
        get {
            textLabel?.text ?? ""
        }
        set {
            textLabel.setLabel(with: newValue, using: .whiteDescriptionText)
        }
    }

    var link: String = guidanceLink

    override func layoutSubviews() {
        super.layoutSubviews()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bannerPressed(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc
    private func bannerPressed(_ sender: Any) {
        if let url = URL(string: link) {
            let vc = SFSafariViewController(url: url)
            homeViewControllerDelegate?.presentViewController(vc)
        }
    }
}
