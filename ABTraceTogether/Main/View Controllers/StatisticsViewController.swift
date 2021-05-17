import UIKit
import WebKit

class StatisticsViewController: UIViewController {
    @IBOutlet private var caseHighlightsLabel: UILabel!
    @IBOutlet private var caseSummaryWebView: WKWebView!
    @IBOutlet private var seeAllStatsButton: UIButton!
    @IBOutlet private var webViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet private var errorLabelHeightAnchor: NSLayoutConstraint!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        caseHighlightsLabel.setLabel(
            with: statsCaseHighlights,
            using: .blackTitleText
        )

        errorLabel.setLabel(
            with: failedToLoadData,
            using: .grayCenterText
        )

        seeAllStatsButton.setButton(with: statsSeeAllStats, and: .clickout)

        caseSummaryWebView.navigationDelegate = self
        caseSummaryWebView.scrollView.delegate = self
        caseSummaryWebView.scrollView.isScrollEnabled = false

        webViewHeightAnchor.constant = calculateDefaultContentHeight()

        loadWebView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.caseSummaryWebView.isHidden = false
        self.errorLabel.isHidden = true
        self.activityIndicator.startAnimating()
        self.caseSummaryWebView.reloadFromOrigin()
    }

    @IBAction private func seeAllStatsButtonTapped(_ sender: Any) {
        if let url = URL(string: statisticsLink) {
            UIApplication.shared.open(url)
        }
    }

    private func calculateDefaultContentHeight() -> CGFloat {
        CGFloat(view.frame.height - caseHighlightsLabel.frame.height - seeAllStatsButton.frame.height - UIApplication.shared.statusBarFrame.size.height - 120)
    }
}

extension StatisticsViewController: WKNavigationDelegate {
    // ignoring swiftlint on these functions as they are the exact definitions from apple
    // swiftlint:disable implicitly_unwrapped_optional
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.errorLabel.isHidden = false
            self.errorLabelHeightAnchor.constant = self.calculateDefaultContentHeight()
            self.caseSummaryWebView.isHidden = true
        }

        self.activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.webViewHeightAnchor.constant = webView.scrollView.contentSize.height
            self.activityIndicator.stopAnimating()
        }
    }
}

extension StatisticsViewController: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(
        _ scrollView: UIScrollView,
        with view: UIView?
    ) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}

// MARK: - helpers
extension StatisticsViewController {
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
        guard let url = URL(string: caseSummaryLink) else {
            return
        }

        caseSummaryWebView.load(URLRequest(url: url))
        caseSummaryWebView.allowsBackForwardNavigationGestures = true
        caseSummaryWebView.scrollView.bounces = true
        deleteDoubleTap(web: caseSummaryWebView)
    }
}
