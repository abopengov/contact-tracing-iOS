import Foundation
import IBMMobileFirstPlatformFoundation

public class SMSCodeChallengeHandler: SecurityCheckChallengeHandler {
    public static let securityCheck = "smsOtpService"

    // swiftlint:disable:next implicitly_unwrapped_optional
    override public func handleChallenge(_ challenge: [AnyHashable: Any]!) {
        PhoneNumberRegistrationViewController.codeDialog(title: "Enter OTP", message: "OTP String", isCode: true) { smsCode, isOk in
            if isOk {
                self.submitChallengeAnswer(["code": smsCode])
            } else {
                self.cancel()
            }
        }
    }
}
