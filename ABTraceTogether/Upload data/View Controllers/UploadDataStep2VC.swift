//
//  UploadDataStep2VC.swift
//  OpenTrace

import Foundation
import UIKit
import CoreData
import IBMMobileFirstPlatformFoundation

class UploadDataStep2VC: UIViewController {
    @IBOutlet weak var disclaimerTextLbl: UILabel!
    @IBOutlet weak var codeInputView: CodeInputView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var uploadErrorMsgLbl: UILabel!
    @IBOutlet weak var uploadDataButton: UIButton!
    
    let uploadFailErrMsg = "Upload failed. Please try again later."
    let invalidPinErrMsg = "Invalid PIN"
    let NetworkDownMsg = "Network Down. Please try again later."
    var uploadToken = ""
    let UPLOAD_TOKEN_LENGTH = 6

    override func viewDidLoad() {
                _ = codeInputView.becomeFirstResponder()
                codeInputView.keyboardType = .default
                uploadDataButton.isEnabled = false
                codeInputView.delegate = self
                uploadDataButton.setButton(with: "Upload", and: .arrow)
                dismissKeyboardOnTap()
                NotificationCenter.default.addObserver(self.codeInputView, selector: #selector(self.tokenFieldDidChange), name: NSNotification.Name(rawValue: "Keyboard Notification"), object: nil)
        uploadErrorMsgLbl.isHidden = true
                getUploadToken()
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func tokenFieldDidChange() {
        if self.codeInputView.text.count == UPLOAD_TOKEN_LENGTH {
            self.uploadDataButton.isEnabled = true
            print(" \(self.uploadDataButton.isEnabled) is button state")
            let _ = self.codeInputView.resignFirstResponder()
        }
    }

    @IBAction func uploadDataBtnTapped(_ sender: UIButton) {
        
        sender.isEnabled = false
        self.uploadErrorMsgLbl.isHidden = true
        let code = codeInputView.text
         guard uploadToken == code.lowercased() else {
            self.uploadErrorMsgLbl.isHidden = false
            self.uploadErrorMsgLbl.text = self.invalidPinErrMsg
            sender.isEnabled = true
            return
        }
        
        self.uploadFile(token: code) { success in
            if success {
                self.performSegue(withIdentifier: "showSuccessVCSegue", sender: nil)
            } else {
                self.uploadErrorMsgLbl.isHidden = false
                print("upload data calls fails C")
                self.uploadErrorMsgLbl.text = self.uploadFailErrMsg
                sender.isEnabled = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func getUploadToken() {
        guard let userid = UserDefaults.standard.string(forKey: userDefaultsPinKey) else {
            Logger.logError(with: "getUploadToken, user id not found")
            showSystemError()
            return
        }
        
        let getUploadTokenURLString = "/adapters/getUploadTokenAdapter/getUploadToken"
        guard let getUploadTokenURL = URL(string: getUploadTokenURLString) else {
            Logger.logError(with: "Get upload token error. Error converting from getUploadTokenURLString to URL: \(getUploadTokenURLString)")
            showSystemError()
            return
        }
        
        guard let wlResourceRequest = WLResourceRequest(url: getUploadTokenURL, method:"GET") else {
            Logger.logError(with: "Get upload token error. Error converting to wlResourceRequest. \(getUploadTokenURL)")
            showSystemError()
            return
        }
        
        wlResourceRequest.queryParameters = ["userId" : userid]
        
        activityIndicator.startAnimating()
        wlResourceRequest.send(completionHandler: {[unowned self] (response, error) -> Void in
            self.activityIndicator.stopAnimating()
            if let error = error as NSError? {
                Logger.logError(with: "Get upload token error. Response: \(response ?? WLResponse.init()) Error: \(error.localizedDescription)")
                self.uploadDataButton.isEnabled = true
                self.activityIndicator.stopAnimating()
                self.uploadErrorMsgLbl.text = self.uploadFailErrMsg
                let code = error.code
                let message = error.localizedDescription
                Logger.DLog("Cloud Function Error - [\(String(describing: code))][\(message)]")
                Logger.DLog("Error - \(error)")
            }
            
            if let token = (response?.responseJSON as? [String: Any])?["token"] as? String {
                // need to store token for use
                self.uploadToken = token
            } else {
                Logger.logError(with: "Get upload token error. Token missing in response. Response: \(response ?? WLResponse.init())")
                self.uploadErrorMsgLbl.isHidden = false
                self.uploadErrorMsgLbl.text = self.invalidPinErrMsg
                self.uploadDataButton.isEnabled = true
                self.activityIndicator.stopAnimating()
            }
        })
        
    }

    func uploadFile(token: String, _ result: @escaping (Bool) -> Void) {
        let manufacturer = "Apple"
        let model = DeviceInfo.getModel().replacingOccurrences(of: " ", with: "")

        let date: Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let todayDate = dateFormatter.string(from: date)

        let file = "StreetPassRecord_\(manufacturer)_\(model)_\(todayDate).json"

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let recordsFetchRequest: NSFetchRequest<Encounter> = Encounter.fetchRequestForRecords()
        let eventsFetchRequest: NSFetchRequest<Encounter> = Encounter.fetchRequestForEvents()

        managedContext.perform { [unowned self] in
            guard let records = try? recordsFetchRequest.execute() else {
                Logger.DLog("Error fetching records")
                result(false)
                return
            }

            guard let events = try? eventsFetchRequest.execute() else {
                Logger.DLog("Error fetching events")
                result(false)
                return
            }

            let data = UploadFileData(token: token, records: records, events: events)

            let encoder = JSONEncoder()
            guard let json = try? encoder.encode(data) else {
                Logger.DLog("Error serializing data")
                result(false)
                return
            }

            guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                Logger.DLog("Error locating user documents directory")
                result(false)
                return
            }

            let fileURL = directory.appendingPathComponent(file)

            do {
                try json.write(to: fileURL, options: [])
            } catch {
                Logger.DLog("Error writing to file")
                result(false)
                return
            }
            
            guard let userid = UserDefaults.standard.string(forKey: userDefaultsPinKey) else {
                Logger.logError(with: "uploadFile, user id not found")
                self.showSystemError()
                return
            }
            
            let encountersUploadURLString = "/adapters/uploadData/uploadData"
            guard let encountersUploadURL = URL(string: encountersUploadURLString) else {
                Logger.logError(with: "Get upload data error. Error converting from getUploadTokenURLString to URL: \(encountersUploadURLString)")
                self.showSystemError()
                return
            }
            
            guard let wlResourceRequest = WLResourceRequest(url: encountersUploadURL, method:"POST") else {
                Logger.logError(with: "Get upload data error. Error converting to wlResourceRequest. \(encountersUploadURL)")
                self.showSystemError()
                return
            }
            
            wlResourceRequest.queryParameters = ["userId" : userid]
            wlResourceRequest.setHeaderValue("application/json" as NSObject, forName: "content-type")
            self.activityIndicator.startAnimating()
            wlResourceRequest.send(with: json) { (response, error) in
                self.activityIndicator.stopAnimating()
                guard error == nil else {
                    Logger.logError(with: "Get upload data error. Response: \(response ?? WLResponse.init()) Error: \(error?.localizedDescription ?? "Error is nil")")
                    if let error = error as NSError? {
                        let code = error.code
                        let message = error.localizedDescription
                        Logger.DLog("Cloud function error. Code: \(String(describing: code)), Message: \(message)")
                        result(false)
                        return
                        
                    } else {
                        Logger.DLog("Cloud function error, unable to convert error to NSError.\(error!)")
                    }
                    result(false)
                    return
                }
                result(true)
            }
        }
    }
}

//MARK: - TextField delegates
extension UploadDataStep2VC: UITextFieldDelegate {
    //  limit text field input to 6 characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let maxLength = UPLOAD_TOKEN_LENGTH
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        //return newString.length <= maxLength
        
        if textField.text?.count ?? 0 == (maxLength - 1) {
            self.uploadDataButton.isEnabled = true
            textField.resignFirstResponder()
        }
        
        return newString.length <= maxLength
        
    }
}

extension UploadDataStep2VC: CodeInputViewDelegate {
    func codeDidChange(codeInputView: CodeInputView) {
        
    }
    
    func codeDidFinish(codeInputView: CodeInputView) {
        self.uploadDataButton.isEnabled = true
        self.uploadDataButton.backgroundColor = UIColor(red: 0, green: 0.439, blue: 0.769, alpha: 1)
    }
}

//MARK: - Utilities
extension UploadDataStep2VC {
    func showAlert(with error: Error) {
        let errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: "Default action"), style: .default, handler: { _ in
            NSLog("Unable to verify phone number")
        }))
        self.present(errorAlert, animated: true)
    }
    
    func showSystemError() {
        let userInfo: [String : Any] = [
            NSLocalizedDescriptionKey : NSLocalizedString("System Error", value: "Unexpected error occured, retry", comment: "")
        ]
        
        let error = NSError(domain: "System Error", code: 1, userInfo: userInfo)
        self.showAlert(with: error)
    }
}
