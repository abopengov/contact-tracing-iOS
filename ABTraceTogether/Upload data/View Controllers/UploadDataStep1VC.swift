//
//  UploadDataStep1VC.swift
//  OpenTrace

import Foundation
import UIKit

class UploadDataStep1VC: UIViewController {
    @IBOutlet weak var uploadDataHeader: UILabel!
    @IBOutlet weak var uploadDataStep1: UILabel!
    @IBOutlet weak var verificationCode: UILabel!
    @IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadDataHeader.setLabel(with: "VERIFY YOUR CODE", using: .h2)
        uploadDataStep1.setLabel(with: "Please confirm the code listed below matches the one read out to you by the caller from \nhealth authority", using: .body)

        
        nextBtn.setButton(with: "Next", and: .arrow)
        
        if let savedVerificationCode = UserDefaults.standard.string(forKey: userDefaultsPinKey) {
            verificationCode.text = savedVerificationCode
            verificationCode.setCharacterSpacing(characterSpacing: 22)
        } else {
            fetchedHandshakePin()
        }
    }

    @IBAction func retryBtnTapped(_ sender: UIButton) {
        fetchedHandshakePin()
    }

    private func fetchedHandshakePin() {
        nextBtn.isEnabled = false
        retryBtn.isHidden = true        
    }
}
