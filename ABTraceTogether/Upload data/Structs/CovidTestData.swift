import Foundation

struct CovidTestData {
    var testDate: Date
    var symptomsDate: Date?
}

// MARK: - Encodable
extension CovidTestData: Encodable {
    enum CodingKeys: String, CodingKey {
        case testDate
        case symptomsDate
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Int(testDate.timeIntervalSince1970), forKey: .testDate)
        if let symptomsDate = self.symptomsDate {
            try container.encode(Int(symptomsDate.timeIntervalSince1970), forKey: .symptomsDate)
        }
    }
}
