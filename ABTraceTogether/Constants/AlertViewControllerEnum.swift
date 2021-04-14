import Foundation
import UIKit

enum AlertViewControllerEnum {
    static func setUpAlertVC () -> UIAlertController {
        let errorAlert = UIAlertController(
            title: NSLocalizedString(
                generalErrorTitleString,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[generalErrorTitleString] ?? "",
                comment: ""
            ),
            message: NSLocalizedString(
                generalWebViewErrorMessage,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[generalWebViewErrorMessage] ?? "",
                comment: ""
            ),
            preferredStyle: .alert
        )
        errorAlert.addAction(
            UIAlertAction(
                title: NSLocalizedString(
                    generalDoneString,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[generalDoneString] ?? "",
                    comment: ""
                ),
                style: .default,
                handler: nil
            )
        )
        return errorAlert
    }
}
