import UIKit

typealias OTPCompletion = (String, Bool) -> Void

class OTPVerificationViewController: BaseViewController {
    enum Status {
        case InvalidOTP
        case WrongOTP
        case Success
    }

    let codeInputView = CodeInputView()
    let verifyButton = UIButton()
    var expiredMessageLabel = UILabel()
    var errorMessageLabel = UILabel()

    var timer: Timer?
    static let timerValue = 180
    var oTPCompletion: OTPCompletion?
    var countdownSeconds = timerValue
    var startTimeFromEpoch = 0

    lazy var countdownFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false

        generatePrivacyViews(in: contentView)
        dismissKeyboardOnTap()
        errorMessageLabel.textColor = .red
        codeInputView.isOneTimeCode = true
        dismissKeyboardOnTap()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = codeInputView.becomeFirstResponder()
    }
}

extension OTPVerificationViewController {
    @objc
    func updateTimerCountdown() {
        countdownSeconds = OTPVerificationViewController.timerValue - Int(NSDate().timeIntervalSince1970) + startTimeFromEpoch

        if countdownSeconds > 0 {
            let countdown = countdownFormatter.string(
                from: TimeInterval(
                    countdownSeconds
                )
            ) ?? ""
            expiredMessageLabel.text = String(
                format: NSLocalizedString(
                    otpScreenCodeExpireText,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[otpScreenCodeExpireText] ?? "",
                    comment: ""
                ),
                countdown
            )
            expiredMessageLabel.isHidden = false
        } else {
            timer?.invalidate()
            expiredMessageLabel.text = NSLocalizedString(
                otpScreenCodeHasExpiredText,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[otpScreenCodeHasExpiredText] ?? "",
                comment: ""
            )
            expiredMessageLabel.textColor = .red

            verifyButton.isEnabled = false
        }
    }

    @objc
    func resendCode(_ sender: UIButton) {
        guard let _ = UserDefaults.standard.string(forKey: "mobileNumber") else {
            performSegue(withIdentifier: "showEnterMobileNumber", sender: self)
            return
        }

        cancelAndDismissViewcontroller()
        startTimer()
    }

    @objc
    func wrongNumberButtonPressed(_ sender: Any) {
        UserDefaults.standard.set("", forKey: "mobileNumber")
        cancelAndDismissViewcontroller()
    }

    @objc
    func verify(_ sender: UIButton) {
        verifyOTP { [weak viewController = self] status in
            switch status {
            case .InvalidOTP:
                viewController?.errorMessageLabel.text = NSLocalizedString(
                    otpScreenInvalidOTP,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[otpScreenInvalidOTP] ?? "",
                    comment: ""
                )
                self.errorMessageLabel.isHidden = false

            case .WrongOTP:
                viewController?.errorMessageLabel.text = NSLocalizedString(
                    otpScreenWrongOTP,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[otpScreenWrongOTP] ?? "",
                    comment: ""
                )
                self.errorMessageLabel.isHidden = false

            case .Success:
                break
            }
        }
    }
}

