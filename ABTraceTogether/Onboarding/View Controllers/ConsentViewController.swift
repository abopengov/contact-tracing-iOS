//
//  ConsentViewController.swift
//  OpenTrace

import UIKit
import SafariServices

class ConsentViewController: UIViewController {
    @IBOutlet weak var consentHeaderLabel: UILabel!
    @IBOutlet weak var consentBodyLabel: UITextView!
    @IBOutlet weak var consentButton: UIButton!
    @IBOutlet weak var iAgreeSelector: UISwitch!
    @IBOutlet weak var privacyPolicyLinkButton: UIButton!
    @IBOutlet weak var faqLinkButton: UIButton!
    
    
    @IBAction func consentBtn(_ sender: UIButton) {
        OnboardingManager.shared.hasConsented = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        consentButton.isEnabled = false
        //iAgreeSelector.isOn = OnboardingManager.shared.hasConsented
        privacyPolicyLinkButton.setTitle("View Privacy Policy Online", for: .normal)
        faqLinkButton.setTitle("View FAQ", for: .normal)
        
        consentHeaderLabel.setLabel(with: "Collection of your information", using: .h2)
        consentBodyLabel.setAttributedEmailLink(with: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", and: "Privacy Statement.", and: "https://www.yourSite.ca", and: "\n\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. ", and: "yourEmail@yourDomain.ca", and: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", and: "yourEmail@yourDomain.ca")
        consentButton.setButton(with: "Next", and: .arrow)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if OnboardingManager.shared.hasConsented == true {
            iAgreeSelector.isOn = true
            iAgreeSelectChagned(self)
        } else {
            iAgreeSelector.isOn = false
            iAgreeSelectChagned(self)
        }
    }

    @IBAction func iAgreeSelectChagned(_ sender: Any) {
        OnboardingManager.shared.hasConsented = iAgreeSelector.isOn
        consentButton.isEnabled = iAgreeSelector.isOn
        
        if iAgreeSelector.isOn {
            consentButton.backgroundColor = UIColor(red: 0, green: 0.439, blue: 0.769, alpha: 1)
        } else {
            consentButton.backgroundColor = UIColor(red: 0.646, green: 0.646, blue: 0.646, alpha: 1)
        }
    }
    
    @IBAction func privacyPolicyLinkButtonPressed(_ sender: Any) {
     
        showSafaiView(with: "https://www.yourPrivacyLink.com")
    }
    
    @IBAction func faqLinkButtonPressed(_ sender: Any) {
        
        showSafaiView(with: "https://www.yourFAQ.com")
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if let userid = UserDefaults.standard.string(forKey: userDefaultsPinKey),
            userid.count > 0  {
            self.performSegue(withIdentifier: "showAllowPermissionsFromIWantoToHelpSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "iWantToHelpToPhoneSegue", sender: self)
            OnboardingManager.shared.hasConsented = true
        }
    }
}

//MARK: - SFSafariViewControllerDelegate
extension ConsentViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK: - helpers
extension ConsentViewController {
    
    func showSafaiView(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
        
        safariVC.delegate = self
    }
}
