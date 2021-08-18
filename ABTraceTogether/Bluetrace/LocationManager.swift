import CoreBluetooth
import CoreData
import CoreLocation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    let locationManager = CLLocationManager()
    private var requestLocationAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?

    func requestLocationAuthorization(completion: @escaping (_ granted: Bool) -> Void) {
        self.locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = false
        if #available(iOS 14.0, *) {
            locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        }
        locationManager.distanceFilter = CLLocationDistanceMax
        locationManager.allowsBackgroundLocationUpdates = true
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = false
        }

        let currentStatus = CLLocationManager.authorizationStatus()

        // Only ask authorization if it was never asked before
        guard currentStatus == .notDetermined || currentStatus == .authorizedWhenInUse else {
            completion(true)
            return
        }

        // Starting on iOS 13.4.0, to get .authorizedAlways permission, you need to
        // first ask for WhenInUse permission, then ask for Always permission to
        // get to a second system alert
        if #available(iOS 13.4, *) {
            self.requestLocationAuthorizationCallback = { status in
                if status == .authorizedWhenInUse {
                    self.locationManager.requestAlwaysAuthorization()
                } else {
                    completion(true)
                }
            }
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.locationManager.requestAlwaysAuthorization()
        }
        if (currentStatus == .authorizedWhenInUse) {
            completion(true)
        }
    }

    func isLocationAuthorized() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            return true

        default:
            return false
        }
    }

    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        self.requestLocationAuthorizationCallback?(status)
    }
    
    
}
