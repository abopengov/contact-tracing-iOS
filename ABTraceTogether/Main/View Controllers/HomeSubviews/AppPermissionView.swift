import UIKit

class AppPermissionView: UIView {
    @IBOutlet private var appPermissionView: UIView!
    @IBOutlet private var appPermissionHeaderLabel: UILabel!
    @IBOutlet private var appPermissionInfoButton: UIButton!

    @IBOutlet private var permissionEnabledView: UIView!
    @IBOutlet private var permissionEnabledLabel: UILabel!
    @IBOutlet private var permissionEnabledStatusImageView: UIImageView!

    @IBOutlet private var bluetoothEnabledView: UIView!
    @IBOutlet private var bluetoothEnabledLabel: UILabel!
    @IBOutlet private var bluetoothEnabledStatusImageView: UIImageView!

    @IBOutlet private var pushNotificationView: UIView!
    @IBOutlet private var pushNotificationLabel: UILabel!
    @IBOutlet private var pushNotificationStatusImageView: UIImageView!

    @IBOutlet private var locationPermissionView: UIView!
    @IBOutlet private var locationPermissionLabel: UILabel!
    @IBOutlet private var locationPermissionStatusImageView: UIImageView!

    weak var homeViewControllerDelegate: HomeViewControllerDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()

        appPermissionHeaderLabel.setLabel(
            with: homeAppPermissionsHeader,
            using: .h2
        )
        appPermissionHeaderLabel.textAlignment = .left

        HomeScreenEnum.setUpHomeBackgroundDesign(view: permissionEnabledView)
        HomeScreenEnum.setUpHomeBackgroundDesign(view: bluetoothEnabledView)
        HomeScreenEnum.setUpHomeBackgroundDesign(view: pushNotificationView)
        HomeScreenEnum.setUpHomeBackgroundDesign(view: locationPermissionView)
    }
    @IBAction private func appPermissionInfoButtonPressed(_ sender: Any) {
       #if DEBUG
       homeViewControllerDelegate?.presentDebugMode("HomeToDebugSegue")
       #else
        let errorAlert = UIAlertController(
            title: NSLocalizedString(
                homePermissionsTitle,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[homePermissionsTitle] ?? "",
                comment: ""
            ),
            message: NSLocalizedString(
                homePermissionsMessage,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[homePermissionsMessage] ?? "",
                comment: ""
            ),
            preferredStyle: .alert
        )
        errorAlert.addAction(
            UIAlertAction(
                title: NSLocalizedString(
                    homePermissionsDone,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[homePermissionsDone] ?? "",
                    comment: ""
                ),
                style: .default,
                handler: nil
            )
        )
        homeViewControllerDelegate?.presentViewController(errorAlert)
       #endif
    }
}

extension AppPermissionView: AppPermissionDelegate {
    func setPermisttionStatus(_ off: Bool) {
        permissionEnabledLabel.textAlignment = .left
        if off {
            permissionEnabledLabel.setLabel(
                with: homePermissionsEnabledNo,
                using: .body
            )
            permissionEnabledStatusImageView.image = UIImage(named: homeStatusIconOff)
        } else {
            permissionEnabledLabel.setLabel(
                with: homePermissionsEnabledYes,
                using: .body
            )
            permissionEnabledStatusImageView.image = UIImage(named: homeStatusIconOn)
        }
    }

    func setBlueToothEnabledStatus(_ off: Bool) {
        bluetoothEnabledLabel.textAlignment = .left
        if off {
            bluetoothEnabledLabel.setLabel(
                with: homeBluetoothEnabledNo,
                using: .body
            )
            bluetoothEnabledStatusImageView.image = UIImage(named: homeStatusIconOff)
        } else {
            bluetoothEnabledLabel.setLabel(
                with: homeBluetoothEnabledYes,
                using: .body
            )
            bluetoothEnabledStatusImageView.image = UIImage(named: homeStatusIconOn)
        }
    }

    func setPushNotificationStatus(_ off: Bool) {
        pushNotificationLabel.textAlignment = .left
        if off {
            pushNotificationLabel.setLabel(
                with: homePushNotificationsEnabledNo,
                using: .body
            )
            pushNotificationStatusImageView.image = UIImage(named: homeStatusIconOff)
        } else {
            pushNotificationLabel.setLabel(
                with: homePushNotificationsEnabledYes,
                using: .body
            )
            pushNotificationStatusImageView.image = UIImage(named: homeStatusIconOn)
        }
    }

    func setLocationServicesStatus(_ off: Bool) {
        locationPermissionLabel.textAlignment = .left
        if off {
            locationPermissionLabel.setLabel(
                with: homeLocationPermissionsEnabledNo,
                using: .body
            )
            locationPermissionStatusImageView.image = UIImage(named: homeStatusIconOff)
        } else {
            locationPermissionLabel.setLabel(
                with: homeLocationPermissionsEnabledYes,
                using: .body
            )
            locationPermissionStatusImageView.image = UIImage(named: homeStatusIconOn)
        }
    }
}
