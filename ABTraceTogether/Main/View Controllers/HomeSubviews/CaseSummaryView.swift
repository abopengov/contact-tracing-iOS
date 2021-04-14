import UIKit
import WebKit

class CaseSummaryView: UIView {
    @IBOutlet private var caseSummaryHeaderLabel: UILabel!
    @IBOutlet private var updatedLabel: UILabel!
    @IBOutlet private var caseSummaryWebView: WKWebView!
    @IBOutlet private var caseSummarySeeAllStatsButton: UIButton!
    var caseSummaryURLString: String?
    weak var homeViewControllerDelegate: HomeViewControllerDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()
        caseSummaryWebView.navigationDelegate = self
        caseSummaryWebView.scrollView.delegate = self
        caseSummaryWebView.scrollView.isScrollEnabled = false
        caseSummaryHeaderLabel.setLabel(
            with: homeCaseSummaryHeader,
            using: .h2
        )
        caseSummarySeeAllStatsButton.setButton(
            with: homeCaseSummaryButton,
            and: .arrow
        )
    }

    @IBAction private func caseSummarySeeAllStatsButtonPressed(_ sender: Any) {
        homeViewControllerDelegate?.switchTab(.stats)
    }
}

extension CaseSummaryView: WKNavigationDelegate {
    // ignoring swiftlint on these functions as they are the exact definitions from apple
    // swiftlint:disable implicitly_unwrapped_optional
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        homeViewControllerDelegate?.hideCaseSummaryView(true)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        homeViewControllerDelegate?.hideCaseSummaryView(true)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        homeViewControllerDelegate?.hideCaseSummaryView(false)
        webView.evaluateJavaScript("document.body.scrollHeight") { height, _ in
            if let height = height {
                UserDefaults.standard.set(height, forKey: "caseSummaryWebViewKey")
            }
        }
        caseSummaryWebView.frame.size.height = 1
        caseSummaryWebView.frame.size = webView.scrollView.contentSize
    }
}

extension CaseSummaryView: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(
        _ scrollView: UIScrollView,
        with view: UIView?
    ) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}

// MARK: - helpers
extension CaseSummaryView {
    private func deleteDoubleTap(web: WKWebView) {
        for subview in web.scrollView.subviews {
            let recognizers = subview.gestureRecognizers?.filter {
                $0 is UITapGestureRecognizer
            }
            recognizers?.forEach {recognizer in
                let tapRecognizer = recognizer as! UITapGestureRecognizer
                if tapRecognizer.numberOfTapsRequired == 2 && tapRecognizer.numberOfTouchesRequired == 1 {
                    subview.removeGestureRecognizer(recognizer)
                }
            }
        }
    }

    private func loadWebView() {
        guard let  caseSummaryURLString = caseSummaryURLString,
            let url = URL(string: caseSummaryURLString) else {
            return
        }

        caseSummaryWebView.load(URLRequest(url: url))
        caseSummaryWebView.allowsBackForwardNavigationGestures = true
        caseSummaryWebView.scrollView.bounces = true
        deleteDoubleTap(web: caseSummaryWebView)
    }
}
extension CaseSummaryView: CaseSummaryViewDelegate {
    func updateCaseSummaryView(_ urlString: String) {
        caseSummaryURLString = urlString
        loadWebView()
    }
}