extension OTPVerificationViewController {
    func startTimer() {
        countdownSeconds = OTPVerificationViewController.timerValue
        timer?.invalidate()
        startTimeFromEpoch = Int(NSDate().timeIntervalSince1970)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(OTPVerificationViewController.updateTimerCountdown), userInfo: nil, repeats: true)
        if #available(iOS 13.0, *) {
            expiredMessageLabel.textColor = .label
        } else {
            expiredMessageLabel.textColor = .black
        }
        expiredMessageLabel.isHidden = true
        errorMessageLabel.isHidden = true
        verifyButton.isEnabled = true
    }

    // MARK: - phone number verification
    func verifyOTP(_ result: @escaping (Status) -> Void) {
        let OTP = codeInputView.text

        guard OTP.range(of: "^[0-9]{6}$", options: .regularExpression) != nil else {
            result(.InvalidOTP)
            return
        }

        if let oTPCompletion = oTPCompletion {
            oTPCompletion(OTP, true)
        }
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: 
extension OTPVerificationViewController {
    override func createButton(in parentView: UIView) {
        parentView.addSubview(verifyButton)

        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        verifyButton.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        verifyButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        verifyButton.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -30).isActive = true
        verifyButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        verifyButton.setButton(with: otpScreenGetOTPButtonText, and: .arrow)
        verifyButton.addTarget(self, action: #selector(verify(_:)), for: .touchUpInside)
    }
}

// MARK: - helpers
extension OTPVerificationViewController {
    private func cancelAndDismissViewcontroller() {
        if let oTPCompletion = oTPCompletion {
            oTPCompletion("resend", false)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Content
extension OTPVerificationViewController {
    private func generatePrivacyViews(in contentView: UIView) {
        clearSubViews(from: contentView)

        let layoutView = UIView()
        contentView.addSubview(layoutView)
        layoutView.translatesAutoresizingMaskIntoConstraints = false
        layoutView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        layoutView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        layoutView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
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

        let backButton = UIButton()
        newView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        backButton.topAnchor.constraint(equalTo: newView.topAnchor, constant: 40).isActive = true

        let backImage = UIImage(named: "BackArrow")
        backButton.setImage(backImage, for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(wrongNumberButtonPressed(_:)), for: .touchUpInside)

        let stepLabel = UILabel()
        newView.addSubview(stepLabel)
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        stepLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        stepLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        stepLabel.topAnchor.constraint(equalTo: newView.topAnchor, constant: 100).isActive = true

        stepLabel.setLabel(
            with: otpScreenStepNumberText,
            using: .stepText
        )

        let headerMessageLabel1 = UILabel()
        newView.addSubview(headerMessageLabel1)
        headerMessageLabel1.translatesAutoresizingMaskIntoConstraints = false
        headerMessageLabel1.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        headerMessageLabel1.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        headerMessageLabel1.topAnchor.constraint(equalTo: stepLabel.topAnchor, constant: 20).isActive = true

        headerMessageLabel1.setLabel(
            with: otpScreenHeaderText,
            using: .h2
        )

        newView.addSubview(codeInputView)
        codeInputView.translatesAutoresizingMaskIntoConstraints = false
        codeInputView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 16).isActive = true
        codeInputView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -16).isActive = true
        codeInputView.topAnchor.constraint(equalTo: headerMessageLabel1.bottomAnchor, constant: 20).isActive = true
        codeInputView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        codeInputView.layer.borderColor = UIColor.gray.cgColor

        let detailMessageLabel1 = UILabel()
        newView.addSubview(detailMessageLabel1)
        detailMessageLabel1.translatesAutoresizingMaskIntoConstraints = false
        detailMessageLabel1.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        detailMessageLabel1.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        detailMessageLabel1.topAnchor.constraint(equalTo: codeInputView.bottomAnchor, constant: 20).isActive = true

        let otpScreenSubHeaderTextP1Localized = NSLocalizedString(
            otpScreenSubHeaderTextP1,
            tableName: "",
            bundle: BKLocalizationManager.sharedInstance.currentBundle,
            value: BKLocalizationManager.sharedInstance.defaultStrings[otpScreenSubHeaderTextP1] ?? "",
            comment: ""
        )
        let otpScreenSubHeaderTextP2Localized = NSLocalizedString(
            otpScreenSubHeaderTextP2,
            tableName: "",
            bundle: BKLocalizationManager.sharedInstance.currentBundle,
            value: BKLocalizationManager.sharedInstance.defaultStrings[otpScreenSubHeaderTextP2] ?? "",
            comment: ""
        )

        let mobileNumber = UserDefaults.standard.string(forKey: "mobileNumber") ?? "Unknown"
        let otpScreenSubHeaderText = "\(otpScreenSubHeaderTextP1Localized) \(mobileNumber) \( otpScreenSubHeaderTextP2Localized)"

        detailMessageLabel1.setLabel(
            with: otpScreenSubHeaderText,
            using: .body
        )

        newView.addSubview(errorMessageLabel)
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        errorMessageLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        errorMessageLabel.topAnchor.constraint(equalTo: detailMessageLabel1.bottomAnchor, constant: 10).isActive = true

        errorMessageLabel.setLabel(
            with: "test",
            using: .body
        )

        newView.addSubview(expiredMessageLabel)
        expiredMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        expiredMessageLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        expiredMessageLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        expiredMessageLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 10).isActive = true

        expiredMessageLabel.setLabel(
            with: NSLocalizedString(
                otpScreenCodeExpireText,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[otpScreenCodeExpireText] ?? "",
                comment: ""
            ),
            using: .body,
            localize: false
        )

        let didntReceiveCodeLabel = UILabel()
        newView.addSubview(didntReceiveCodeLabel)
        didntReceiveCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        didntReceiveCodeLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        didntReceiveCodeLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        didntReceiveCodeLabel.topAnchor.constraint(equalTo: expiredMessageLabel.bottomAnchor, constant: 20).isActive = true

        didntReceiveCodeLabel.setLabel(
            with: otpScreenDidntReceiveCodeText,
            using: .body
        )

        let requestAnotherButton = UIButton()
        newView.addSubview(requestAnotherButton)
        requestAnotherButton.translatesAutoresizingMaskIntoConstraints = false
        requestAnotherButton.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        requestAnotherButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        requestAnotherButton.topAnchor.constraint(equalTo: didntReceiveCodeLabel.bottomAnchor, constant: 0).isActive = true

        let resendCodeButtonTitle = NSMutableAttributedString(
            string: NSLocalizedString(
                otpScreenRequestAnotherCodeButtonText,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[otpScreenRequestAnotherCodeButtonText] ?? "",
                comment: ""
            ),
            attributes: linkButtonAttributes
        )

        requestAnotherButton.setAttributedTitle(resendCodeButtonTitle, for: .normal)
        requestAnotherButton.addTarget(self, action: #selector(resendCode(_:)), for: .touchUpInside)

        if let versionLabelString = versionLabelString {
            let versionLabel = UILabel()
            newView.addSubview(versionLabel)
            versionLabel.translatesAutoresizingMaskIntoConstraints = false
            versionLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
            versionLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
            versionLabel.topAnchor.constraint(equalTo: requestAnotherButton.bottomAnchor, constant: 20).isActive = true

            versionLabel.setLabel(
                with: versionLabelString,
                using: .body
            )

            newView.bottomAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 20).isActive = true
        } else {
            newView.bottomAnchor.constraint(equalTo: requestAnotherButton.bottomAnchor, constant: 20).isActive = true
        }
    }
}
