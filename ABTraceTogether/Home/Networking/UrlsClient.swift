import Foundation

protocol UrlsClient {
    func getUrls(_ callback: @escaping (DynamicUrl?) -> Void)
}
