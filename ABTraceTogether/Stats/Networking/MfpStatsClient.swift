import Foundation
import IBMMobileFirstPlatformFoundation

struct MfpStatsClient: StatsClient {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.yeahMonthDay)
        return decoder
    }()

    func getDailyStats(_ callback: @escaping ([DailyStats]?) -> Void) {
        fetch("/adapters/statsAdapter/statistics/province_daily") { response in
            if let jsonData = response?.data(using: .utf8) {
                let dailyStats = try! decoder.decode([DailyStats].self, from: jsonData)
                    .filter { dailyStat in
                        dailyStat.date != nil
                    }
                    .sorted {
                        if let firstDate = $0.date, let secondDate = $1.date {
                            return firstDate.compare(secondDate) == .orderedAscending
                        }
                        return false
                    }

                callback(dailyStats)
            } else {
                callback(nil)
            }
        }
    }

    func getZoneStats(_ callback: @escaping ([ZoneStats]?) -> Void) {
        fetch("/adapters/statsAdapter/statistics/zone_latest") { response in
            if let jsonData = response?.data(using: .utf8) {
                let zoneStats = try! decoder.decode([ZoneStats].self, from: jsonData)
                    .filter { zoneStat in
                        zoneStat.zone != nil
                    }
                    .sorted {
                        if let firstZone = $0.zone, let secondZone = $1.zone {
                            return firstZone < secondZone
                        }
                        return false
                    }

                callback(zoneStats)
            } else {
                callback(nil)
            }
        }
    }

    func getMunicipalityStats(_ callback: @escaping ([MunicipalityStats]?) -> Void) {
        fetch("/adapters/statsAdapter/statistics/municipality_latest") { response in
            if let jsonData = response?.data(using: .utf8) {
                let municipalityStats = try! decoder.decode([MunicipalityStats].self, from: jsonData)

                callback(municipalityStats)
            } else {
                callback(nil)
            }
        }
    }

    func getHomeStats(_ callback: @escaping ([HomeStats]?) -> Void) {
        fetch("/adapters/statsAdapter/statistics/home_stats") { response in
            if let jsonData = response?.data(using: .utf8) {
                let homeStats = try! decoder.decode([HomeStats].self, from: jsonData)
                    .filter { homeStat in
                        homeStat.title != nil
                    }

                callback(homeStats)
            } else {
                callback(nil)
            }
        }
    }

    private func fetch(_ path: String, callback: @escaping (String?) -> Void) {
        guard let url = URL(string: path) else {
            Logger.logError(with: "Failed to create URL: \(path)")
            return
        }

        guard let wlResourceRequest = WLResourceRequest(url: url, method: "GET") else {
            Logger.logError(with: "Error creating WLResourceRequest")
            return
        }

        wlResourceRequest.send { response, error -> Void in
            guard error == nil else {
                Logger.logError(with: "Error making stats request.  Request: \(String(describing: wlResourceRequest.url)) queryParameters: \(String(describing: wlResourceRequest.queryParameters)) Response: \(response ?? WLResponse()) Error: \(error?.localizedDescription ?? "Error is nil")")

                callback(nil)
                return
            }

            callback(response?.responseText)
        }
    }
}
