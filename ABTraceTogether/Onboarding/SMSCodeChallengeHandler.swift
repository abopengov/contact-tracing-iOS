//
//  SMSCodeChallengeHandler.swift
//  OpenTrace
//
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import Foundation
import IBMMobileFirstPlatformFoundation

public class SMSCodeChallengeHandler : SecurityCheckChallengeHandler {
    public static let securityCheck = "smsOtpService"
    
    public override func handleChallenge(_ challenge: [AnyHashable : Any]!) {
        
        PhoneNumberViewController.codeDialog(title: "Enter OTP", message: "OTP String", isCode: true) { (smsCode, isOk) in
            
            if isOk {
                self.submitChallengeAnswer(["code": smsCode])
            } else {
                self.cancel()
            }
        }
    }
}
