import CoreData
import Foundation
import IBMMobileFirstPlatformFoundation
import UIKit

let ENCOUNTER_PARTITION_SIZE = 50_000

class UploadDataStep2VC: UIViewController {
    @IBOutlet private var codeInputView: CodeInputView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var uploadErrorMsgLbl: UILabel!
    @IBOutlet private var uploadDataButton: UIButton!
    @IBOutlet private var uploadDataHeader: UILabel!
    @IBOutlet  private var uploadDataSubHeader: UILabel!

    var covidTestData: CovidTestData?

    let UPLOAD_TOKEN_LENGTH = 6

    override func viewDidLoad() {
        super.viewDidLoad()
        uploadDataHeader.setLabel(
            with: uploadStep2Header,
            using: .h2
        )
        uploadDataSubHeader.setLabel(
            with: uploadStep2SubHeader,
            using: .body
        )
        _ = codeInputView.becomeFirstResponder()
        codeInputView.keyboardType = .default
        uploadDataButton.isEnabled = false
        codeInputView.delegate = self
        uploadDataButton.setButton(
            with: uploadDataButtonString,
            and: .arrow
        )
        dismissKeyboardOnTap()

        NotificationCenter.default.addObserver(
            codeInputView as Any,
            selector: #selector(self.tokenFieldDidChange),
            name: NSNotification.Name(rawValue: "Keyboard Notification"),
            object: nil
        )

        uploadErrorMsgLbl.isHidden = true
    }

