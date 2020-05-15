//
//  TurnOnBluetoothViewController.swift
//  OpenTrace

import UIKit

class TurnOnBluetoothViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var topInstructionLabel: UILabel!
    @IBOutlet weak var bottomInstructionLabel: UILabel!
    @IBOutlet weak var turnOnProgressButton: UIButton!

    @IBAction func enabledBluetoothBtn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showFullySetUpFromTurnOnBtSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.setLabel(with: "iPhone user? Optimize your experience",
                             using: .h2)
        
        topInstructionLabel.setLabel(with: "Heading out for essential errands? To keep Bluetooth active and conserve your battery, place your phone upside down or screen side down in your pocket. Once you get home, there’s no need to keep the app running.",
                                     using: .body)
        
        turnOnProgressButton.setButton(with: "Next", and: .arrow)
    }
}
