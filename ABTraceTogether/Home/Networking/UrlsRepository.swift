import Foundation

class UrlsRepository {
    let DEFAULT_CACHE_DURATION = 60 * 60

    private var urlsCacheDuration: Int {
        get {
            guard let filePath = Bundle.main.path(forResource: "AppProperties", ofType: "plist") else {
                Logger.DLog("Couldn't find file AppProperties.plist")
                return DEFAULT_CACHE_DURATION
            }

            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "URLS_CACHE_DURATION") as? Int else {
                Logger.DLog("Couldn't read URLS_CACHE_DURATION from file AppProperties.plist")
                return DEFAULT_CACHE_DURATION
            }

            return value
        }
    }

    private var lastUrlsCacheUpdate: Date? {
        get {
            UserDefaults.standard.object(forKey: "lastUrlsCacheUpdate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastUrlsCacheUpdate")
        }
    }

    var urlsClient: UrlsClient = MfpUrlsClient()

    func getMoreLinks(_ callback: @escaping ([MoreLink]?) -> Void) {
        if (isExpired()) {
            urlsClient.getUrls { dynamicUrl in
                if let dynamicUrl = dynamicUrl {
                    self.persistUrls(dynamicUrl)
                    callback(dynamicUrl.moreLinks)
                } else {
                    Logger.logError(with: "Get Urls error: dynamicUrl is nil.")
                    callback(self.getCachedMoreLinks())
                }
            }
        } else {
            callback(self.getCachedMoreLinks())
        }
    }

    func getGuidanceTile(_ callback: @escaping (GuidanceTile?) -> Void) {
        if (isExpired()) {
            urlsClient.getUrls { dynamicUrl in
                if let dynamicUrl = dynamicUrl {
                    self.persistUrls(dynamicUrl)
                    callback(dynamicUrl.guidanceTile)
                } else {
                    Logger.logError(with: "Get Urls error: dynamicUrl is nil.")
                    callback(self.getCachedGuidanceTile())
                }
            }
        } else {
            callback(self.getCachedGuidanceTile())
        }
    }

    func getAllUrlsAndPersist() {
        if (isExpired()) {
            urlsClient.getUrls { dynamicUrl in
                if let dynamicUrl = dynamicUrl {
                    self.persistUrls(dynamicUrl)
                } else {
                    Logger.logError(with: "Get Urls error: dynamicUrl is nil.")
                }
            }
        }
    }

    private func persistUrls(_ dynamicUrl: DynamicUrl) {
        var errorOccurred = false

        do {
            if let guidanceTile = dynamicUrl.guidanceTile {
                let encodedGuidanceTileData = try JSONEncoder().encode(guidanceTile)
                UserDefaults.standard.set(encodedGuidanceTileData, forKey: guidanceTileKey)
            } else {
                UserDefaults.standard.set(nil, forKey: guidanceTileKey)
            }
        } catch {
            Logger.logError(with: "Error parsing Guidance Tile. \(error)")
            errorOccurred = true
        }
        
        do {
            if let moreLinks = dynamicUrl.moreLinks {
                let encodedMoreLinksData = try JSONEncoder().encode(moreLinks)
                UserDefaults.standard.set(encodedMoreLinksData, forKey: moreLinksKey)
            } else {
                UserDefaults.standard.set(nil, forKey: moreLinksKey)
            }
        } catch {
            Logger.logError(with: "Error parsing More Links. \(error)")
            errorOccurred = true
        }

        UserDefaults.standard.set(dynamicUrl.guidance, forKey: guidanceKey)
        UserDefaults.standard.set(dynamicUrl.stats, forKey: statisticsKey)
        UserDefaults.standard.set(dynamicUrl.home, forKey: caseSummaryKey)
        UserDefaults.standard.set(dynamicUrl.faq, forKey: faqUrlKey)
        UserDefaults.standard.set(dynamicUrl.privacy, forKey: privacyUrlKey)
        UserDefaults.standard.set(dynamicUrl.mhr, forKey: mhrKey)
        UserDefaults.standard.set(dynamicUrl.gis, forKey: gisKey)
        UserDefaults.standard.set(dynamicUrl.helpEmail, forKey: helpEmailKey)
        UserDefaults.standard.set(dynamicUrl.closeContactsFaq, forKey: closeContactsFaqKey)
        
        NotificationCenter.default.post(
            name: Notification.Name(notificationNameUrl),
            object: nil,
            userInfo: [caseSummaryKey: dynamicUrl.home]
        )
        BKLocalizationManager.sharedInstance.dynamicUrl = dynamicUrl

        if (!errorOccurred) {
            self.lastUrlsCacheUpdate = Date()
        }
    }

    private func isExpired() -> Bool {
        guard let lastPullTime = lastUrlsCacheUpdate else {
            return true
        }
        return Int(Date().timeIntervalSince(lastPullTime)) > urlsCacheDuration
    }

    private func getCachedGuidanceTile() -> GuidanceTile? {
        if let guidanceTitleData = UserDefaults.standard.data(forKey: guidanceTileKey) {
            return try? JSONDecoder().decode(GuidanceTile.self, from: guidanceTitleData)
        }
        return nil
    }

    private func getCachedMoreLinks() -> [MoreLink]? {
        if let moreLinksData = UserDefaults.standard.data(forKey: moreLinksKey) {
            return try? JSONDecoder().decode([MoreLink].self, from: moreLinksData)
        }
        return nil
    }
}
