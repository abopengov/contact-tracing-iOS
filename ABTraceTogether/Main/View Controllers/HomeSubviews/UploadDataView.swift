import Foundation
import UIKit

class UploadDataView: UIView {
    @IBOutlet private var uploadDataHeaderLabel: UILabel!
    @IBOutlet private var uploadDataCardView: UIView!
    @IBOutlet private var uploadDataMessageLabel: UILabel!
    @IBOutlet private var uploadDataButton: UIButton!
    weak var homeViewControllerDelegate: HomeViewControllerDelegate?
    override func layoutSubviews() {
        super.layoutSubviews()
        HomeScreenEnum.setUpHomeBackgroundDesign(view: uploadDataCardView)
        uploadDataHeaderLabel.setLabel(
            with: uploadDataHomeHeader,
            using: .h2
        )
        uploadDataHeaderLabel.textAlignment = .left
        uploadDataMessageLabel.setLabel(
            with: uploadDataHomeMessage,
            using: .body
        )
        uploadDataMessageLabel.textAlignment = .left
        uploadDataButton.setButton(
            with: uploadDataHomeButton,
            and: .arrow
        )
    }
    @IBAction private func startUploadFlow(_ sender: UIButton) {
        homeViewControllerDelegate?.connectToUploadFlow()
    }
}
