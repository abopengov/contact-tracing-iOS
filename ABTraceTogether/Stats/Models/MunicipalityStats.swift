import Foundation

struct MunicipalityStats {
    let municipality: String?
    let activeCases: Int?
}

extension MunicipalityStats: Codable {
    enum CodingKeys: String, CodingKey {
        case municipality = "municipality"
        case activeCases = "active_cases"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        municipality = try values.decodeIfPresent(String.self, forKey: .municipality)
        activeCases = try values.decodeIfPresent(Int.self, forKey: .activeCases)
    }
}
