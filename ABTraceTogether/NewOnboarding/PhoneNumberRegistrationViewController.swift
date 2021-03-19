import IBMMobileFirstPlatformFoundation
import UIKit

class PhoneNumberRegistrationViewController: BaseViewController {
    let phoneNumberField = UITextField()
    let getOTPButton = UIButton()

    let MIN_PHONE_LENGTH = 8
    let PHONE_NUMBER_LENGTH = 15

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false

        generatePrivacyViews(in: contentView)
        dismissKeyboardOnTap()

        getOTPButton.isEnabled = true
        phoneNumberField.delegate = self

        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.borderColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowColor = .clear
        navigationController?.navigationBar.borderWidth = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.phoneNumberField.becomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        phoneNumberFieldDidChange()
    }

    @objc
    func phoneNumberFieldDidChange() {
        self.getOTPButton.isEnabled = self.phoneNumberField.text?.count ?? 0 >= MIN_PHONE_LENGTH

        if self.phoneNumberField.text?.count == PHONE_NUMBER_LENGTH {
            self.phoneNumberField.resignFirstResponder()
        }
        updateButtonColor()
    }

    @objc
    func getOTPButton(_ sender: Any) {
        getOTPButton.isEnabled = false
        verifyPhoneNumberAndProceed(with: self.phoneNumberField.text ?? "")
    }
}
// MARK: 
extension PhoneNumberRegistrationViewController {
    override func createButton(in parentView: UIView) {
        parentView.addSubview(getOTPButton)

        getOTPButton.translatesAutoresizingMaskIntoConstraints = false
        getOTPButton.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        getOTPButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        getOTPButton.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -30).isActive = true
        getOTPButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        getOTPButton.setButton(with: phoneNumberRegistrationGetOTPButtonText, and: .arrow)
        getOTPButton.addTarget(self, action: #selector(getOTPButton(_:)), for: .touchUpInside)
    }
}

