import Foundation

struct TemporaryId {
    let tempID: String
    let expiryTime: Date
    
    func isValid() -> Bool {
        return Date() < expiryTime
    }
}
