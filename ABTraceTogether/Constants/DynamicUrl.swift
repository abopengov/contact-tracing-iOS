import Foundation

struct DynamicUrl: Decodable {
    let home: String
    let faq: String
    let stats: String
    let privacy: String
    let guidance: String
    let mhr: Bool
    let gis: String
    let helpEmail: String
    let closeContactsFaq: String
    let guidanceTile: GuidanceTile?
    let moreLinks: [MoreLink]?
}

struct GuidanceTile: Codable {
    let link: String?
    let text: String?
    let title: String?
}

struct MoreLink: Codable {
    let title: String?
    let link: String?
}
