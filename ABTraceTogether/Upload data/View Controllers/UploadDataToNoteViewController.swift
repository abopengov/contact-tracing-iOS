//
//  UploadDataToNoteViewController.swift
//  OpenTrace

import UIKit

class UploadDataToNoteViewController: UIViewController {
    @IBOutlet weak var uploadDataHeader: UILabel!
    @IBOutlet weak var uploadDataSubheader: UILabel!
    @IBOutlet weak var uploadDataButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.borderWidth = 0
        navigationController?.navigationBar.borderColor = .white
        navigationController?.navigationBar.shadowColor = .white
        navigationController?.navigationBar.barStyle = .blackTranslucent
        
        uploadDataHeader.setLabel(with: "HAS CALLED YOU\n ASKED YOU TO UPLOAD\n YOUR DATA?", using: .h2)
        uploadDataSubheader.setLabel(with: "Don’t tap ‘Next’ unless a contact tracer from... has instructed you to do so.", using: .body)
        uploadDataButton.setButton(with: "Next", and: .arrow)
    }
}
