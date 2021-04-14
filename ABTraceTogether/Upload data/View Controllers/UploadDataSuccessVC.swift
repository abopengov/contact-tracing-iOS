import Foundation
import UIKit

class UploadDataSuccessVC: UIViewController {
    @IBOutlet private var successMessageLabel: UILabel!
    @IBOutlet private var successProgressButton: UIButton!
    @IBOutlet private var successHeaderLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        successProgressButton.setButton(
            with: uploadSuccessButton,
            and: .check
        )
        successHeaderLabel.setLabel(
            with: uploadSuccessHeader,
            using: .h2
        )
        successMessageLabel.setLabel(
            with: uploadSuccessSubHeader,
            using: .body
        )
    }

    @IBAction private func doneBtnTapped(_ sender: UIButton) {
        // Bring user back to home tab
        HomeScreenEnum.showHomeScreen()
    }
}
