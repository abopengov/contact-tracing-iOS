//
//  OTPViewController.swift
//  OpenTrace

import UIKit
import IBMMobileFirstPlatformFoundation

typealias OTPCompletion = (String, Bool) -> Void

let userDefaultsPinKey = "HEALTH_AUTH_VERIFICATION_CODE"

class OTPViewController: UIViewController {

    enum Status {
        case InvalidOTP
        case WrongOTP
        case Success
    }

    // MARK: - UI

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var codeInputView: CodeInputView?
    @IBOutlet weak var verificationCodeDetails: UILabel!
    @IBOutlet weak var expiredMessageLabel: UILabel?
    @IBOutlet weak var errorMessageLabel: UILabel?

    @IBOutlet weak var otpErrorMessageLabel: UILabel!
    @IBOutlet weak var wrongNumberButton: UIButton?
    @IBOutlet weak var resendCodeButton: UIButton?
    @IBOutlet weak var resendCodeLabel: UILabel!
    
    @IBOutlet weak var verifyButton: UIButton?

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var timer: Timer?

    static let timerValue = 180

    var oTPCompletion : OTPCompletion?
    var countdownSeconds = timerValue

    let linkButtonAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "HelveticaNeue", size: 14)!,
                                                               .foregroundColor: UIColor.blue,
                                                               ]

    lazy var countdownFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImage = UIImage(named: "BackArrow")
        backButton.setImage(backImage, for: .normal)
        backButton.setTitle(" Back", for: .normal)

        stepsLabel.setLabel(with: "Step 2 of 3", using: .stepText)
        titleLabel.setLabel(with: "Enter the code", using: .h2)
        let mobileNumber = UserDefaults.standard.string(forKey: "mobileNumber") ?? "Unknown"
        verificationCodeDetails.setLabel(with: "We’ve sent a text to \(mobileNumber) \nwith a confirmation code. \nPlease enter the six-digit code above.",
                                         using: .body)
        
        expiredMessageLabel?.setLabel(with: "Your code will expire in 3:00",
                                      using: .body)
        resendCodeLabel.setLabel(with: "Didn’t receive a code?", using: .body)
        errorMessageLabel?.setLabel(with: "", using: .body)
        errorMessageLabel?.textColor = .red
        let resendCodeButtonTitle = NSMutableAttributedString(string: "Request another.",
                                                              attributes: linkButtonAttributes)
        resendCodeButton?.setAttributedTitle(resendCodeButtonTitle, for: .normal)
        verifyButton?.setButton(with: "Next", and: .arrow)
        codeInputView?.isOneTimeCode = true
        dismissKeyboardOnTap()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = codeInputView?.becomeFirstResponder()
    }

    func startTimer() {
        countdownSeconds = OTPViewController.timerValue
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(OTPViewController.updateTimerCountdown), userInfo: nil, repeats: true)
        if #available(iOS 13.0, *) {
            expiredMessageLabel?.textColor = .label
        } else {
            expiredMessageLabel?.textColor = .black
        }
        expiredMessageLabel?.isHidden = true
        errorMessageLabel?.isHidden = true
        verifyButton?.isEnabled = true
    }

    @objc
    func updateTimerCountdown() {
        countdownSeconds -= 1

        if countdownSeconds > 0 {
            let countdown = countdownFormatter.string(from: TimeInterval(countdownSeconds))!
            expiredMessageLabel?.text = String(format: NSLocalizedString("CodeWillExpired", comment: "Your code will expired in %@."), countdown)
            expiredMessageLabel?.isHidden = false
        } else {
            timer?.invalidate()
            expiredMessageLabel?.text = NSLocalizedString("CodeHasExpired", comment: "Your code has expired.")
            expiredMessageLabel?.textColor = .red

            verifyButton?.isEnabled = false
        }
    }

    @IBAction func wrongNumberButtonPressed(_ sender: Any) {
        UserDefaults.standard.set("", forKey: "mobileNumber")
        cancelAndDismissViewcontroller()
    }
    
    @IBAction func resendCode(_ sender: UIButton) {
        guard let _ = UserDefaults.standard.string(forKey: "mobileNumber") else {
            performSegue(withIdentifier: "showEnterMobileNumber", sender: self)
            return
        }

        cancelAndDismissViewcontroller()
        startTimer()
    }



    @IBAction func verify(_ sender: UIButton) {
        verifyOTP { [unowned viewController = self] status in
            switch status {
            case .InvalidOTP:
                viewController.errorMessageLabel?.text = NSLocalizedString("InvalidOTP", comment: "Must be a 6-digit code")
                self.errorMessageLabel?.isHidden = false
            case .WrongOTP:
                viewController.errorMessageLabel?.text = NSLocalizedString("WrongOTP", comment: "Wrong OTP entered")
                self.errorMessageLabel?.isHidden = false
            case .Success:
                break
            }
        }
    }

}

//MARK: - phone number verification
extension OTPViewController {

        func verifyOTP(_ result: @escaping (Status) -> Void) {
            activityIndicator.startAnimating()
            guard let OTP = codeInputView?.text else {
                result(.InvalidOTP)
                return
            }

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

//MARK: - helpers
extension OTPViewController {
    private func cancelAndDismissViewcontroller() {
        if let oTPCompletion = oTPCompletion {
            oTPCompletion("resend", false)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension OTPViewController {
    internal static func codeDialog (title: String, message: String, isCode : Bool, completion: @escaping (_ code: String, _ ok: Bool) -> Void) {
        let modalViewController = OTPViewController()
        modalViewController.modalPresentationStyle = .overCurrentContext
        UIApplication.shared.delegate?.window!!.rootViewController!.present(modalViewController, animated: true, completion: nil)
    }
}
