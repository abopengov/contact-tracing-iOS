import Foundation
import SafariServices
import UIKit

class MainTabBarController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let items = tabBar.items {
            // Setting the title text color of all tab bar items:
            for item in items {
                item.image = item.image?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                item.setTitleTextAttributes(
                    [
                        .foregroundColor: UIColor(
                            red: 0.00,
                            green: 0.44,
                            blue: 0.77,
                            alpha: 1.00
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
            items[0].title = homeTabTitle.localize()
            items[1].title = statsTabTitle.localize()
            items[2].title = menuLearn.localize()
            items[3].title = menuMore.localize()
        }
    }
}
