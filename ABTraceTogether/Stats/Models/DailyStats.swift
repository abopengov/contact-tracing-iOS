import Foundation

struct DailyStats {
    let date: Date?
    let casesReported: Int?
    let cumulativeCases: Int?
    let newVariantCases: Int?
    let vaccineDosesGivenToday: Int?
    let cumulativeVaccineDoses: Int?
    let activeCasesReported: Int?
    let peopleFullyVaccinated: Int?
}

extension DailyStats: Codable {
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case casesReported = "cases_reported"
        case cumulativeCases = "cumulative_cases"
        case newVariantCases = "new_variant_cases"
        case vaccineDosesGivenToday = "vaccine_doses_given_today"
        case cumulativeVaccineDoses = "cumulative_vaccine_doses"
        case activeCasesReported = "active_cases_reported"
        case peopleFullyVaccinated = "people_fully_vaccinated"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        casesReported = try values.decodeIfPresent(Int.self, forKey: .casesReported)
        cumulativeCases = try values.decodeIfPresent(Int.self, forKey: .cumulativeCases)
        newVariantCases = try values.decodeIfPresent(Int.self, forKey: .newVariantCases)
        vaccineDosesGivenToday = try values.decodeIfPresent(Int.self, forKey: .vaccineDosesGivenToday)
        cumulativeVaccineDoses = try values.decodeIfPresent(Int.self, forKey: .cumulativeVaccineDoses)
        activeCasesReported = try values.decodeIfPresent(Int.self, forKey: .activeCasesReported)
        peopleFullyVaccinated = try values.decodeIfPresent(Int.self, forKey: .peopleFullyVaccinated)
        date = try values.decodeIfPresent(Date.self, forKey: .date)
    }
}
