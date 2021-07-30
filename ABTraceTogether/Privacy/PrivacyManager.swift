import Foundation

class PrivacyManager {
    private var privacyPolicyAccepted: Int {
        get {
            UserDefaults.standard.object(forKey: "privacyPolicyVersionSeen") as? Int ?? 1
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "privacyPolicyVersionSeen")
        }
    }

    private var lastPrivacyPullTime: Date? {
        get {
            UserDefaults.standard.object(forKey: "lastPrivacyPullTime") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastPrivacyPullTime")
        }
    }

    func shouldCheckForUpdate() -> Bool {
        let hoursToDiff = 86_400 // 60*60*24

        guard let lastPullTime = lastPrivacyPullTime,
            Int(Date().timeIntervalSince(lastPullTime)) < hoursToDiff else {
            return true
        }

        return false
    }

    func checkForNewPrivacyPolicy(_ callback: @escaping (Bool) -> Void) {
        self.getPrivacyPolicy {[weak self] _, version in
            guard let version = version, let privacyPolicyAccepted = self?.privacyPolicyAccepted else {
                callback(false)
                return
            }

            let newUpdateAvailable = version > privacyPolicyAccepted

            if (!newUpdateAvailable) {
                self?.lastPrivacyPullTime = Date()
            }

            callback(newUpdateAvailable)
        }
    }

    func getPrivacyPolicy(_ callback: @escaping ((String?, Int?)) -> Void) {
        PrivacyClient().getPrivacyPolicy { [weak self] serverPrivacyPolicy in
            guard let privacyPolicy = serverPrivacyPolicy ?? self?.getDefaultPrivacyPolicy(), let newVersion = self?.parsePrivacyVersion(privacyPolicy) else {
                callback((nil, nil))
                return
            }

            callback((privacyPolicy, newVersion))
        }
    }

    func acceptPrivacyPolicy(version: Int) {
        privacyPolicyAccepted = version
        lastPrivacyPullTime = Date()
    }

    private func getDefaultPrivacyPolicy() -> String? {
        guard let path = Bundle.main.path(forResource: "privacypolicy", ofType: "html") else {
            return nil
        }

        do {
            return try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
    }

    private func parsePrivacyVersion(_ privacyPolicy: String) -> Int? {
        let pattern = "meta name=\"privacy_policy_version\" content=\"(?<version>\\d+)\">"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)

        if let match = regex?.firstMatch(in: privacyPolicy, options: [], range: NSRange(location: 0, length: privacyPolicy.utf16.count)) {
            if let versionRange = Range(match.range(withName: "version"), in: privacyPolicy) {
                return Int(privacyPolicy[versionRange])
            }
        }

        return nil
    }
}
