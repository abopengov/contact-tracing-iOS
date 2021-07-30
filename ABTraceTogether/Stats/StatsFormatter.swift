import Foundation

enum StatsFormatter {
    static func formatWithCommas(_ value: Int?) -> String {
        value?.withCommas() ?? "-"
    }
}
