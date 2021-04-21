import UIKit
import WebKit

class WhatsNewViewController: UIViewController {
    @IBOutlet private var whatsNewLabel: UILabel!
    @IBOutlet private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        AppData.userHasSeenWhatsNew = true

        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[2]
            tabItem.badgeValue = nil
        }

        if let url = Bundle.main.url(forResource: "changelog", withExtension: "html") {
            webView.load(URLRequest(url: url))
        }

        whatsNewLabel.setLabel(with: whatsNewInThisAppTitle, using: .blackTitleText)
        whatsNewLabel.attributedText = whatsNewLabel.attributedText
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}
