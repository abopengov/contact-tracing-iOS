import Foundation

enum PhoneNumberFormatter {
    static func format(_ number: String) -> String {
        let end = number.index(number.startIndex, offsetBy: number.count)
        let range = number.startIndex..<end
        return number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
    }
}
