import IBMMobileFirstPlatformFoundation
import UIKit
import WebKit

class GuidanceViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    private var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let guidanceUrl = UserDefaults.standard.string(forKey: guidanceKey),
            !guidanceUrl.isEmpty,
            let url = URL(string: guidanceUrl) else {
            present(AlertViewControllerEnum.setUpAlertVC(), animated: true, completion: nil)
            return
        }

        refreshControl.addTarget(self, action: #selector(webViewPullToRefreshHandler), for: UIControl.Event.valueChanged)

        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        navigationController?.navigationBar.isHidden = true
        webView.scrollView.addSubview(refreshControl)
        webView.scrollView.bounces = true
        webView.navigationDelegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.reload()
    }

    @objc
    func webViewPullToRefreshHandler(source: UIRefreshControl) {
        guard let url = webView.url else {
            source.endRefreshing()
            return
        }
        webView.load(URLRequest(url: url))
    }
}

extension GuidanceViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        refreshControl.endRefreshing()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation, withError error: Error) {
        refreshControl.endRefreshing()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation, withError error: Error) {
        refreshControl.endRefreshing()
    }
}
