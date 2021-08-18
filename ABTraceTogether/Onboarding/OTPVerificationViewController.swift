import UIKit

typealias OTPCompletion = (String, Bool) -> Void

class OTPVerificationViewController: BaseViewController {
    let codeInputView = CodeInputView()
    let verifyButton = UIButton()
    var expiredMessageLabel = UILabel()
    let didntReceiveCodeLabel = UILabelWithLink()


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
                format: otpScreenCodeExpireText.localize(),
                countdown
            )
            expiredMessageLabel.isHidden = false
        } else {
            timer?.invalidate()
            expiredMessageLabel.text = otpScreenCodeHasExpiredText.localize()
            expiredMessageLabel.textColor = UIColor(red: 0.65, green: 0.15, blue: 0.15, alpha: 1.00)

            didntReceiveCodeLabel.setLabel(
                with: otpScreenRequestAnotherCodeButtonText.localize(),
                using: .blackDescriptionText
            )
            didntReceiveCodeLabel.addLink(textToFind: otpScreenRequestAnotherCodeButtonText.localize(),
                                          value: otpScreenRequestAnotherCodeButtonText.localize())

            verifyButton.isEnabled = false
        }
    }

    @objc
    func resendCode() {
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
        if !verifyOTP() {
            self.showErrorDialog(otpScreenInvalidOTP.localize())
        }
    }
    
    private func showErrorDialog(_ message: String) {
        self.presentedViewController?.dismiss(animated: false)
        
        let alert = UIAlertController(
            title: generalErrorTitleString.localize(),
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: generalDoneString.localize(), style: .default)
        )

        self.present(alert, animated: true)
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
        verifyButton.isEnabled = true
    }

    // MARK: - phone number verification
    func verifyOTP() -> Bool {
        let OTP = codeInputView.text

        guard OTP.range(of: "^[0-9]{6}$", options: .regularExpression) != nil else {
            return false
        }

        if let oTPCompletion = oTPCompletion {
            oTPCompletion(OTP, true)
        }
        self.dismiss(animated: false, completion: nil)

        return true
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

        let scrollViewContainer = UIView()
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

    private func generateContent(in parentView: UIView) {
        let backButton = UIButton()
        parentView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        backButton.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 20).isActive = true

        let backImage = UIImage(named: "BackArrow")
        backButton.setImage(backImage, for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(wrongNumberButtonPressed(_:)), for: .touchUpInside)

        let headerImageView = UIImageView()
        parentView.addSubview(headerImageView)
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        headerImageView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        headerImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 60).isActive = true
        headerImageView.image = UIImage(named: "MobileStep")
        headerImageView.contentMode = .scaleAspectFit
        headerImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        let headerMessageLabel1 = UILabel()
        parentView.addSubview(headerMessageLabel1)
        headerMessageLabel1.translatesAutoresizingMaskIntoConstraints = false
        headerMessageLabel1.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        headerMessageLabel1.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        headerMessageLabel1.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 60).isActive = true
        headerMessageLabel1.setLabel(
            with: otpScreenHeaderText,
            using: .h2
        )
        headerMessageLabel1.textAlignment = .left

        parentView.addSubview(codeInputView)
        codeInputView.translatesAutoresizingMaskIntoConstraints = false
        codeInputView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 16).isActive = true
        codeInputView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -16).isActive = true
        codeInputView.topAnchor.constraint(equalTo: headerMessageLabel1.bottomAnchor, constant: 15).isActive = true
        codeInputView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        codeInputView.layer.borderColor = UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00).cgColor
        codeInputView.textColor = UIColor(red: 0.00, green: 0.44, blue: 0.77, alpha: 1.00)
        codeInputView.font = UIFont(name: "HelveticaNeue", size: 16)
        
        let detailMessageLabel1 = UILabel()
        parentView.addSubview(detailMessageLabel1)
        detailMessageLabel1.translatesAutoresizingMaskIntoConstraints = false
        detailMessageLabel1.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        detailMessageLabel1.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        detailMessageLabel1.topAnchor.constraint(equalTo: codeInputView.bottomAnchor, constant: 30).isActive = true

        let mobileNumber = UserDefaults.standard.string(forKey: "mobileNumber") ?? "Unknown"
        let detailsMessageFormatText = otpScreenSubHeaderText.localize().replacingOccurrences(of: "%s", with: "%@")
        let detailsMessageText = String(format: detailsMessageFormatText, PhoneNumberFormatter.format(mobileNumber))

        detailMessageLabel1.setLabel(
            with: detailsMessageText,
            using: .blackDescriptionText
        )
        detailMessageLabel1.textAlignment = .left

        parentView.addSubview(expiredMessageLabel)
        expiredMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        expiredMessageLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        expiredMessageLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        expiredMessageLabel.topAnchor.constraint(equalTo: detailMessageLabel1.bottomAnchor, constant: 20).isActive = true

        expiredMessageLabel.setLabel(
            with: otpScreenCodeExpireText.localize(),
            using: .blackDescriptionText,
            localize: false
        )
        expiredMessageLabel.textAlignment = .left

        parentView.addSubview(didntReceiveCodeLabel)
        didntReceiveCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        didntReceiveCodeLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        didntReceiveCodeLabel.topAnchor.constraint(equalTo: expiredMessageLabel.bottomAnchor, constant: 20).isActive = true

        didntReceiveCodeLabel.setLabel(
            with: otpScreenDidntReceiveCodeText.localize() + " " + otpScreenRequestAnotherCodeButtonText.localize(),
            using: .blackDescriptionText
        )
        didntReceiveCodeLabel.addLink(textToFind: otpScreenRequestAnotherCodeButtonText.localize(),
                                      value: otpScreenRequestAnotherCodeButtonText.localize())
        didntReceiveCodeLabel.textAlignment = .left

        didntReceiveCodeLabel.delegate = self

        parentView.bottomAnchor.constraint(equalTo: didntReceiveCodeLabel.bottomAnchor, constant: 20).isActive = true
    }
}

extension OTPVerificationViewController: UILabelWithLinkDelegate {
    func linkClickedWithValue(_ value: Any) {
        self.resendCode()
    }
}
