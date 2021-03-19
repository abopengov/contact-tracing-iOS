import UIKit

class ShareAppView: UIView {
    @IBOutlet private var shareAppView: UIView!
    @IBOutlet private var shareAppImageView: UIImageView!
    @IBOutlet private var shareAppHeaderLabel: UILabel!
    @IBOutlet private var shareAppDetailLabel: UILabel!

    weak var homeViewControllerDelegate: HomeViewControllerDelegate?
    override func layoutSubviews() {
        super.layoutSubviews()

        shareAppHeaderLabel.setLabel(
            with: homeShareAppHeader,
            using: .h2
        )
        shareAppDetailLabel.setLabel(
            with: homeShareAppMessage,
            using: .body
        )
        shareAppDetailLabel.textAlignment = .left
        HomeScreenEnum.setUpHomeBackgroundDesign(view: shareAppView)
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(
                self.onShareTapped(
                _:))
        )
        shareAppView.addGestureRecognizer(tap)
    }

    @objc
    func onShareTapped(_ sender: UITapGestureRecognizer) {
        let shareURL = URL(string: "https://shareUrl")
        let activityController = UIActivityViewController(
            activityItems: [
                NSLocalizedString(
                    shareText,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[shareText] ?? "",
                    comment: ""
                ),
                shareURL as Any
            ],
            applicationActivities: nil
        )
        activityController.popoverPresentationController?.sourceView = shareAppView
        homeViewControllerDelegate?.presentViewController(activityController)
    }
}
