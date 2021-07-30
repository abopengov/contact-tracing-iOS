@testable import ABTraceTogether

class TestStatsClient: StatsClient {
    var dailyStatsCalled = false
    var zoneStatsCalled = false
    var municipalityStatsCalled = false
    var dailyStats: [DailyStats]?
    var zoneStats: [ZoneStats]?
    var municipalityStats: [MunicipalityStats]?

    func getDailyStats(_ callback: @escaping ([DailyStats]?) -> Void) {
        dailyStatsCalled = true
        callback(dailyStats)
    }

    func getZoneStats(_ callback: @escaping ([ZoneStats]?) -> Void) {
        zoneStatsCalled = true
        callback(zoneStats)
    }

    func getMunicipalityStats(_ callback: @escaping ([MunicipalityStats]?) -> Void) {
        municipalityStatsCalled = true
        callback(municipalityStats)
    }
}
