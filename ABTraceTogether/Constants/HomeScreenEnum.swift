import Foundation
import IBMMobileFirstPlatformFoundation
import UIKit

enum HomeScreenEnum {
static func setUpHomeBackgroundDesign (view: UIView ) {
    view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
    view.borderWidth = 1
    view.layer.borderColor = UIColor(red: 0.847, green: 0.847, blue: 0.847, alpha: 1).cgColor
}
static func getVersionIdentifierForEnvironment() -> String {
    let devString = "mfpdev"
    let stagingString = "mfpstg"

    guard let urlHostString = WLResourceRequest(url: URL(string: "/adapters"), method: "GET")?.url.host else {
        return ""
    }

    if urlHostString.contains(stagingString) {
        return "S"
    } else if urlHostString.contains(devString) {
        return "D"
    }
    return ""
}
    static func showHomeScreen() {
        let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main")
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = mainViewController
        }
    }
}
