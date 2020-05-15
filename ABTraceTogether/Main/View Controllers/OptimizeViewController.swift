//
//  OptimizeViewController.swift
//  OpenTrace

import UIKit

class OptimizeViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var topInstructionLabel: UILabel!
    @IBOutlet weak var bottomInstructionLabel: UILabel!
    @IBOutlet weak var turnOnProgressButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func enabledBluetoothBtn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showFullySetUpFromTurnOnBtSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let backImage = UIImage(named: "BackArrow")
        backButton.setImage(backImage, for: .normal)
        backButton.setTitle(" Back", for: .normal)
        
        headerLabel.setLabel(with: "iPhone user? Optimize your experience",
                             using: .h2)
        
        topInstructionLabel.setLabel(with: "Heading out for essential errands? To keep Bluetooth active and conserve your battery, place your phone upside down or screen side down in your pocket. Once you get home, there’s no need to keep the app running.",
                                     using: .body)
        
//        turnOnProgressButton.setButton(with: "Next", and: .arrow)
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
