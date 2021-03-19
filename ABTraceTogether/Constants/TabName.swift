import Foundation

enum TabName {
    case home
    case faq
    case stats
    case guidance

    var tabIndex: Int {
        switch self {
        case .home:
            return 0

        case .stats:
            return 1

        case .faq:
            return 2

        case .guidance:
            return 3
        }
    }
}
