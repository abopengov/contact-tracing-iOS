import Foundation
import UIKit

class UploadDataView: UIView {
    @IBOutlet private var uploadIcon: UIImageView!
    @IBOutlet private var uploadLabel: UILabel!
    @IBOutlet private var uploadDescriptionLabel: UILabel!
    @IBOutlet private var pauseIcon: UIImageView!
    @IBOutlet private var pauseLabel: UILabel!
    @IBOutlet private var topView: UIView!
    @IBOutlet private var versionLabel: UILabel!

    weak var homeViewControllerDelegate: HomeViewControllerDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        topView.layer.shadowRadius = 1
        topView.layer.shadowOpacity = 0.25
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)

        uploadLabel.setLabel(with: homeUploadData, using: .graySubtitleText)
        uploadLabel.underline()
        uploadDescriptionLabel.setLabel(with: homeUploadDataContent, using: .grayItalicText)

        pauseLabel.setLabel(with: homePauseSetSchedule, using: .graySubtitleText)
        pauseLabel.underline()

        let versionString = "\(appVersionLabel.localize()) \(UIApplication.appVersion ?? "") \(HomeScreenEnum.getVersionIdentifierForEnvironment())"

        versionLabel.setLabel(with: versionString, using: .grayCenterText, localize: false)

        let tapUploadIconGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadPressed(_:)))
        self.uploadIcon.addGestureRecognizer(tapUploadIconGestureRecognizer)

        let tapUploadGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadPressed(_:)))
        self.uploadLabel.addGestureRecognizer(tapUploadGestureRecognizer)

        let tapPauseIconGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pausePressed(_:)))
        self.pauseIcon.addGestureRecognizer(tapPauseIconGestureRecognizer)

        let tapPauseGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pausePressed(_:)))
        self.pauseLabel.addGestureRecognizer(tapPauseGestureRecognizer)
    }

    @objc
    private func uploadPressed(_ sender: Any) {
        homeViewControllerDelegate?.openUploadFlow()
    }

    @objc
    private func pausePressed(_ sender: Any) {
        homeViewControllerDelegate?.openPauseDetection()
    }
}
