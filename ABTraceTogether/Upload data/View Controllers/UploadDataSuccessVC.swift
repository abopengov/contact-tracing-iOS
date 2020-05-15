//
//  UploadDataSuccessVC.swift
//  OpenTrace

import Foundation
import UIKit

class UploadDataSuccessVC: UIViewController {
    @IBOutlet weak var successMessageLabel: UILabel!
    @IBOutlet weak var successProgressButton: UIButton!
    @IBOutlet weak var successHeaderLabel: UILabel!
    
    
    override func viewDidLoad() {
        successProgressButton.setButton(with: "Finish", and: .check)
    }
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        // Bring user back to home tab
        self.navigationController?.tabBarController?.selectedIndex = 0
    }
    
}
