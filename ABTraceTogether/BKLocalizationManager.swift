import Foundation
import IBMMobileFirstPlatformFoundation
import UIKit

@objcMembers
class BKLocalizationManager: NSObject {
    private static var privateSharedInstance: BKLocalizationManager?
    static var sharedInstance = BKLocalizationManager()
    var dynamicUrl: DynamicUrl?
    var currentBundle = Bundle.main
    var defaultStrings = ["": ""]

    let manager = FileManager.default
    lazy var bundlePath: URL = {
        let documents = URL(
            fileURLWithPath: NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask,
                true
            ).first ?? Bundle.main.bundlePath
        )

        let bundlePath = documents.appendingPathComponent(
            BKLocalizable.BKBundleName,
            isDirectory: true
        )
        return bundlePath
    }()

    func setCurrentBundle(forLanguage: String) {
        if let defaultStrings = getDefaultLanguageFromLocalFile() {
            self.defaultStrings = defaultStrings
        }

        do {
            currentBundle = try returnCurrentBundleForLanguage(lang: forLanguage)
        } catch {
            currentBundle = Bundle(path: getPathForLocalLanguage(language: "en")) ?? Bundle.main
        }
    }

    func returnCurrentBundleForLanguage(lang: String) throws -> Bundle {
        if manager.fileExists(atPath: bundlePath.path) == false {
            return Bundle(path: getPathForLocalLanguage(language: lang)) ?? Bundle.main
        }

        do {
            let resourceKeys: [URLResourceKey] = [.creationDateKey, .isDirectoryKey]
            _ = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

            guard let enumerator = FileManager.default.enumerator(
                at: bundlePath ,
                includingPropertiesForKeys: resourceKeys,
                options: [.skipsHiddenFiles],
                errorHandler: { _, _ -> Bool in
                    true
                }
            ) else {
                return Bundle.main
            }
            for case let folderURL as URL in enumerator {
                _ = try folderURL.resourceValues(forKeys: Set(resourceKeys))
                if folderURL.lastPathComponent == ("\(lang).lproj") {
                guard let enumerator2 = FileManager.default.enumerator(
                    at: folderURL,
                    includingPropertiesForKeys: resourceKeys,
                    options: [.skipsHiddenFiles],
                    errorHandler: { _, _ -> Bool in
                        true
                    }
                ) else {
                    return Bundle.main
                }
                    for case let fileURL as URL in enumerator2 {
                        _ = try fileURL.resourceValues(forKeys: Set(resourceKeys))
                        if fileURL.lastPathComponent == "Localizable.strings" {
                            return Bundle(url: folderURL) ?? Bundle.main
                        }
                    }
                }
            }
        } catch {
            return Bundle(path: getPathForLocalLanguage(language: lang)) ?? Bundle.main
        }
        return Bundle(path: getPathForLocalLanguage(language: lang)) ?? Bundle.main
    }

    private func getPathForLocalLanguage(language: String) -> String {
        Bundle.main.path(forResource: language, ofType: "lproj") ?? ""
    }
}

// MARK: - Localization Loader
extension BKLocalizationManager {
    func loadLocalization() {
        if needToFetchLocalizationStringsFromServer() {
            getLocalizationContentFromServer(Locale.current.languageCode ?? "en")
        }
    }
}

// MARK: - Network fetch
extension BKLocalizationManager {
    func getLocalizationContentFromServer(_ language: String) {
        guard let getContentUrl = URL(string: "/adapters/applicationDataAdapter/getContent") else {
            return
        }
        guard let wlResourceRequest = WLResourceRequest(
            url: getContentUrl,
            method: "GET"
        ) else {
            Logger.logError(with: "Get Content Error. Error converting to wlResourceRequest. \(getContentUrl)")
            return
        }
        wlResourceRequest.queryParameters = ["lang": language]
        wlResourceRequest.send { response, error -> Void  in
            if let error = error {
                Logger.logError(with: "\(error)")
                NotificationCenter.default.post(name: Notification.Name(LanguageChangeNotification), object: nil)
            }
            guard let data = response?.responseData else {
                return
            }
            do {
                let parsedJson = try self.parseJsonData(data)
                try self.writeToBundle(with: parsedJson)
            } catch {}
        }
    }
}

extension BKLocalizationManager {
    func needToFetchLocalizationStringsFromServer() -> Bool {
        let hoursToDiff = 86_400 // 60*60*24
        let currentLanguage = Locale.current.languageCode

        guard let lastLanguage = UserDefaults.standard.object(forKey: "lastLanguage") as? String,
            currentLanguage == lastLanguage else {
            UserDefaults.standard.set(currentLanguage, forKey: "lastLanguage")
            return true
        }

        guard let lastPullTime = UserDefaults.standard.object(forKey: "lastPullTime") as? Date,
            Int(Date().timeIntervalSince(lastPullTime)) < hoursToDiff else {
            UserDefaults.standard.set(Date(), forKey: "lastPullTime")
            return true
        }

        return false
    }

    private func parseJsonData(_ data: Data) throws -> [String: String] {
        let jsonResponse = try JSONSerialization.jsonObject(
            with: data,
            options: []
        ) as!  [String: String]
        return jsonResponse
    }

    private func writeToBundle(with parsedJsonString: [String: String]) throws {
        let bkLocalizable = BKLocalizable(translations: [Locale.current.languageCode ?? "en": parsedJsonString])
        _ = try bkLocalizable.writeToBundle()
        setCurrentBundle(forLanguage: Locale.current.languageCode ?? "en")
        NotificationCenter.default.post(name: Notification.Name(LanguageChangeNotification), object: nil)
    }
}

// MARK: - Load local string file
extension BKLocalizationManager {

    func getDefaultLanguageFromLocalFile() -> [String: String]? {
        do {
            guard let bundlePath = Bundle.main.path(
                forResource: "english",
                ofType: "json"
            ),
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) else {
                return nil
            }
            return try parseJsonData(jsonData)
        } catch {
            return nil
        }
    }
}

// MARK: - Dev Helper function with assoicated files
extension BKLocalizationManager {
    func loadLocalizationContent(_ parsedJsonString: [String: String]) {
        do {
            try writeToBundle(with: parsedJsonString)
        } catch {
            print(error)
        }
    }
}
