import UIKit

class UploadDataToNoteViewController: UIViewController {
    @IBOutlet private var uploadDataHeader: UILabel!
    @IBOutlet private var uploadDataSubheader: UILabel!
    @IBOutlet private var uploadDataButton: UIButton!
    @IBOutlet private var uploadDataButtonMHR: UIButton!
    @IBOutlet private var returnHomeButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.borderWidth = 0
        navigationController?.navigationBar.borderColor = .white
        navigationController?.navigationBar.shadowColor = .white
        navigationController?.navigationBar.barStyle = .blackTranslucent
        uploadDataHeader.setLabel(
            with: uploadDataHeaderString,
            using: .h2
        )
        uploadDataSubheader.setLabel(
            with: uploadDataSubheaderString,
            using: .body
        )
        uploadDataButton.setButton(
            with: ctButton,
            and: .arrow
        )
        returnHomeButton.title = NSLocalizedString(
            backButtonString,
            tableName: "",
            bundle: BKLocalizationManager.sharedInstance.currentBundle,
            value: BKLocalizationManager.sharedInstance.defaultStrings[backButtonString] ?? "",
            comment: ""
        )
        if UserDefaults.standard.bool(forKey: mhrKey) {
            uploadDataButtonMHR.isHidden = false
            uploadDataButtonMHR.setButton(
                with: mhrButton,
                and: .secondaryarrow
            )
            uploadDataButtonMHR.backgroundColor = mhrButtonColour
            uploadDataButtonMHR.borderWidth = 1
            uploadDataButtonMHR.borderColor = mhrBorderButtonColour
        } else {
            uploadDataButtonMHR.isHidden = true
        }
    }
    @IBAction private func returnToHomeScreen(_ sender: UIBarButtonItem) {
        HomeScreenEnum.showHomeScreen()
    }
}
