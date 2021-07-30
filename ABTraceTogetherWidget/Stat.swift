import Foundation

struct Stat {
    var name: String
    var value: Int?
    var previousValue: Int?

    func trend() -> Trend {
        Trend.getTrend(previous: previousValue, current: value)
    }
}
