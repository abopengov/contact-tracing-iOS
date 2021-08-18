import GoogleMaps
import GoogleMapsUtils
import SafariServices
import UIKit

class StatsMapViewController: UIViewController {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var mapView: GMSMapView!
    @IBOutlet private var legendTitleLabel: UILabel!
    @IBOutlet private var highCountLabel: UILabel!
    @IBOutlet private var mediumCountLabel: UILabel!
    @IBOutlet private var lowCountLabel: UILabel!
    @IBOutlet private var nonCountLabel: UILabel!
    @IBOutlet private var errorLabel: UILabel!

    private var statsClient: StatsClient?

    private let highStyle = GMUStyle.createStyle(styleId: "high", fill: Colors.MapCasesHigh)
    private let mediumStyle = GMUStyle.createStyle(styleId: "medium", fill: Colors.MapCasesMedium)
    private let lowStyle = GMUStyle.createStyle(styleId: "low", fill: Colors.MapCasesLow)
    private let noneStyle = GMUStyle.createStyle(styleId: "none", fill: Colors.MapCasesNone)

    private let bounds = GMSCoordinateBounds()
        .includingCoordinate(CLLocationCoordinate2DMake(48.99, -120.00))
        .includingCoordinate(CLLocationCoordinate2DMake(60.00, -109.99))

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.setLabel(with: statsMap, using: .blackTitleText)
        legendTitleLabel.setLabel(with: statsActiveCases, using: .blackDescriptionMediumText)
        highCountLabel.setLabel(with: "100+", using: .grayText, localize: false)
        mediumCountLabel.setLabel(with: "10-99", using: .grayText, localize: false)
        lowCountLabel.setLabel(with: "1-9", using: .grayText, localize: false)
        nonCountLabel.setLabel(with: "0", using: .grayText, localize: false)

        moveMapToAlberta()
        mapView.cameraTargetBounds = bounds
        mapView.setMinZoom(mapView.camera.zoom, maxZoom: mapView.maxZoom)

        statsClient = MfpStatsClient()
        statsClient?.getMunicipalityStats { [weak self] municipalityStats in
            if let municipalityStats = municipalityStats {
                self?.renderGeoJSON(municipalityStats)
            } else {
                self?.errorLabel.isHidden = false
                self?.errorLabel.setLabel(with: errorCannotFetchData, using: .errorMediumText)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    private func moveMapToAlberta() {
        self.mapView.moveCamera(GMSCameraUpdate.fit(bounds, withPadding: 100))
    }

    private func styleForActiveCases(_ activeCases: Int?) -> GMUStyle {
        guard let activeCases = activeCases else {
            return noneStyle
        }

        switch activeCases {
        case _ where activeCases >= 100:
            return highStyle

        case _ where activeCases >= 10:
            return mediumStyle

        case _ where activeCases >= 1:
            return lowStyle

        default:
            return noneStyle
        }
    }

    private func statForFeature(_ feature: GMUGeometryContainer, municipalityStats: [MunicipalityStats]) -> MunicipalityStats? {
        municipalityStats.first { stat in
            if let feature = feature as? GMUFeature, let geoName = feature.properties?["GEONAME"] as? String {
                return stat.municipality?.caseInsensitiveCompare(geoName) == .orderedSame
            } else {
                return false
            }
        }
    }

    private func renderGeoJSON(_ municipalityStats: [MunicipalityStats]) {
        guard let path = Bundle.main.path(forResource: "ab_counties", ofType: "json") else {
            return
        }

        let url = URL(fileURLWithPath: path)
        let geoJsonParser = GMUGeoJSONParser(url: url)
        geoJsonParser.parse()

        for feature in geoJsonParser.features {
            if let stat = statForFeature(feature, municipalityStats: municipalityStats) {
                feature.style = styleForActiveCases(stat.activeCases)
            } else {
                feature.style = noneStyle
            }
        }

        let renderer = GMUGeometryRenderer(map: mapView, geometries: geoJsonParser.features)
        renderer.render()
    }
}

private extension GMUStyle {
    static func createStyle(styleId: String, fill: UIColor) -> GMUStyle {
        GMUStyle(styleID: styleId, stroke: UIColor.black, fill: fill, width: 1, scale: 1, heading: 0, anchor: CGPoint(x: 0, y: 0), iconUrl: nil, title: nil, hasFill: true, hasStroke: true)
    }
}