// MARK: - Content
extension PhoneNumberRegistrationViewController {
    private func generatePrivacyViews(in contentView: UIView) {
        clearSubViews(from: contentView)
        let layoutView = UIView()
        contentView.addSubview(layoutView)
        layoutView.translatesAutoresizingMaskIntoConstraints = false
        layoutView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        layoutView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        layoutView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        layoutView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        layoutView.addSubview(scrollView)

        let scrollViewContainer = UIStackView()

        scrollViewContainer.axis = .vertical
        scrollViewContainer.spacing = 10

        scrollViewContainer.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(scrollViewContainer)
        generateContent(in: scrollViewContainer)

        scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: layoutView.topAnchor, constant: -10).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    private func generateContent(in parentView: UIStackView) {
        let newView = UIView()
        parentView.addArrangedSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false

        let stepLabel = UILabel()
        newView.addSubview(stepLabel)
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        stepLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        stepLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        stepLabel.topAnchor.constraint(equalTo: newView.topAnchor, constant: 100).isActive = true
        stepLabel.setLabel(
            with: phoneNumberRegistrationStepNumberText,
            using: .stepText
        )
        let headerMessageLabel1 = UILabel()
        newView.addSubview(headerMessageLabel1)
        headerMessageLabel1.translatesAutoresizingMaskIntoConstraints = false
        headerMessageLabel1.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        headerMessageLabel1.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        headerMessageLabel1.topAnchor.constraint(equalTo: stepLabel.topAnchor, constant: 20).isActive = true
        headerMessageLabel1.setLabel(
            with: phoneNumberRegistrationHeaderText,
            using: .h2
        )
        newView.addSubview(phoneNumberField)
        phoneNumberField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberField.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        phoneNumberField.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        phoneNumberField.topAnchor.constraint(equalTo: headerMessageLabel1.bottomAnchor, constant: 20).isActive = true
        phoneNumberField.heightAnchor.constraint(equalToConstant: 46.0).isActive = true
        phoneNumberField.layer.borderColor = UIColor.gray.cgColor
        phoneNumberField.layer.borderWidth = 1.0
        phoneNumberField.placeholder = NSLocalizedString(
            phoneNumberRegistrationPhoneNumberPlaceHolderText,
            tableName: "",
            bundle: BKLocalizationManager.sharedInstance.currentBundle,
            value: BKLocalizationManager.sharedInstance.defaultStrings[phoneNumberRegistrationPhoneNumberPlaceHolderText] ?? "",
            comment: ""
        )
        phoneNumberField.keyboardType = .numberPad
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.phoneNumberField.frame.height))
        phoneNumberField.leftView = paddingView
        phoneNumberField.leftViewMode = UITextField.ViewMode.always

        let detailMessageLabel1 = UILabel()
        newView.addSubview(detailMessageLabel1)
        detailMessageLabel1.translatesAutoresizingMaskIntoConstraints = false
        detailMessageLabel1.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        detailMessageLabel1.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        detailMessageLabel1.topAnchor.constraint(equalTo: phoneNumberField.bottomAnchor, constant: 20).isActive = true

        detailMessageLabel1.setLabel(
            with: phoneNumberRegistrationSubHeaderText,
            using: .body
        )

        if let versionLabelString = versionLabelString {
            let versionLabel = UILabel()
            newView.addSubview(versionLabel)
            versionLabel.translatesAutoresizingMaskIntoConstraints = false
            versionLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
            versionLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
            versionLabel.topAnchor.constraint(equalTo: detailMessageLabel1.bottomAnchor, constant: 20).isActive = true

            versionLabel.setLabel(
                with: versionLabelString,
                using: .body
            )

            newView.bottomAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 20).isActive = true
        } else {
            newView.bottomAnchor.constraint(equalTo: detailMessageLabel1.bottomAnchor, constant: 20).isActive = true
        }
    }
}
// MARK: - TextField delegates
extension PhoneNumberRegistrationViewController: UITextFieldDelegate {
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
// MARK: - helpers
extension PhoneNumberRegistrationViewController {
    func updateButtonColor() {
        if getOTPButton.isEnabled {
            getOTPButton.backgroundColor = UIColor(red: 0, green: 0.439, blue: 0.769, alpha: 1)
        } else {
            getOTPButton.backgroundColor = UIColor(red: 0.646, green: 0.646, blue: 0.646, alpha: 1)
        }
    }

