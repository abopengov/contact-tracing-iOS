import Foundation

extension Array {
    var secondLast: Self.Iterator.Element? {
        get {
            if count >= 2 {
                return self[count - 2]
            }
            return nil
        }
    }
}
