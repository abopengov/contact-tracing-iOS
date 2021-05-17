import Foundation

enum AppData {
    private static let lastWhatsNewKey = "last_whats_new_seen"

    static var userHasSeenWhatsNew: Bool {
        get {
            let lastWhatsNewSeen = UserDefaults.standard.string(forKey: lastWhatsNewKey)
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            return lastWhatsNewSeen == appVersion
        }
        set {
            if (newValue) {
                let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                UserDefaults.standard.setValue(appVersion, forKey: lastWhatsNewKey)
            } else {
                UserDefaults.standard.removeObject(forKey: lastWhatsNewKey)
            }
        }
    }
}