    func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else {
            return ""
        }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else {
            return ""
        }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")

        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count - 1)
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
            getOTPButton.isEnabled = true
        }
        updateButtonColor()
        return number
    }

    func showAlert(with error: Error) {
        let errorAlert = UIAlertController(
            title: NSLocalizedString(
                generalErrorTitleString,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[generalErrorTitleString] ?? "",
                comment: ""
            ),
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        errorAlert.addAction(
            // swiftlint:disable:next trailing_closure
            UIAlertAction(
                title: NSLocalizedString(
                    generalDoneString,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[generalDoneString] ?? "",
                    comment: ""
                ),
                style: .default,
                handler: { _ in
                NSLog("Unable to verify phone number")
                self.phoneNumberFieldDidChange()
                }
            )
        )
        self.present(errorAlert, animated: true)
    }

    func showSystemError() {
        let userInfo: [String: Any] = [
            NSLocalizedDescriptionKey: NSLocalizedString("System Error", value: "Unexpected error occured, retry", comment: "")
        ]

        let error = NSError(domain: "System Error", code: 1, userInfo: userInfo)
        self.showAlert(with: error)
    }

    func verifyPhoneNumberAndProceed(with mobileNumber: String) {
        let regex = try! NSRegularExpression(
            pattern: "[()\\-\\s]",
            options: NSRegularExpression.Options.caseInsensitive
        )
        let range = NSRange(location: 0, length: mobileNumber.count)
        let parsedMobileNumber = regex.stringByReplacingMatches(
            in: mobileNumber,
            options: [],
            range: range,
            withTemplate: ""
        )
        UserDefaults.standard.set(parsedMobileNumber, forKey: "mobileNumber")
        guard let registerPhoneUrl = URL(string: phoneNumberRegistrationUrlString + parsedMobileNumber) else {
            Logger.logError(with: "Register phone number error. Converting url request from: \(phoneNumberRegistrationUrlString)")
            showSystemError()
            return
        }
        guard let wlResourceRequest = WLResourceRequest(url: registerPhoneUrl, method: "POST") else {
            Logger.logError(with: "Register phone number error. Generating url request from: \(registerPhoneUrl)")
            showSystemError()
            return
        }
        // swiftlint:disable:next trailing_closure
        wlResourceRequest.send(completionHandler: { [weak self] response, error -> Void in
            if let error = error as NSError? {
                if error.code < -1000 {
                    let userInfo: [String: Any] = [
                        NSLocalizedDescriptionKey: NSLocalizedString("Connection Error", value: "Cannot connect to Network, retry", comment: "")
                    ]

                    let error = NSError(domain: "System Error", code: 1, userInfo: userInfo)
                    self?.showAlert(with: error)
                    return
                } else {
                    Logger.logError(with: "Register phone number error. Response: \(response ?? WLResponse()) Error: \(error.localizedDescription)")
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
            UserDefaults.standard.set(true, forKey: "isPhoneNumberProvided")
            self?.startVericationProcess()
        })
    }
}

extension PhoneNumberRegistrationViewController {
    func startVericationProcess() {
        guard let registerPhoneUrl = URL(string: otpVerificationUrlString) else {
            Logger.logError(with: "Verify OTP error. Converting url request from: \(otpVerificationUrlString)")
            showSystemError()
            return
        }
        guard let wlResourceRequest = WLResourceRequest(url: registerPhoneUrl, method: "POST") else {
            Logger.logError(with: "Verfify OTP error. Generating url request from: \(registerPhoneUrl)")
            showSystemError()
            return
        }
        // swiftlint:disable:next trailing_closure
        wlResourceRequest.send(completionHandler: { [weak self] response, error -> Void in
            if let error = error as NSError? {
                Logger.logError(with: "Verfify OTP error. Response: \(response ?? WLResponse()) Error: \(error.localizedDescription)")

                if error.code == -999 {
                    if let phoneNumber = UserDefaults.standard.string(forKey: "mobileNumber"),
                        phoneNumber.count > 8 {
                        self?.startVericationProcess()
                        return
                    }
                    self?.phoneNumberFieldDidChange()
                    return
                } else if error.code < -1000 {
                    let userInfo: [String: Any] = [
                        NSLocalizedDescriptionKey: phoneNumberConnectionError
                    ]
                    let error = NSError(domain: "System Error", code: 1, userInfo: userInfo)
                    self?.showAlert(with: error)
                    return
                } else {
                    Logger.logError(with: "Verfify OTP error. Response: \(response ?? WLResponse()) Error: \(error.localizedDescription)")
                }
                Logger.DLog("Phone number verification error: \(error.localizedDescription)")
                let userInfo: [String: Any] = [
                    NSLocalizedDescriptionKey: NSLocalizedString(
                        phoneNumberInvalidPinError,
                        tableName: "",
                        bundle: BKLocalizationManager.sharedInstance.currentBundle,
                        value: BKLocalizationManager.sharedInstance.defaultStrings[phoneNumberInvalidPinError] ?? "",
                        comment: ""
                    )
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
                Logger.logError(with: "Verfify OTP error, reponse does not have userid. Response: \(response ?? WLResponse())")
                self?.showSystemError()
                return
            }
                self?.navigator.navigate(from: self?.identifier ?? OnboardingNavigator.Destination.phoneRegistration)
            }
        )
    }
    internal static func codeDialog (title: String, message: String, isCode: Bool, completion: @escaping OTPCompletion) {
        let viewController = OTPVerificationViewController(navigator: OnboardingNavigator(navigationController: UINavigationController()), identifier: .phoneRegistration)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.oTPCompletion = completion
        // swiftlint:disable:next force_unwrapping
        UIApplication.shared.delegate?.window!!.rootViewController!.present(viewController, animated: true, completion: nil)
    }
}
