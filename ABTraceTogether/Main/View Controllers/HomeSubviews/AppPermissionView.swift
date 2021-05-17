import UIKit

class AppPermissionView: UIView {
    weak var homeViewControllerDelegate: HomeViewControllerDelegate?

    @IBOutlet private var bluetoothPermissionLabel: UILabel!
    @IBOutlet private var bluetoothPermissionStatusLabel: UILabel!
    @IBOutlet private var bluetoothPermissionIcon: UIImageView!
    @IBOutlet private var locationPermissionLabel: UILabel!
    @IBOutlet private var locationPermissionStatusLabel: UILabel!
    @IBOutlet private var locationPermissionIcon: UIImageView!
    @IBOutlet private var pushPermissionLabel: UILabel!
    @IBOutlet private var pushPermissionStatusLabel: UILabel!
    @IBOutlet private var pushPermissionIcon: UIImageView!
    @IBOutlet private var pushPermissionView: UIView!
    @IBOutlet private var pushPermissionInstructionsView: UIView!
    @IBOutlet private var pushPermissionInstructionsStep1Label: UILabel!
    @IBOutlet private var pushPermissionInstructionsStep2Label: UILabel!
    @IBOutlet private var gotoAppSettingsButton: UIButton!
    @IBOutlet private var pushPermissionInstructionTopBorder: UIView!
    @IBOutlet private var pushPermissionInstructionBottomBorder: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()

        pushPermissionLabel.textAlignment = .left
        pushPermissionLabel.setLabel(
            with: homeNotificationPermission,
            using: .boldBodyText
        )
        pushPermissionInstructionsStep1Label.setLabel(with: homeNotificationPermissionStep1, using: .blackDescriptionText)
        pushPermissionInstructionsStep2Label.setLabel(with: homeNotificationPermissionStep2, using: .blackDescriptionText)

        gotoAppSettingsButton.setButton(with: homeGotoAppSettings, and: .secondaryClickout, buttonStyle: .secondaryMedium)
    }

    @IBAction private func gotoAppSettingsButtonTapped(_ sender: Any) {
        NavigationUtils.gotoAppSettings()
    }
}

extension AppPermissionView: AppPermissionDelegate {
    func setBluetoothEnabledStatus(_ off: Bool) {
        bluetoothPermissionLabel.textAlignment = .left
        bluetoothPermissionLabel.setLabel(
            with: homeBluetoothPermission,
            using: .boldBodyText
        )
        if off {
            bluetoothPermissionStatusLabel.setLabel(
                with: disabled,
                using: .body
            )
            bluetoothPermissionIcon.image = UIImage(named: homeStatusIconOff)
        } else {
            bluetoothPermissionStatusLabel.setLabel(
                with: enabled,
                using: .body
            )
            bluetoothPermissionIcon.image = UIImage(named: homeStatusIconOn)
        }
    }

    func setPushNotificationStatus(_ off: Bool) {
        pushPermissionInstructionsView.isHidden = !off
        pushPermissionInstructionTopBorder.isHidden = !off
        pushPermissionInstructionBottomBorder.isHidden = !off
        if off {
            pushPermissionStatusLabel.setLabel(
                with: disabled,
                using: .body
            )
            pushPermissionIcon.image = UIImage(named: homeStatusIconOff)
            pushPermissionView.backgroundColor = UIColor(red: 1.00, green: 0.98, blue: 0.98, alpha: 1.00)
        } else {
            pushPermissionStatusLabel.setLabel(
                with: enabled,
                using: .body
            )
            pushPermissionIcon.image = UIImage(named: homeStatusIconOn)
            pushPermissionView.backgroundColor = UIColor.white
        }
    }

    func setLocationServicesStatus(_ off: Bool) {
        locationPermissionLabel.textAlignment = .left
        locationPermissionLabel.setLabel(
            with: homeLocationPermission,
            using: .boldBodyText
        )
        if off {
            locationPermissionStatusLabel.setLabel(
                with: disabled,
                using: .body
            )
            locationPermissionIcon.image = UIImage(named: homeStatusIconOff)
        } else {
            locationPermissionStatusLabel.setLabel(
                with: enabled,
                using: .body
            )
            locationPermissionIcon.image = UIImage(named: homeStatusIconOn)
        }
    }
}
