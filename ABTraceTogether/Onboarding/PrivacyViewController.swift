import SafariServices
import UIKit

let userConcentedToPrivacy = "userConcentedToPrivacy"

class PrivacyViewController: BaseViewController {
    let bottomButton = UIButton()
    let iAgreeCheckbox = UIButton()

    var privacyConcented: Bool {
        get {
            UserDefaults.standard.bool(forKey: userConcentedToPrivacy)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userConcentedToPrivacy)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        generatePrivacyViews(in: contentView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if privacyConcented == true {
            iAgreeCheckbox.isSelected = true
            updateConsentCheckbox(iAgreeCheckbox.isSelected)
        } else {
            iAgreeCheckbox.isSelected = false
            updateConsentCheckbox(iAgreeCheckbox.isSelected)
        }
    }
}

// MARK: - Next button
extension PrivacyViewController {
    override func createButton(in parentView: UIView) {
        parentView.addSubview(bottomButton)

        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        bottomButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        bottomButton.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -30).isActive = true
        bottomButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        bottomButton.setButton(with: nextButtonText, and: .arrow)
        bottomButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }

    @objc
    private func privacyPolicyOnlineButtonAction(_ sender: UIButton) {
        showSafaiView(with: privacyLink)
    }

    @objc
    private func faqButtonAction(_ sender: UIButton) {
        showSafaiView(with: privacyFaqLink)
    }

    @objc
    private func iAgreeCheckboxChanged(_ sender: Any) {
        iAgreeCheckbox.isSelected.toggle()
        updateConsentCheckbox(iAgreeCheckbox.isSelected)
    }

    private func updateConsentCheckbox(_ consent: Bool) {
        privacyConcented = consent
        bottomButton.isEnabled = consent

        if iAgreeCheckbox.isSelected {
            bottomButton.backgroundColor = UIColor(red: 0, green: 0.439, blue: 0.769, alpha: 1)
        } else {
            bottomButton.backgroundColor = UIColor(red: 0.646, green: 0.646, blue: 0.646, alpha: 1)
        }
    }
}

// MARK: - SFSafariViewControllerDelegate
extension PrivacyViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - helpers
extension PrivacyViewController {
    func showSafaiView(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }

        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)

        safariVC.delegate = self
    }
}

