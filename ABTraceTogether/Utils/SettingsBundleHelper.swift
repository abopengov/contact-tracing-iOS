import UIKit

enum SettingsBundleHelper {
    enum SettingsBundleKeys {
        static let AppVersionKey = "version_preference"
    }

    static func setVersionAndBuildNumber() {
        let version = UIApplication.appVersion
        UserDefaults.standard.set(version, forKey: "version_preference")
    }
}
