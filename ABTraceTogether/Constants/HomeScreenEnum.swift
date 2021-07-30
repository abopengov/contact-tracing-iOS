import Foundation
import IBMMobileFirstPlatformFoundation
import UIKit

enum HomeScreenEnum {
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
