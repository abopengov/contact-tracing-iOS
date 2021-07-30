import Foundation

class StatsCache<T: Codable> {
    let DEFAULT_CACHE_DURATION = 60 * 60

    private var statsCacheDuration: Int {
        get {
            guard let filePath = Bundle.main.path(forResource: "AppProperties", ofType: "plist") else {
                Logger.DLog("Couldn't find file AppProperties.plist")
                return DEFAULT_CACHE_DURATION
            }

            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "STATS_CACHE_DURATION") as? Int else {
                Logger.DLog("Couldn't read STATS_CACHE_DURATION from file AppProperties.plist")
                return DEFAULT_CACHE_DURATION
            }

            return value
        }
    }

    private var lastStatsCacheUpdate: Date? {
        get {
            UserDefaults.standard.object(forKey: "lastStatsCacheUpdate\(keyName)") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastStatsCacheUpdate\(keyName)")
        }
    }

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.yeahMonthDay)
        return decoder
    }()

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.yeahMonthDay)
        return encoder
    }()

    private var filePath: URL? {
        get {
            URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(keyName)
        }
    }

    private let keyName: String

    init(keyName: String) {
        self.keyName = keyName
    }

    func set(_ stats: [T]) {
        guard let data = try? encoder.encode(stats), let filePath = filePath else {
            Logger.DLog("Error saving to cache: \(keyName)")
            return
        }

        do {
            try data.write(to: filePath, options: .atomicWrite)
            lastStatsCacheUpdate = Date()
        } catch {
            Logger.DLog("Error saving to cache: \(keyName)\n\(error)")
        }
    }

    func get() -> [T]? {
        guard let filePath = filePath else {
            Logger.DLog("Error accessing temporary file")
            return nil
        }

        do {
            let data = try String(contentsOf: filePath)
            guard let jsonData = data.data(using: .utf8) else {
                return nil
            }
            return try decoder.decode([T].self, from: jsonData)
        } catch {
            Logger.DLog("Error retrieving from cache: \(keyName)\n\(error)")
            return nil
        }
    }

    func isExpired() -> Bool {
        guard let lastPullTime = lastStatsCacheUpdate,
            let filePath = filePath,
            FileManager.default.fileExists(atPath: filePath.path) else {
            return true
        }

        return Int(Date().timeIntervalSince(lastPullTime)) > statsCacheDuration
    }
}
