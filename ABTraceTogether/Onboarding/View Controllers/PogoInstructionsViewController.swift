//
//  PogoInstructionsViewController.swift
//  OpenTrace

import UIKit

class PogoInstructionsViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var keptOpenLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.setLabel(with: "Registration successful!",
                             using: .h2)
        keptOpenLabel.setLabel(with: "You’re all set up.",
                               using: .body)
        
        finishButton.setButton(with: "Finish", and: .check)
        OnboardingManager.shared.completedBluetoothOnboarding = true
    }
    
}
