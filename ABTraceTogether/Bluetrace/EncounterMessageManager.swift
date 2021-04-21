import Foundation
import IBMMobileFirstPlatformFoundation
import Herald

class EncounterMessageManager {
    private let userDefaultsTempIdArrayKey = "BROAD_MSG_ARRAY"
    private let userDefaultsAdvtExpiryKey = "ADVT_EXPIRY"
    static let TEMP_ID_NOT_FOUND = "not_found"
    static let shared = EncounterMessageManager()

    private var currentTempId: TemporaryId? = nil
    
    var tempId: String? {
        if let currentTempId = currentTempId, currentTempId.isValid() {
            return currentTempId.tempID
        }
        
        guard let tempIds = self.savedTempIds else {
            return EncounterMessageManager.TEMP_ID_NOT_FOUND
        }

        guard let currentTempId = cleanupAndgetTempId(tempIds, currentDate: Date()) else { return "" }

        self.currentTempId = currentTempId
        return currentTempId.tempID
    }

    // This variable stores the expiry date of the broadcast message. At the same time, we will use this expiry date as the expiry date for the encryted advertisement payload
    private var advtPayloadExpiry: Date? {
        get {
            UserDefaults.standard.object(forKey: userDefaultsAdvtExpiryKey) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: self.userDefaultsAdvtExpiryKey)
        }
    }
    
    private var savedTempIds: [[String: Any]]? {
        get {
            UserDefaults.standard.array(forKey: userDefaultsTempIdArrayKey) as! [[String: Any]]?
        }
        set {
            UserDefaults.standard.set(newValue, forKey: self.userDefaultsTempIdArrayKey)
        }
    }

    func cleanupAndgetTempId(_ tempIdList: [[String: Any]], currentDate: Date) -> TemporaryId? {
        var newTempIdList = tempIdList

        for item in tempIdList {
            guard let expiryTimeInterval = item["expiryTime"] as? TimeInterval else {return nil}

            if currentDate >= Date(timeIntervalSince1970: expiryTimeInterval) {
                newTempIdList.removeFirst()
            } else {
                break
            }
        }

        guard let tempId = newTempIdList.first?["tempID"] as? String,
              let expiryTime = newTempIdList.first?["expiryTime"] as? TimeInterval else {
            return nil
        }

        return TemporaryId(tempID: tempId, expiryTime: Date(timeIntervalSince1970: expiryTime))
    }

    func setup() {
        // Check payload validity
        if advtPayloadExpiry == nil ||  Date() > advtPayloadExpiry! {
            fetchBatchTempIdsFromServer { [unowned self](error: Error?, resp: (tempIds: [[String: Any]], refreshDate: Date)?) in
                guard let response = resp else {
                    Logger.DLog("No response, Error: \(String(describing: error))")
                    return
                }
                
                self.advtPayloadExpiry = response.refreshDate
                self.savedTempIds = response.tempIds
            }
        }
    }

    func fetchNewTempIds(onComplete: @escaping (String?) -> Void) {
        // Check refreshDate
        if advtPayloadExpiry == nil ||  Date() > advtPayloadExpiry! {
            fetchBatchTempIdsFromServer { [unowned self](error: Error?, resp: (tempIds: [[String: Any]], refreshDate: Date)?) in
                guard let response = resp else {
                    Logger.DLog("No response, Error: \(String(describing: error))")
                    return
                }

                self.advtPayloadExpiry = response.refreshDate
                self.savedTempIds = response.tempIds

                onComplete(self.tempId)
                return
            }
        }

        // We know that tempIdBatch array has not expired, now find the latest usable tempId
        if let msg = tempId {
            onComplete(msg)
        } else {
            // This is not part of usual expected flow, just run setup
            setup()
            onComplete(nil)
        }
    }

    private func fetchBatchTempIdsFromServer(onComplete: ((Error?, ([[String: Any]], Date)?) -> Void)?) {
        guard !FairEfficacyInstrumentation.shared.enabled else {
            var tempIds: [[String: Any]] = []
            var tempId: [String: Any] = [:]
            tempId["expiryTime"] = Date.distantFuture.timeIntervalSince1970
            tempId["tempID"] = FairEfficacyInstrumentation.shared.fixedTempId
            tempIds.append(tempId)
            onComplete?(nil, (tempIds, Date.distantFuture))
            return
        }

        Logger.DLog("Fetching Batch of tempIds from server")

        guard let userid = UserDefaults.standard.string(forKey: userDefaultsPinKey) else {
            Logger.logError(with: "uploadFile, user id not found")
            return
        }

        let fetchTempIDURLString = "/adapters/tempidsAdapter/tempIds"
        guard let fetchTempIDURL = URL(string: fetchTempIDURLString) else {
            Logger.logError(with: "Get tempID error. Error converting from fetchTempIDURLString to URL: \(fetchTempIDURLString)")
            return
        }

        guard let wlResourceRequest = WLResourceRequest(url: fetchTempIDURL, method: "GET") else {
            Logger.logError(with: "Get tempID error. Error converting from fetchTempIDURL to URL: \(fetchTempIDURL)")
            return
        }

        wlResourceRequest.queryParameters = ["userId": userid]

         wlResourceRequest.send(completionHandler: { (response, error) -> Void in
            // Handle error
            guard error == nil else {
                Logger.logError(with: "Get tempID error.  Request: \(String(describing: wlResourceRequest.url)) queryParameters: \(String(describing: wlResourceRequest.queryParameters)) Response: \(response  ?? WLResponse()) Error: \(error?.localizedDescription ?? "Error is nil")")

                if let error = error as NSError? {
                        let code = error.code
                        let message = error.localizedDescription
                        Logger.DLog("Cloud function error. Code: \(String(describing: code)), Message: \(message)")
                        onComplete?(error, nil)
                        return
                } else {
                    Logger.DLog("Cloud function error, unable to convert error to NSError.\(error!)")
                }
                onComplete?(error, nil)
                return
            }

            guard let responseJSON = response?.responseJSON as? [String: Any],
                let pins = responseJSON["pin"] as? [String: Any],
                let tempIDs = pins["tempIDs"] as? [[String: Any]],
                let bmRefreshTime = pins["refreshTime"] as? Double else {
                    Logger.logError(with: "Get tempID error. For userid: \(userid). Temp id is not in Response: \(response ?? WLResponse()) Error: \(error?.localizedDescription ?? "Error is nil")")
                    Logger.DLog("Unable to get tempId or refreshTime from server. result of function call: \(String(describing: response?.responseText))")
                    onComplete?(NSError(domain: "BM", code: 9999, userInfo: nil), nil)
                    return
            }

            onComplete?(nil, (tempIDs, Date(timeIntervalSince1970: bmRefreshTime)))
        })
    }
}
