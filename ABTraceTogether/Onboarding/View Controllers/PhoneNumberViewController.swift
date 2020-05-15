//
//  PhoneNumberViewController.swift
//  OpenTrace

import UIKit
import IBMMobileFirstPlatformFoundation

class PhoneNumberViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var phoneNumberHeaderLabel: UILabel!
    @IBOutlet weak var phoneNumberDescriptionLabel: UILabel!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var getOTPButton: UIButton!
    let MIN_PHONE_LENGTH = 8
    let PHONE_NUMBER_LENGTH = 15
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImage = UIImage(named: "BackArrow")
        backButton.setImage(backImage, for: .normal)
        backButton.setTitle(" Back", for: .normal)
        stepsLabel.setLabel(with: "Step 1 of 3", using: .stepText)
        phoneNumberHeaderLabel.setLabel(with: "Enter your mobile number", using: .h2)
        phoneNumberDescriptionLabel.setLabel(with: "You’ll receive a text message with a six-digit code. \n\nOnce you get the text, please enter the code on the next screen.",
                                             using: .body)
        phoneNumberField.placeholder = "(780)-456-7890"
        getOTPButton.setButton(with: "Next", and: .arrow)
        self.phoneNumberField.addTarget(self, action: #selector(self.phoneNumberFieldDidChange), for: UIControl.Event.editingChanged)
        phoneNumberField.delegate = self
        
        if let appVersion = UIApplication.appVersion {
            versionLabel.setLabel(with: "Version: \(appVersion)",
                                 using: .body)
            versionLabel.isHidden = false
        } else {
            versionLabel.isHidden = true
        }

        dismissKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.phoneNumberField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        phoneNumberFieldDidChange()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showPrivacyScreenFromPhoneSegue", sender: self)
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        getOTPButton.isEnabled = false
        verifyPhoneNumberAndProceed(self.phoneNumberField.text ?? "")
    }
    
    @objc
    func phoneNumberFieldDidChange() {
        self.getOTPButton.isEnabled = self.phoneNumberField.text?.count ?? 0 >= MIN_PHONE_LENGTH
        if self.phoneNumberField.text?.count == PHONE_NUMBER_LENGTH {
            self.phoneNumberField.resignFirstResponder()
        }
        updateButtonColor()
    }
}

//MARK: - TextField delegates
extension PhoneNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var fullString = textField.text ?? ""
        fullString.append(string)
        if range.length == 1 {
            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
        } else {
            textField.text = format(phoneNumber: fullString)
        }
        return false
    }
}


//MARK: - helpers
extension PhoneNumberViewController {
    func updateButtonColor() {
        if getOTPButton.isEnabled {
            getOTPButton.backgroundColor = UIColor(red: 0, green: 0.439, blue: 0.769, alpha: 1)
        } else {
            getOTPButton.backgroundColor = UIColor(red: 0.646, green: 0.646, blue: 0.646, alpha: 1)
        }
    }
    
    func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
            
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }
        
        if phoneNumber.count == 14 && !shouldRemoveLastDigit {
            getOTPButton.isEnabled = true
            self.phoneNumberField.resignFirstResponder()
        } else {
            getOTPButton.isEnabled = false
        }
        updateButtonColor()
        
        return number
    }
    
    func showAlert(with error: Error) {
        let errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: "Default action"), style: .default, handler: { _ in
            NSLog("Unable to verify phone number")
            self.phoneNumberFieldDidChange()
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
    
    func verifyPhoneNumberAndProceed(_ mobileNumber: String) {
        activityIndicator.startAnimating()
        let regex = try! NSRegularExpression(pattern: "[()\\-\\s]",
                                             options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, mobileNumber.count)
        let parsedMobileNumber = regex.stringByReplacingMatches(in: mobileNumber,
                                                                options: [],
                                                                range: range,
                                                                withTemplate: "")
        
        UserDefaults.standard.set(parsedMobileNumber, forKey: "mobileNumber")
        
        let registerPhoneURLString = "/adapters/smsOtpService/phone/register/"
        guard let registerPhoneUrl = URL(string: registerPhoneURLString + parsedMobileNumber) else {
            Logger.logError(with: "Register phone number error. Converting url request from: \(registerPhoneURLString)")
            showSystemError()
            return
        }
        
        guard let wlResourceRequest = WLResourceRequest(url: registerPhoneUrl, method:"POST") else {
            Logger.logError(with: "Register phone number error. Generating url request from: \(registerPhoneUrl)")
            showSystemError()
            return
        }
        
        wlResourceRequest.send(completionHandler: { [weak self] (response, error) -> Void in
            self?.activityIndicator.stopAnimating()
            if let error = error as NSError? {
                if error.code < -1000 {
                    let userInfo: [String : Any] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("Connection Error", value: "Cannot connect to Network, retry", comment: "")
                    ]
                    
                    let error = NSError(domain: "System Error", code: 1, userInfo: userInfo)
                    self?.showAlert(with: error)
                    return
                } else {
                    Logger.logError(with: "Register phone number error. Response: \(response ?? WLResponse.init()) Error: \(error.localizedDescription)")
                    Logger.DLog("Phone number verification error: \(error.localizedDescription)")
                    self?.showAlert(with: error)
                    return
                }
            } else if let response = response,
                response.status != 200 {
                Logger.DLog("Phone number verification error: response code is \(response.status)")
                Logger.logError(with: "Register phone number error. Response: \(response)")
                self?.showSystemError()
                return
            }
            UserDefaults.standard.set(mobileNumber, forKey: "mobileNumber")
            
            self?.startVericationProcess()
        })
    }
}

