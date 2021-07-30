import Foundation

struct StatsRepository {
    var statsClient: StatsClient = MfpStatsClient()
    var dailyStatsCache = StatsCache<DailyStats>(keyName: "dailyStats")
    var zoneStatsCache = StatsCache<ZoneStats>(keyName: "zoneStats")
    var municipalityStatsCache = StatsCache<MunicipalityStats>(keyName: "municipalityStats")
    var homeStatsCache = StatsCache<HomeStats>(keyName: "homeStats")

    func getDailyStats(_ callback: @escaping ([DailyStats]?) -> Void) {
        if dailyStatsCache.isExpired() {
            statsClient.getDailyStats { dailyStats in
                if let dailyStats = dailyStats {
                    dailyStatsCache.set(dailyStats)
                    DispatchQueue.main.async {
                        callback(dailyStats)
                    }
                } else {
                    DispatchQueue.main.async {
                        callback(dailyStatsCache.get())
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                callback(dailyStatsCache.get())
            }
        }
    }

    func getZoneStats(_ callback: @escaping ([ZoneStats]?) -> Void) {
        if zoneStatsCache.isExpired() {
            statsClient.getZoneStats { zoneStats in
                if let zoneStats = zoneStats {
                    zoneStatsCache.set(zoneStats)
                    DispatchQueue.main.async {
                        callback(zoneStats)
                    }
                } else {
                    DispatchQueue.main.async {
                        callback(zoneStatsCache.get())
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                callback(zoneStatsCache.get())
            }
        }
    }

    func getMunicipalityStats(_ callback: @escaping ([MunicipalityStats]?) -> Void) {
        if municipalityStatsCache.isExpired() {
            statsClient.getMunicipalityStats { municipalityStats in
                if let municipalityStats = municipalityStats {
                    municipalityStatsCache.set(municipalityStats)
                    DispatchQueue.main.async {
                        callback(municipalityStats)
                    }
                } else {
                    DispatchQueue.main.async {
                        callback(municipalityStatsCache.get())
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                callback(municipalityStatsCache.get())
            }
        }
    }

    func getHomeStats(_ callback: @escaping ([HomeStats]?) -> Void) {
        if homeStatsCache.isExpired() {
            statsClient.getHomeStats { homeStats in
                if let homeStats = homeStats {
                    homeStatsCache.set(homeStats)
                    DispatchQueue.main.async {
                        callback(homeStats)
                    }
                } else {
                    DispatchQueue.main.async {
                        callback(homeStatsCache.get())
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                callback(homeStatsCache.get())
            }
        }
    }
}
