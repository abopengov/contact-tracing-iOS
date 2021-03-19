import Foundation
import UIKit
import WebKit

class MapViewController: UIViewController {
    weak var mapViewDelegate: MapViewDelegate?
    var mapView: UIView? {
        guard let mapViewNibView = getView("MapView") as? MapView else {
            return nil
        }
        mapViewNibView.backgroundColor = homeScreenBackgroundColor
        mapViewDelegate = mapViewNibView
        return mapViewNibView
    }

    private func getView(_ viewName: String) -> UIView? {
        guard let nib = Bundle.main.loadNibNamed(viewName, owner: self),
            let view = nib.first as? UIView else {
            return nil
        }
        return view
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let gisUrl = UserDefaults.standard.string(forKey: gisKey),
            !gisUrl.isEmpty else {
            present(AlertViewControllerEnum.setUpAlertVC(), animated: true, completion: nil)
            return
        }
        if let mapView = mapView {
            view.addSubview(mapView)
        }
        passGisUrl(gisUrl)
    }
    @objc
    func passGisUrl(_ urlString: String) {
        mapViewDelegate?.updateMapWebView(urlString)
    }
}