// MARK: - Content
extension PrivacyViewController {
    private func generatePrivacyViews(in contentView: UIView) {
        clearSubViews(from: contentView)

        let layoutView = UIView()
        contentView.addSubview(layoutView)
        layoutView.translatesAutoresizingMaskIntoConstraints = false
        layoutView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        layoutView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        layoutView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        layoutView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        layoutView.addSubview(scrollView)

        let scrollViewContainer = UIStackView()

        scrollViewContainer.axis = .vertical
        scrollViewContainer.spacing = 10

        scrollViewContainer.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(scrollViewContainer)
        generateContent(in: scrollViewContainer)

        scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: layoutView.topAnchor, constant: -10).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    private func generateContent(in parentView: UIStackView) {
        let newView = UIView()
        parentView.addArrangedSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false

        let headerMessageLabel1 = UILabel()
        newView.addSubview(headerMessageLabel1)
        headerMessageLabel1.translatesAutoresizingMaskIntoConstraints = false
        headerMessageLabel1.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        headerMessageLabel1.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        headerMessageLabel1.topAnchor.constraint(equalTo: newView.topAnchor, constant: 40).isActive = true

        headerMessageLabel1.setLabel(
            with: privacyHeader,
            using: .h2
        )
        headerMessageLabel1.textAlignment = .left

        let detailMessageLabel1 = UITextView()
        newView.addSubview(detailMessageLabel1)
        detailMessageLabel1.translatesAutoresizingMaskIntoConstraints = false
        detailMessageLabel1.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        detailMessageLabel1.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        detailMessageLabel1.topAnchor.constraint(equalTo: headerMessageLabel1.bottomAnchor, constant: 20).isActive = true

        detailMessageLabel1.setAttributedEmailLink(
            with: NSLocalizedString(
                privacy_policy_text1,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[privacy_policy_text1] ?? "",
                comment: ""
            ) + "\n\n" +
                NSLocalizedString(
                    privacy_policy_text2,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[privacy_policy_text2] ?? "",
                    comment: ""
                ) + "\n\n" +
                NSLocalizedString(
                    privacy_policy_text3,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[privacy_policy_text3] ?? "",
                    comment: ""
                ) + "\n\n" +
                NSLocalizedString(
                    privacy_policy_text4,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[privacy_policy_text4] ?? "",
                    comment: ""
                ) + "\n\n" +
                NSLocalizedString(
                    privacy_policy_text5,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[privacy_policy_text5] ?? "",
                    comment: ""
                ) + "\n\n" +
                NSLocalizedString(
                    privacy_policy_text6,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[privacy_policy_text6] ?? "",
                    comment: ""
                ).replacingOccurrences(of: NSLocalizedString(
                    privacy_policy_text6_key,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[privacy_policy_text6_key] ?? "",
                    comment: ""
                ), with: ""),
            linkText: NSLocalizedString(
                privacy_policy_text6_key,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[privacy_policy_text6_key] ?? "",
                comment: ""
            ),
            linkurl: UserDefaults.standard.string(forKey: privacyUrlKey) ?? privacyLink,
            middleText: "\n\n" + NSLocalizedString(
                privacy_policy_text7,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[privacy_policy_text7] ?? "",
                comment: ""
            ) + "\n\n" +
                NSLocalizedString(
                    privacy_policy_text8,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[privacy_policy_text8] ?? "",
                    comment: ""
                ) + "\n\n" +
                NSLocalizedString(
                    privacy_policy_text9,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[privacy_policy_text9] ?? "",
                    comment: ""
                ).replacingOccurrences(of: NSLocalizedString(
                    privacy_policy_text9_key,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[privacy_policy_text9] ?? "",
                    comment: ""
                ), with: ""),
            secondLinkText: NSLocalizedString(
                privacy_policy_text9_key,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[privacy_policy_text9_key] ?? "",
                comment: ""
            ),
            secondLinkurl: UserDefaults.standard.string(forKey: faqUrlKey) ?? privacyFaqLink,
            secondMiddleText: "\n\n" + NSLocalizedString(
                privacy_policy_text10,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[privacy_policy_text10] ?? "",
                comment: ""
            ).replacingOccurrences(of: ".", with: " ") ,
            firstEmailLink: UserDefaults.standard.string(forKey: helpEmailKey) ?? "help@example.com",
            endText: ".\n\n" +
                NSLocalizedString(
                    privacy_policy_text11,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[privacy_policy_text11] ?? "",
                    comment: ""
                ) + "\n\n" + NSLocalizedString(
                    privacy_policy_text12,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[privacy_policy_text12] ?? "",
                    comment: ""
                ),
            secondEmailLink: UserDefaults.standard.string(forKey: helpEmailKey) ?? "help@example.com"
        )
        detailMessageLabel1.isScrollEnabled = false
        detailMessageLabel1.isEditable = false

        let privacyPolicyOnlineButton = UIButton()
        newView.addSubview(privacyPolicyOnlineButton)

        privacyPolicyOnlineButton.translatesAutoresizingMaskIntoConstraints = false
        privacyPolicyOnlineButton.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        privacyPolicyOnlineButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        privacyPolicyOnlineButton.topAnchor.constraint(equalTo: detailMessageLabel1.bottomAnchor, constant: 10).isActive = true
        privacyPolicyOnlineButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        privacyPolicyOnlineButton.setTitle(
            NSLocalizedString(
                privacyPolicyButtonText,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[privacyPolicyButtonText] ?? "",
                comment: ""
            ),
            for: .normal
        )
        privacyPolicyOnlineButton.titleLabel?.font = bigButtonFont
        privacyPolicyOnlineButton.setTitleColor(privacyButtonColor, for: .normal)
        privacyPolicyOnlineButton.addTarget(self, action: #selector(privacyPolicyOnlineButtonAction(_:)), for: .touchUpInside)
        privacyPolicyOnlineButton.layer.borderWidth = 1.0
        privacyPolicyOnlineButton.layer.borderColor = privacyButtonColor.cgColor

        let faqButton = UIButton()
        newView.addSubview(faqButton)

        faqButton.translatesAutoresizingMaskIntoConstraints = false
        faqButton.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        faqButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        faqButton.topAnchor.constraint(equalTo: privacyPolicyOnlineButton.bottomAnchor, constant: 10).isActive = true
        faqButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        faqButton.setTitle(
            NSLocalizedString(
                privacyFaqButtonText,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[privacyFaqButtonText] ?? "",
                comment: ""
            ),
            for: .normal
        )
        faqButton.titleLabel?.font = bigButtonFont
        faqButton.setTitleColor(privacyButtonColor, for: .normal)
        faqButton.addTarget(self, action: #selector(faqButtonAction(_:)), for: .touchUpInside)
        faqButton.layer.borderWidth = 1.0
        faqButton.layer.borderColor = privacyButtonColor.cgColor

        newView.addSubview(iAgreeCheckbox)
        iAgreeCheckbox.isSelected = false
        iAgreeCheckbox.setImage(UIImage(named: privacyUnchecked), for: .normal)
        iAgreeCheckbox.setImage(UIImage(named: privacyChecked), for: .selected)
        iAgreeCheckbox.imageView?.contentMode = .scaleAspectFit
        iAgreeCheckbox.translatesAutoresizingMaskIntoConstraints = false
        iAgreeCheckbox.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        iAgreeCheckbox.widthAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true
        iAgreeCheckbox.heightAnchor.constraint(equalToConstant: CGFloat(32)).isActive = true
        iAgreeCheckbox.topAnchor.constraint(equalTo: faqButton.bottomAnchor, constant: 20).isActive = true
        iAgreeCheckbox.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        iAgreeCheckbox.addTarget(self, action: #selector(iAgreeCheckboxChanged), for: .touchUpInside)

        let iAgreeLabel = UILabel()
        newView.addSubview(iAgreeLabel)
        iAgreeLabel.translatesAutoresizingMaskIntoConstraints = false
        iAgreeLabel.leadingAnchor.constraint(equalTo: iAgreeCheckbox.trailingAnchor, constant: 20).isActive = true
        iAgreeLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        iAgreeLabel.topAnchor.constraint(equalTo: faqButton.bottomAnchor, constant: 20).isActive = true
        iAgreeLabel.centerYAnchor.constraint(equalTo: iAgreeCheckbox.centerYAnchor).isActive = true

        iAgreeLabel.setLabel(
            with: privacyIAgreeLabelText,
            using: .body
        )
        iAgreeLabel.textAlignment = .left

        if let versionLabelString = versionLabelString {
            let versionLabel = UILabel()
            newView.addSubview(versionLabel)
            versionLabel.translatesAutoresizingMaskIntoConstraints = false
            versionLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
            versionLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
            versionLabel.topAnchor.constraint(equalTo: iAgreeLabel.bottomAnchor, constant: 20).isActive = true

            versionLabel.setLabel(
                with: versionLabelString,
                using: .body
            )

            newView.bottomAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 20).isActive = true
        } else {
            newView.bottomAnchor.constraint(equalTo: iAgreeLabel.bottomAnchor, constant: 20).isActive = true
        }
    }
}
