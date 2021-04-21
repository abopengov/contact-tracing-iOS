import Foundation
import UIKit

class UploadDataStep1VC: UIViewController {
    @IBOutlet private var uploadDataHeader: UILabel!
    @IBOutlet private var uploadDataStep1: UILabel!
    @IBOutlet private var verificationCode: UILabel!
    @IBOutlet private var nextBtn: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    var covidTestData: CovidTestData?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? UploadDataStep2VC {
            destinationVC.covidTestData = covidTestData
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        uploadDataHeader.setLabel(
            with: uploadStep1Header,
            using: .h2
        )
        uploadDataStep1.setLabel(
            with: uploadStep1Subheader,
            using: .body
        )
        nextBtn.setButton(
            with: uploadStep1Button,
            and: .arrow
        )
        if let savedVerificationCode = UserDefaults.standard.string(forKey: userDefaultsPinKey) {
            verificationCode.text = savedVerificationCode
            verificationCode.setCharacterSpacing(characterSpacing: 22)
        } else {
            fetchedHandshakePin()
        }
    }

    private func fetchedHandshakePin() {
        nextBtn.isEnabled = false
    }
}
