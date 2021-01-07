import UIKit
import CoreData
import CoreBluetooth

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    let locationManager: CLLocationManager

    private let rangeForBeacon: UUID = BluetraceConfig.rangeForBeaconUUID ?? UUID(uuidString: "c3ec6985-7444-4e22-8c44-1233456454")!

    override init() {
        self.locationManager = CLLocationManager()
    }

    func turnOn() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = CLLocationDistanceMax
        locationManager.allowsBackgroundLocationUpdates = true
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = false
        }

        // Start beacon ranging
        self.start()
    }

    func isLocationAuthorized() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted, .notDetermined:
            return false
        case .authorizedAlways:
            return true
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestLocation()
            return true
        }
    }

    func start() {
        if #available(iOS 13.0, *) {
            locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: rangeForBeacon))
        } else {
            let beaconRegion = CLBeaconRegion(proximityUUID: rangeForBeacon, identifier: rangeForBeacon.uuidString)
            locationManager.startRangingBeacons(in: beaconRegion)
        }
    }

    func stop() {
        locationManager.stopUpdatingLocation()
        // Stop beacon ranging
        if #available(iOS 13.0, *) {
            locationManager.stopRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: rangeForBeacon))
        } else {
            let beaconRegion = CLBeaconRegion(proximityUUID: rangeForBeacon, identifier: rangeForBeacon.uuidString)
            locationManager.stopRangingBeacons(in: beaconRegion)
        }
    }
}
