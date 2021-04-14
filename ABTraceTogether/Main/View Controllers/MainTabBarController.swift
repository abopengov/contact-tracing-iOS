import Foundation
import SafariServices
import UIKit

class MainTabBarController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let items = tabBar.items {
            // Setting the title text color of all tab bar items:
            for item in items {
                item.setTitleTextAttributes(
                    [
                        .foregroundColor: UIColor(
                            red: 0.329,
                            green: 0.784,
                            blue: 0.91,
                            alpha: 1
                    )
                    ],
                    for: .selected
                )
                item.setTitleTextAttributes(
                    [
                        .foregroundColor: UIColor(
                            red: 0.325,
                            green: 0.157,
                            blue: 0.31,
                            alpha: 1
                        )
                    ],
                    for: .normal
                )
            }
            items[0].title = NSLocalizedString(
                homeTabTitle,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[homeTabTitle] ?? "",
                comment: ""
            )
            items[1].title = NSLocalizedString(
                uploadTabTitle,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[uploadTabTitle] ?? "",
                comment: ""
            )
            items[2].title = NSLocalizedString(
                faqTabTitle,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[faqTabTitle] ?? "",
                comment: ""
            )
            items[3].title = NSLocalizedString(
                guidanceTabTitle,
                tableName: "",
                bundle: BKLocalizationManager.sharedInstance.currentBundle,
                value: BKLocalizationManager.sharedInstance.defaultStrings[guidanceTabTitle] ?? "",
                comment: ""
            )
        }
    }
}
