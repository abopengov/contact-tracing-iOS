import Foundation
import UIKit
import WebKit

class MapView: UIView {
    @IBOutlet private var mapHeaderLabel: UILabel!
    @IBOutlet private var mapMessageLabel: UILabel!
    @IBOutlet private var mapListToggle: UISegmentedControl!
    @IBOutlet private var mapWebView: WKWebView!
    var mapViewUrlString: String?
    var mapViewIsCurrent: Bool = true
    override func layoutSubviews() {
        super.layoutSubviews()
        mapHeaderLabel.textAlignment = .left
        mapMessageLabel.textAlignment = .left
        mapHeaderLabel.setLabel(
            with: mapHeaderLabelString,
            using: .h2
        )
        mapMessageLabel.setLabel(
            with: mapMessageLabelString,
            using: .body
        )
        mapListToggle.setTitle(
            NSLocalizedString(
                mapToggleMapOption,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[mapToggleMapOption] ?? "",
                comment: ""
            ),
            forSegmentAt: 0
        )
        mapListToggle.setTitle(
            NSLocalizedString(
                mapToggleListOption,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[mapToggleListOption] ?? "",
                comment: ""
            ),
            forSegmentAt: 1
        )
    }

    @IBAction private func switchView(_ sender: Any) {
        if (mapViewIsCurrent) {
            let cssStyle = """
                javascript:(function() {
                    document.querySelector('[id^="htmlwidget-"]').style.display='none'
                    document.getElementById('goa-grid10032').style.display='none'
                    document.getElementById('list-of-active-cases-by-region').style.display='block'
                    document.getElementById('list-of-active-cases-by-region').style.margin='-150px auto auto auto'
                    document.getElementById('goa-band10030').style.padding='0px'

                })()
            """
            let cssScript = WKUserScript(source: cssStyle, injectionTime: .atDocumentEnd, forMainFrameOnly: false)

            mapWebView.configuration.userContentController.addUserScript(cssScript)
            mapWebView.reload()
        } else {
            let cssStyle = """
                javascript:(function() {
                    document.querySelector('[id^="htmlwidget-"]').style.display='block'
                    document.getElementById('goa-grid10032').style.display='block'
                    document.getElementById('list-of-active-cases-by-region').style.display='none'
                    document.getElementById('goa-band10030').style.padding='0px'
                })()
            """
            let cssScript = WKUserScript(source: cssStyle, injectionTime: .atDocumentEnd, forMainFrameOnly: false)

            mapWebView.configuration.userContentController.addUserScript(cssScript)
            mapWebView.reload()
        }

        mapViewIsCurrent = !mapViewIsCurrent
    }
}
extension MapView {
    private func loadWebView() {
        guard let  mapViewUrlString = mapViewUrlString,
            let url = URL(string: mapViewUrlString) else {
            return
        }
        mapWebView.load(URLRequest(url: url))
        mapWebView.allowsBackForwardNavigationGestures = true
        mapWebView.scrollView.bounces = true

        let cssStyle = """
            javascript:(function() {
                document.querySelector('[id^="htmlwidget-"]').style.display='block'
                document.getElementById('goa-grid10032').style.display='block'
                document.getElementById('list-of-active-cases-by-region').style.display='none'
                document.getElementById('goa-band10030').style.padding='0px'
            })()
        """
        let cssScript = WKUserScript(source: cssStyle, injectionTime: .atDocumentEnd, forMainFrameOnly: false)

        mapWebView.configuration.userContentController.addUserScript(cssScript)
    }
}
extension MapView: MapViewDelegate {
    func updateMapWebView(_ urlString: String) {
        mapViewUrlString = urlString
        loadWebView()
    }
}