extension PhoneNumberViewController {
    
    func startVericationProcess() {
        let registerPhoneURLString = "/adapters/smsOtpService/phone/verifySmsOTP"
        guard let registerPhoneUrl = URL(string: registerPhoneURLString) else {
            Logger.logError(with: "Verfify OTP error. Converting url request from: \(registerPhoneURLString)")
            showSystemError()
            return
        }
        
        guard let wlResourceRequest = WLResourceRequest(url: registerPhoneUrl, method:"POST") else {
            Logger.logError(with: "Verfify OTP error. Generating url request from: \(registerPhoneUrl)")
            showSystemError()
            return
        }
        
        wlResourceRequest.send(completionHandler: { [weak self] (response, error) -> Void in
            self?.activityIndicator.stopAnimating()
            if let error = error as NSError? {
                Logger.logError(with: "Verfify OTP error. Response: \(response ?? WLResponse.init()) Error: \(error.localizedDescription)")
                
                if error.code == -999 {
                    if let phoneNumber = UserDefaults.standard.string(forKey: "mobileNumber"),
                        phoneNumber.count > 8 {
                        self?.startVericationProcess()
                        return
                    }
                    self?.phoneNumberFieldDidChange()
                    return
                } else if error.code < -1000 {
                    let userInfo: [String : Any] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("Connection Error", value: "Cannot connect to Network, retry", comment: "")
                    ]
                    
                    let error = NSError(domain: "System Error", code: 1, userInfo: userInfo)
                    self?.showAlert(with: error)
                    return
                } else {
                    Logger.logError(with: "Verfify OTP error. Response: \(response ?? WLResponse.init()) Error: \(error.localizedDescription)")
                }
                
                Logger.DLog("Phone number verification error: \(error.localizedDescription)")
                
                let userInfo: [String : Any] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Connection Error", value: "The one time pin you entered was incorrect, please try again.", comment: "")
                ]
                
                let error = NSError(domain: "System Error", code: 1, userInfo: userInfo)
                self?.showAlert(with: error)
                return
            } else if let response = response,
                response.status != 200 {
                Logger.DLog("Phone number verification error: response code is \(response.status)")
                Logger.logError(with: "Verfify OTP error, reponse is not 200. Response: \(response) Error: \(error?.localizedDescription ?? "error is nil")")
                self?.showSystemError()
                return
            }
            
            if let userid = response?.responseJSON["userId"] {
                UserDefaults.standard.set(userid, forKey: userDefaultsPinKey)
            } else {
                Logger.logError(with: "Verfify OTP error, reponse does not have userid. Response: \(response ?? WLResponse.init())")
                self?.showSystemError()
                return
            }
            self?.performSegue(withIdentifier: "showPermissionFromPhoneSegue", sender: self)
        })
    }
    
    
    internal static func codeDialog (title: String, message: String, isCode : Bool, completion: @escaping OTPCompletion) {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "otp") as! OTPViewController
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.oTPCompletion = completion
        UIApplication.shared.delegate?.window!!.rootViewController!.present(viewController, animated: true, completion: nil)
    }
}
