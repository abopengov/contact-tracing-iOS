import Foundation

struct ZoneStats {
    let zone: String?
    let zoneCode: String?
    let totalCases: Int?
    let activeCases: Int?
    let activeCasesPer100Thousand: Double?
}

extension ZoneStats: Codable {
    enum CodingKeys: String, CodingKey {
        case zone = "zone"
        case zoneCode = "zone_code"
        case totalCases = "total_cases"
        case activeCases = "active_cases"
        case activeCasesPer100Thousand = "active_cases_per_100_thousand"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        zone = try values.decodeIfPresent(String.self, forKey: .zone)
        zoneCode = try values.decodeIfPresent(String.self, forKey: .zoneCode)
        totalCases = try values.decodeIfPresent(Int.self, forKey: .totalCases)
        activeCases = try values.decodeIfPresent(Int.self, forKey: .activeCases)
        activeCasesPer100Thousand = try values.decodeIfPresent(Double.self, forKey: .activeCasesPer100Thousand)
    }
}
