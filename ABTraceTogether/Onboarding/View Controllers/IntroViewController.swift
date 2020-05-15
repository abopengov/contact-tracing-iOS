//
//  IntroViewController.swift
//  OpenTrace

import UIKit

class IntroViewController: UIViewController {
    @IBOutlet weak var introHeaderImage: UIImageView!
    @IBOutlet weak var introHeadingLabel: UILabel!
    @IBOutlet weak var introSubHeadingLabel: UILabel!
    @IBOutlet weak var introDescriptionLabel: UILabel!
    @IBOutlet weak var introProgressButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        introHeadingLabel.setLabel(with: "Help stop the spread of COVID-19 using your \nmobile phone",
                                   using: .h2)
        introSubHeadingLabel.setLabel(with: "Your Bluetooth connection can help track your potential COVID-19 exposure.",
                                      using: .body)
        introDescriptionLabel.setLabel(with: "Brought to you by the",
                                       using: .eyebrowText)
        if let appVersion = UIApplication.appVersion {
            versionLabel.setLabel(with: "Version: \(appVersion)",
                                 using: .body)
            versionLabel.isHidden = false
        } else {
            versionLabel.isHidden = true
        }
        introProgressButton.setButton(with: "Join the fight", and: .arrow)
        
    }
    @IBAction func iWantToHelpButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showHowItWorksSegue", sender: self)
    }
}
