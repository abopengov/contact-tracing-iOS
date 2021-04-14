import Foundation

enum Tag {
    case tagOne
    case tagTwo
    var tagNumber: Int {
        switch self {
        case .tagOne:
            return 99

        case .tagTwo:
            return 98
    }
}
}
