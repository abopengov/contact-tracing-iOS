import Foundation

protocol MoreClient {
    func getMoreLinks(_ callback: @escaping ([MoreLink]?) -> Void)
}
