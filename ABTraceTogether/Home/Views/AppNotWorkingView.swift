import Foundation
import UIKit

class AppNotWorkingView: UIView {
    weak var homeViewControllerDelegate: HomeViewControllerDelegate?

    @IBOutlet private var cardView: UIView!
    @IBOutlet private var appNotWorkingLabel: UILabel!
    @IBOutlet private var appNotWorkingIcon: UIImageView!
    @IBOutlet private var bufferViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var turnBluetoothOnView: UIView!
    @IBOutlet private var turnBluetoothOnLabel: UILabel!
    @IBOutlet private var turnBluetoothOnStep1Label: UILabel!
    @IBOutlet private var turnBluetoothOnStep2Label: UILabel!
    @IBOutlet private var turnBluetoothOnStep3Label: UILabel!
    @IBOutlet private var turnBluetoothOnButton: UIButton!
    @IBOutlet private var allowBluetoothPermissionView: UIView!
    @IBOutlet private var allowBluetoothPermissionLabel: UILabel!
    @IBOutlet private var allowBluetoothPermissionStep1Label: UILabel!
    @IBOutlet private var allowBluetoothPermissionStep2Label: UILabel!
    @IBOutlet private var allowBluetoothPermissionButton: UIButton!
    @IBOutlet private var allowLocationPermissionView: UIView!
    @IBOutlet private var allowLocationPermissionLabel: UILabel!
    @IBOutlet private var allowLocationPermissionStep1Label: UILabel!
    @IBOutlet private var allowLocationPermissionStep2Label: UILabel!
    @IBOutlet private var allowLocationPermissionStep3Label: UILabel!
    @IBOutlet private var allowLocationPermissionButton: UIButton!

    override func layoutSubviews() {
        super.layoutSubviews()

        bufferViewHeightConstraint.constant = UIApplication.shared.statusBarFrame.size.height
        cardView.layer.cornerRadius = 25
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cardView.layer.shadowOffset = CGSize(width: 0, height: -1)
        cardView.layer.shadowOpacity = 0.25
        cardView.layer.shadowRadius = 1

        appNotWorkingLabel.setLabel(with: homeAppIsNotWorking, using: .blackBigTitleText)
        let tapIconGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDebugScreen(_:)))
        appNotWorkingIcon.addGestureRecognizer(tapIconGestureRecognizer)
        turnBluetoothOnLabel.setLabel(with: homeTurnOnBluetoothTitle, using: .blackTitleText)
        turnBluetoothOnStep1Label.setLabel(with: homeTurnOnBluetoothStep1, using: .blackDescriptionText)
        turnBluetoothOnStep2Label.setLabel(with: homeTurnOnBluetoothStep2, using: .blackDescriptionText)
        turnBluetoothOnStep3Label.setLabel(with: homeTurnOnBluetoothStep3, using: .blackDescriptionText)
        allowBluetoothPermissionLabel.setLabel(with: homeBluetoothPermissionTitle, using: .blackTitleText)
        allowBluetoothPermissionStep1Label.setLabel(with: homeBluetoothPermissionStep1, using: .blackDescriptionText)
        allowBluetoothPermissionStep2Label.setLabel(with: homeBluetoothPermissionStep2, using: .blackDescriptionText)
        allowLocationPermissionLabel.setLabel(with: homeLocationPermissionTitle, using: .blackTitleText)
        allowLocationPermissionStep1Label.setLabel(with: homeLocationPermissionStep1, using: .blackDescriptionText)
        allowLocationPermissionStep2Label.setLabel(with: homeLocationPermissionStep2, using: .blackDescriptionText)
        allowLocationPermissionStep3Label.setLabel(with: homeLocationPermissionStep3, using: .blackDescriptionText)

        turnBluetoothOnButton.setButton(with: homeGotoSettings, and: .secondaryClickout, buttonStyle: .settings)
        allowBluetoothPermissionButton.setButton(with: homeGotoAppSettings, and: .secondaryClickout, buttonStyle: .settings)
        allowLocationPermissionButton.setButton(with: homeGotoAppSettings, and: .secondaryClickout, buttonStyle: .settings)
    }

    @IBAction private func turnOnBluetoothButtonTapped(_ sender: Any) {
        NavigationUtils.gotoSettings()
    }

    @IBAction private func allowBluetoothPermissionButtonTapped(_ sender: Any) {
        NavigationUtils.gotoAppSettings()
    }

    @IBAction private func allowLocationPermissionsButtonTapped(_ sender: Any) {
        NavigationUtils.gotoAppSettings()
    }

    @objc
    private func openDebugScreen(_ sender: Any) {
        #if DEBUG
        homeViewControllerDelegate?.presentDebugMode()
        #endif
    }
}

extension AppNotWorkingView: AppNotWorkingDelegate {
    func showHowToEnableBluetooth(_ show: Bool) {
        turnBluetoothOnView.isHidden = !show
    }
    func showHowToEnableBluetoothPermission(_ show: Bool) {
        allowBluetoothPermissionView.isHidden = !show
    }
    func showHowToEnableLocationServices(_ show: Bool) {
        allowLocationPermissionView.isHidden = !show
    }
}
