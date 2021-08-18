import Foundation
import IBMMobileFirstPlatformFoundation

struct PrivacyClient {
    func getPrivacyPolicy(_ callback: @escaping (String?) -> Void) {
        fetch("/adapters/applicationDataAdapter/getPrivacyPolicy") { response in
            DispatchQueue.main.async {
                callback(response)
            }
        }
    }

    private func fetch(_ path: String, callback: @escaping (String?) -> Void) {
        guard let url = URL(string: path) else {
            Logger.logError(with: "Failed to create URL: \(path)")
            return
        }

        guard let wlResourceRequest = WLResourceRequest(url: url, method: "GET") else {
            Logger.logError(with: "Error creating WLResourceRequest")
            return
        }

        wlResourceRequest.send { response, error -> Void in
            guard error == nil else {
                Logger.logError(with: "Error making stats request.  Request: \(String(describing: wlResourceRequest.url)) queryParameters: \(String(describing: wlResourceRequest.queryParameters)) Response: \(response ?? WLResponse()) Error: \(error?.localizedDescription ?? "Error is nil")")

                callback(nil)
                return
            }

            guard let responseJSON = response?.responseJSON as? [String: String] else {
                callback(nil)
                return
            }

            callback(responseJSON["privacyStatement"])
        }
    }
}
