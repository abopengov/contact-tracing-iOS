import Foundation
import IBMMobileFirstPlatformFoundation

struct MfpUrlsClient: UrlsClient {
    func getUrls(_ callback: @escaping (DynamicUrl?) -> Void) {
        let getUrlsString = getUrlsApi
        guard let url = URL(string: getUrlsString) else {
            Logger.logError(with: "Get Urls error. Error converting from getUrlsString to URL: \(getUrlsString)")
            callback(nil)
            return
        }
        guard let wlResourceRequest = WLResourceRequest(
            url: url,
            method: getMethodString
        ) else {
            Logger.logError(with: "Get Urls error. Error converting to wlResourceRequest. \(url)")
            callback(nil)
            return
        }

        wlResourceRequest.queryParameters = ["lang": Locale.current.languageCode ?? "en"]
        wlResourceRequest.send {response, error -> Void  in
            if let error = error {
                Logger.logError(with: "\(error)")
            }
            guard let data = response?.responseData else {
                callback(nil)
                return
            }
            do {
                let dynamicUrl = try JSONDecoder().decode(DynamicUrl.self, from: data)
                callback(dynamicUrl)
            } catch {
                Logger.logError(with: "Error parsing URLs. \(error)")
                callback(nil)
            }
        }
    }
}
