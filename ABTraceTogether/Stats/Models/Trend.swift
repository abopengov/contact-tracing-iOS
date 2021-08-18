import UIKit

enum Trend {
    case up, down, none

    static func getTrend(previous: Int?, current: Int?) -> Trend {
        guard let current = current, let previous = previous else {
            return Trend.none
        }

        if previous < current {
            return Trend.up
        } else if previous > current {
            return Trend.down
        } else {
            return Trend.none
        }
    }
}

extension Trend {
    var image: UIImage? {
        get {
            switch self {
            case .up:
                return UIImage(named: "TrendingUp")

            case .down:
                return UIImage(named: "TrendingDown")

            default:
                return nil
            }
        }
    }

    var greyImage: UIImage? {
        get {
            switch self {
            case .up:
                return UIImage(named: "TrendingUpGrey")

            case .down:
                return UIImage(named: "TrendingDownGrey")

            default:
                return nil
            }
        }
    }
}
