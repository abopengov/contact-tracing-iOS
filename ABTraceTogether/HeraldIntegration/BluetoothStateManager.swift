import CoreBluetooth
import Foundation
import Herald
import UIKit

class BluetoothStateManager {
    static let shared = BluetoothStateManager()

    var bleSensorState: SensorState?
    var bleSensorStateUpdated: ((SensorState) -> Void)?
    var cbManager: CBCentralManager?

    func requestBluetoothPermissions() {
        cbManager = CBCentralManager()
    }

    func isBluetoothOn() -> Bool {
        guard let bleSensorState = bleSensorState else {
            return cbManager?.state == CBManagerState.poweredOn
        }
        return bleSensorState == SensorState.on
    }

    func isBluetoothAuthorized() -> Bool {
        if #available(iOS 13.1, *) {
            return CBManager.authorization == .allowedAlways
        } else {
            return CBPeripheralManager.authorizationStatus() == .authorized
        }
    }

    private func presentBluetoothStatusLocalNotification() {
        if !UserDefaults.standard.bool(forKey: "sentBluetoothStatusNotif") {
            UserDefaults.standard.set(true, forKey: "sentBluetoothStatusNotif")
            let btStatusMagicNumber = Int.random(in: 0 ... PushNotificationConstants.btStatusPushNotifContents.count - 1)
            BlueTraceLocalNotifications.shared.triggerIntervalLocalPushNotifications(pnContent: PushNotificationConstants.btStatusPushNotifContents[btStatusMagicNumber], identifier: "bluetoothStatusNotifId")
        }
    }

    private func displayBluetoothErrorState(state: SensorState) {
        switch state {
        case .off:
            presentBluetoothStatusLocalNotification()

        case .unavailable:
            presentBluetoothAlert("Unavailable State")

        case .on:
            BlueTraceLocalNotifications.shared.removeNotificationWithIdentifier("bluetoothStatusNotifId")
        }
    }

    private func presentBluetoothAlert(_ bluetoothStateString: String) {
        #if DEBUG
        let alert = UIAlertController(
            title: "Bluetooth Issue: " + bluetoothStateString + " on " + DeviceInfo.getModel() + " iOS: " + UIDevice.current.systemVersion,
            message: "Please screenshot this message and send to support!",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        DispatchQueue.main.async {
            var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
            while topController?.presentedViewController != nil {
                topController = topController?.presentedViewController
            }

            topController?.present(alert, animated: true)
        }
        #endif

        #if RELEASE
        let alert = UIAlertController(title: "Please turn on your bluetooth", message: "This application requires Bluetooth to be activated to protect you and your loved ones. Please turn on Bluetooth in your iOS settings, then reopen ABTraceTogether.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
            while topController?.presentedViewController != nil {
                topController = topController?.presentedViewController
            }

            if topController?.isKind(of: UIAlertController.self) == true {
                print("Alert has already popped up!")
            } else {
                topController?.present(alert, animated: true)
            }
        }
        #endif
    }
}

extension BluetoothStateManager: SensorDelegate {
    func sensor(_ sensor: SensorType, didUpdateState: SensorState) {
        if sensor == SensorType.BLE {
            bleSensorState = didUpdateState
            bleSensorStateUpdated?(didUpdateState)
            displayBluetoothErrorState(state: didUpdateState)
        }
    }
}
