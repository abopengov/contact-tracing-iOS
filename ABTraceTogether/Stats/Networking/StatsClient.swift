import Foundation

protocol StatsClient {
    func getDailyStats(_ callback: @escaping ([DailyStats]?) -> Void)
    func getZoneStats(_ callback: @escaping ([ZoneStats]?) -> Void)
    func getMunicipalityStats(_ callback: @escaping ([MunicipalityStats]?) -> Void)
    func getHomeStats(_ callback: @escaping ([HomeStats]?) -> Void)
}
