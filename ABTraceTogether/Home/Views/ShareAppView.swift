import Foundation
import UIKit

class ShareAppView: UIView {
    weak var homeViewControllerDelegate: HomeViewControllerDelegate?

    @IBOutlet private var shareAppLabel: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()

        shareAppLabel.setLabel(with: shareThisApp, using: .whiteBodyCopyTitleText)
        shareAppLabel.setLineSpacing(3, alignment: .center)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bannerPressed(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc
    private func bannerPressed(_ sender: Any) {
        let shareURL = URL(string: "https://example.com/share")
        let activityController = UIActivityViewController(
            activityItems: [
                shareText.localize(),
                shareURL as Any
            ],
            applicationActivities: nil
        )
        activityController.popoverPresentationController?.sourceView = self
        homeViewControllerDelegate?.presentViewController(activityController)
    }
}
