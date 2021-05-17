import Foundation
import UIKit

class UploadDataView: UIView {
    @IBOutlet private var uploadIcon: UIImageView!
    @IBOutlet private var uploadLabel: UILabel!
    @IBOutlet private var uploadDescriptionLabel: UILabel!
    @IBOutlet private var topView: UIView!
    @IBOutlet private var versionLabel: UILabel!

    weak var homeViewControllerDelegate: HomeViewControllerDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        topView.layer.shadowRadius = 1
        topView.layer.shadowOpacity = 0.25
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)

        uploadLabel.setLabel(with: homeUploadData, using: .grayTitleText)
        uploadDescriptionLabel.setLabel(with: homeUploadDataContent, using: .grayItalicText)

        let versionString = "\(appVersionLabel.localize()) \(UIApplication.appVersion ?? "") \(HomeScreenEnum.getVersionIdentifierForEnvironment())"

        versionLabel.setLabel(with: versionString, using: .grayCenterText, localize: false)

        let tapIconGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadPressed(_:)))
        self.uploadIcon.addGestureRecognizer(tapIconGestureRecognizer)

        let tapUploadGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadPressed(_:)))
        self.uploadLabel.addGestureRecognizer(tapUploadGestureRecognizer)
    }

    @objc
    private func uploadPressed(_ sender: Any) {
        homeViewControllerDelegate?.connectToUploadFlow()
    }
}
