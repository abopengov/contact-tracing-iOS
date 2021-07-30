import Foundation

struct HomeStats {
    let title: String?
    let value: String?
    let type: HomeStatsType?

    enum HomeStatsType: String, Codable {
        case STATS
        case CASES
        case VACCINATIONS
        case MAP
        case DASHBOARD
    }
}

extension HomeStats: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case value
        case type
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        do {
            type = try values.decodeIfPresent(HomeStatsType.self, forKey: .type)
        } catch {
            type = .STATS
        }
    }
}
