//
//  HowItWorksViewController.swift
//  OpenTrace

import UIKit

class HowItWorksViewController: UIViewController {
    @IBOutlet weak var howItWorksHeaderImage: UIImageView!
    @IBOutlet weak var howItWorksHeaderLabel: UILabel!
    @IBOutlet weak var howItWorksSubheaderLabel: UILabel!
    @IBOutlet weak var howItWorksProgressButton: UIButton!

    @IBAction func greatBtnOnClick(_ sender: UIButton) {

        OnboardingManager.shared.completedIWantToHelp = true
        self.performSegue(withIdentifier: "showPrivacySegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        howItWorksHeaderLabel.setLabel(with: "How it works",
                                       using: .h2)
        howItWorksSubheaderLabel.setLabel(with: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since",
                                          using: .body)
        howItWorksProgressButton.setButton(with: "Get started", and: .arrow)
    }
}
