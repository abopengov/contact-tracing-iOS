//
//  PermissionsViewController.swift
//  OpenTrace

import UIKit
import UserNotifications

class PermissionsViewController: UIViewController {
    @IBOutlet weak var permissionsProgressButton: UIButton!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subHeaderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        permissionsProgressButton.setTitle("Continue", for: .normal)

        stepsLabel.setLabel(with: "Step 3 of 3", using: .stepText)
        headerLabel.setLabel(with: "Enable app permissions",
                             using: .h2)
        subHeaderLabel.setLabel(with: "We need permission to enable your mobile phone's Bluetooth connection and send you alerts through push notifications. When you’re ready, tap Next and choose “Allow” when the two popups appear.",
                                using: .body)
        permissionsProgressButton.setButton(with: "Next",
                                            and: .arrow)
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        registerForPushNotifications()
        requestBluetoothPermissions()
        self.performSegue(withIdentifier: "showFullySetUpFromTurnOnBtSegue", sender: self)
    }
    
    func registerForPushNotifications() {
        BlueTraceLocalNotifications.shared.checkAuthorization { (_) in
            //Make updates to VCs if any here.
        }
    }

    private func requestBluetoothPermissions(){
        BluetraceManager.shared.turnOn()
        OnboardingManager.shared.allowedPermissions = true
        
        BlueTraceLocalNotifications.shared.checkAuthorization { (granted) in
        }
    }
}
