import Foundation
import UIKit

enum NavigationUtils {
    static func gotoSettings() {
        guard let url = URL(string: "App-prefs:root=General") else {
            return
        }
        UIApplication.shared.open(url)
    }

    static func gotoAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url)
    }
}
