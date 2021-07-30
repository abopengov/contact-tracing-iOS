import SafariServices
import WebKit
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

    var webView: WKWebView?
    var privacyVersion: Int?
    let privacyManager = PrivacyManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        generatePrivacyViews(in: contentView)

        privacyManager.getPrivacyPolicy { [weak self] (privacy, version) in
            if let privacy = privacy, let version = version {
                self?.privacyVersion = version
                self?.webView?.loadHTMLString(privacy, baseURL: nil)
            }
        }

        privacyConcented = false
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
        bottomButton.addTarget(self, action: #selector(nextAction(_:)), for: .touchUpInside)
    }
    
    @objc
    private func nextAction(_ sender: UIButton) {
        if let privacyVersion = privacyVersion {
            privacyManager.acceptPrivacyPolicy(version: privacyVersion)
        }
        buttonAction(sender)
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

        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        newView.addSubview(webView)
        webView.topAnchor.constraint(equalTo: newView.topAnchor, constant: 20).isActive = true
        webView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        webView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true

        self.webView = webView

        let privacyPolicyOnlineButton = UIButton()
        newView.addSubview(privacyPolicyOnlineButton)

        privacyPolicyOnlineButton.translatesAutoresizingMaskIntoConstraints = false
        privacyPolicyOnlineButton.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        privacyPolicyOnlineButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        privacyPolicyOnlineButton.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 10).isActive = true
        privacyPolicyOnlineButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        privacyPolicyOnlineButton.setButton(with: privacyPolicyButtonText, buttonStyle: .secondary)
        privacyPolicyOnlineButton.titleLabel?.font = bigButtonFont
        privacyPolicyOnlineButton.addTarget(self, action: #selector(privacyPolicyOnlineButtonAction(_:)), for: .touchUpInside)

        let faqButton = UIButton()
        newView.addSubview(faqButton)

        faqButton.translatesAutoresizingMaskIntoConstraints = false
        faqButton.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        faqButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        faqButton.topAnchor.constraint(equalTo: privacyPolicyOnlineButton.bottomAnchor, constant: 10).isActive = true
        faqButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        faqButton.setButton(with: privacyFaqButtonText, buttonStyle: .secondary)
        faqButton.addTarget(self, action: #selector(faqButtonAction(_:)), for: .touchUpInside)

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

extension PrivacyViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange) -> Bool {
        if url.scheme == "http" || url.scheme == "https" {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
            return false
        } else {

            return true
        }
    }
}

extension PrivacyViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            webView.heightAnchor.constraint(equalToConstant: webView.scrollView.contentSize.height).isActive = true
        }
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        if url.scheme == "http" || url.scheme == "https" {
            decisionHandler(.cancel)

            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        } else if (url.scheme == "mailto") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }}
