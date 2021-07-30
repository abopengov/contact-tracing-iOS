import UIKit

class UploadDataToNoteViewController: UIViewController {
    @IBOutlet private var uploadDataHeader: UILabel!
    @IBOutlet private var uploadDataSubheader: UILabel!
    @IBOutlet private var uploadDataButton: UIButton!
    @IBOutlet private var uploadDataButtonMHR: UIButton!
    @IBOutlet private var returnHomeButton: UIBarButtonItem!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ctFlowSegue" {
            if let destinationVC = segue.destination as? TestDateViewController {
                destinationVC.contactTracerFlow = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.clipsToBounds = true

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
        returnHomeButton.title = backButtonString.localize()
        if UserDefaults.standard.bool(forKey: mhrKey) {
            uploadDataButtonMHR.isHidden = false
            uploadDataButtonMHR.setButton(
                with: mhrButton,
                and: .secondaryArrow,
                buttonStyle: .secondary
            )
        } else {
            uploadDataButtonMHR.isHidden = true
        }
    }

    @IBAction private func ctButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ctFlowSegue", sender: self)
    }

    @IBAction private func mhrButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "mhrFlowSegue", sender: self)
    }

    @IBAction private func returnToHomeScreen(_ sender: UIBarButtonItem) {
        HomeScreenEnum.showHomeScreen()
    }
}