    @IBAction private func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @objc
    func tokenFieldDidChange() {
        if self.codeInputView.text.count == UPLOAD_TOKEN_LENGTH {
            print(" \(self.uploadDataButton.isEnabled) is button state")
            _ = self.codeInputView.resignFirstResponder()
        }
    }
    @IBAction private func uploadDataBtnTapped(_ sender: UIButton) {
        sender.isEnabled = false
        let code = codeInputView.text
        self.uploadFile(token: code) { success in
            if success {
                self.performSegue(withIdentifier: "showSuccessVCSegue", sender: nil)
            } else {
                self.uploadErrorMsgLbl.isHidden = false
                self.uploadErrorMsgLbl.text = NSLocalizedString(
                    uploadFailMessage,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[uploadFailMessage] ?? "",
                    comment: ""
                )
                sender.isEnabled = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    func getUploadToken(completion:@escaping (String?) -> Void) {
        guard let userid = UserDefaults.standard.string(forKey: userDefaultsPinKey) else {
            Logger.logError(with: "getUploadToken, user id not found")
            showSystemError()
            completion(nil)
            return
        }

        let getUploadTokenURLString = "/adapters/getUploadTokenAdapter/getUploadToken"
        guard let getUploadTokenURL = URL(string: getUploadTokenURLString) else {
            Logger.logError(with: "Get upload token error. Error converting from getUploadTokenURLString to URL: \(getUploadTokenURLString)")
            showSystemError()
            completion(nil)
            return
        }

        guard let wlResourceRequest = WLResourceRequest(url: getUploadTokenURL, method: "GET") else {
            Logger.logError(with: "Get upload token error. Error converting to wlResourceRequest. \(getUploadTokenURL)")
            showSystemError()
            completion(nil)
            return
        }
        wlResourceRequest.queryParameters = ["userId": userid]
        // swiftlint:disable:next trailing_closure
        wlResourceRequest.send(completionHandler: { response, error -> Void in
            if let error = error as NSError? {
                Logger.logError(with: "Get upload token error. Response: \(response ?? WLResponse()) Error: \(error.localizedDescription)")
                //                self.uploadErrorMsgLbl.text = self.uploadFailErrMsg
                //                let code = error.code
                //                let message = error.localizedDescription
                //                Logger.DLog("Cloud Function Error - [\(String(describing: code))][\(message)]")
                Logger.DLog("Error - \(error)")
                completion(nil)
            }

            if let token = (response?.responseJSON as? [String: Any])?["token"] as? String {
                // need to store token for use
                completion(token)
            } else {
                Logger.logError(with: "Get upload token error. Token missing in response. Response: \(response ?? WLResponse())")
                completion(nil)
            }
        })
    }

    func uploadFile(token: String, _ result: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let eventsFetchRequest: NSFetchRequest<Encounter> = Encounter.fetchRequestForEvents()

        self.activityIndicator.startAnimating()

        managedContext.perform { [weak self] in
            guard let events = try? eventsFetchRequest.execute() else {
                Logger.DLog("Error fetching events")
                result(false)
                return
            }

            self?.uploadEncounterData(managedContext: managedContext, token: token, events: events, offset: 0) { success in
                self?.activityIndicator.stopAnimating()
                result(success)
            }
        }
    }

    private func uploadEncounterData(managedContext: NSManagedObjectContext, token: String, events: [Encounter], offset: Int, _ result: @escaping (Bool) -> Void) {
        let recordsFetchRequest: NSFetchRequest<Encounter> = Encounter.fetchRequestForRecords()
        recordsFetchRequest.fetchLimit = ENCOUNTER_PARTITION_SIZE
        recordsFetchRequest.fetchOffset = offset

        guard let covidTestData = self.covidTestData else {
            Logger.DLog("Error missing Covid test data")
            result(false)
            return
        }

        managedContext.perform { [weak self] in
            guard let records = try? recordsFetchRequest.execute() else {
                Logger.DLog("Error fetching records")
                result(false)
                return
            }

            if records.isEmpty && offset != 0 {
                result(true)
                return
            }

            self?.uploadJson(token: token, covidTestData: covidTestData, events: events, records: records) { success in
                if success {
                    if records.count < ENCOUNTER_PARTITION_SIZE {
                        result(true)
                    } else {
                        self?.uploadEncounterData(managedContext: managedContext, token: token, events: events, offset: offset + ENCOUNTER_PARTITION_SIZE, result)
                    }
                } else {
                    result(false)
                }
            }
        }
    }

    private func uploadJson(token: String, covidTestData: CovidTestData, events: [Encounter], records: [Encounter], _ result: @escaping (Bool) -> Void) {
        let data = UploadFileData(covidTestData: covidTestData, token: token, records: records, events: events)
        let encoder = JSONEncoder()
        guard let json = try? encoder.encode(data) else {
            Logger.DLog("Error serializing data")
            result(false)
            return
        }

        guard let userid = UserDefaults.standard.string(forKey: userDefaultsPinKey) else {
            Logger.logError(with: "uploadFile, user id not found")
            self.showSystemError()
            result(false)
            return
        }

        let encountersUploadURLString = "/adapters/uploadData/uploadData"
        guard let encountersUploadURL = URL(string: encountersUploadURLString) else {
            Logger.logError(with: "Get upload data error. Error converting from getUploadTokenURLString to URL: \(encountersUploadURLString)")
            self.showSystemError()
            result(false)
            return
        }

        guard let wlResourceRequest = WLResourceRequest(url: encountersUploadURL, method: "POST", timeout: 0) else {
            Logger.logError(with: "Get upload data error. Error converting to wlResourceRequest. \(encountersUploadURL)")
            self.showSystemError()
            result(false)
            return
        }

        wlResourceRequest.queryParameters = ["userId": userid]
        wlResourceRequest.setHeaderValue("application/json" as NSObject, forName: "content-type")
        wlResourceRequest.send(with: json) { response, error in
            guard error == nil else {
                Logger.logError(with: "Get upload data error. Response: \(response ?? WLResponse()) Error: \(error?.localizedDescription ?? "Error is nil")")
                guard let error = error as NSError? else {
                    Logger.DLog("Cloud function error, unable to convert error to NSError.")
                    result(false)
                    return
                }
                let code = error.code
                let message = error.localizedDescription
                Logger.DLog("Cloud function error. Code: \(String(describing: code)), Message: \(message)")

                result(false)
                return
            }
            result(true)
        }
    }
}

// MARK: - TextField delegates
extension UploadDataStep2VC: UITextFieldDelegate {
    //  limit text field input to 6 characters
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let maxLength = UPLOAD_TOKEN_LENGTH
        guard let currentString = textField.text as NSString? else {
            return false
        }
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString

        if textField.text?.count ?? 0 == (maxLength - 1) {
            textField.resignFirstResponder()
        }

        return newString.length <= maxLength
    }
}

extension UploadDataStep2VC: CodeInputViewDelegate {
    func codeDidChange(codeInputView: CodeInputView) {
        uploadDataButton.isEnabled = false
        self.uploadDataButton.backgroundColor = UIColor(red: 0.646, green: 0.646, blue: 0.646, alpha: 1)
    }
    func codeDidFinish(codeInputView: CodeInputView) {
        activityIndicator.startAnimating()
        getUploadToken { token in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                let code = codeInputView.text
                guard let token = token,
                    code.lowercased() == token else {
                    self.uploadErrorMsgLbl.isHidden = false
                    self.uploadErrorMsgLbl.text = NSLocalizedString(
                        uploadInvalidPin,
                        tableName: "",
                        bundle: BKLocalizationManager.sharedInstance.currentBundle,
                        value: BKLocalizationManager.sharedInstance.defaultStrings[uploadInvalidPin] ?? "",
                        comment: ""
                    )
                    return
                }
                self.uploadErrorMsgLbl.isHidden = true
                self.uploadDataButton.isEnabled = true
                self.uploadDataButton.backgroundColor = UIColor(red: 0, green: 0.439, blue: 0.769, alpha: 1)
            }
        }
    }
}

// MARK: - Utilities
extension UploadDataStep2VC {
    func showAlert(with error: Error) {
        let errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        errorAlert.addAction(
            // swiftlint:disable:next trailing_closure
            UIAlertAction(
                title: uploadvc2Done,
                style: .default,
                handler: { _ in
                    NSLog("Unable to verify phone number")
                }
            )
        )
        self.present(
            errorAlert,
            animated: true
        )
    }

    func showSystemError() {
        let userInfo: [String: Any] = [
            NSLocalizedDescriptionKey: systemErrorMessage
        ]

        let error = NSError(
            domain: NSLocalizedString(
                NSLocalizedString(
                    generalErrorTitleString,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[generalErrorTitleString] ?? "",
                    comment: ""
                ),
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[generalErrorTitleString] ?? "",
                comment: ""
            ),
            code: 1,
            userInfo: userInfo
        )
        self.showAlert(with: error)
    }
}
