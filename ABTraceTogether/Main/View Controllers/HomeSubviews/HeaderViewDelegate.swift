import Foundation

protocol HeaderViewDelegate: AnyObject {
    func updateLastUpdatedTime(_ date: Date)
    func playAnimation()
}
