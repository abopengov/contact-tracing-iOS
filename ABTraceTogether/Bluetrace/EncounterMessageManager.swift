import Foundation
import IBMMobileFirstPlatformFoundation

class EncounterMessageManager {
    let userDefaultsTempIdKey = "BROADCAST_MSG"
    let userDefaultsTempIdArrayKey = "BROAD_MSG_ARRAY"
    let userDefaultsAdvtKey = "ADVT_DATA"
    let userDefaultsAdvtExpiryKey = "ADVT_EXPIRY"

    static let shared = EncounterMessageManager()

//    lazy var functions = Functions.functions(region: "asia-east2")

    var tempId: String? {
        guard var tempIds = UserDefaults.standard.array(forKey: userDefaultsTempIdArrayKey) as! [[String: Any]]? else {
            return "not_found"
        }

        if let bmExpiry = tempIds.first?["expiryTime"] as? Date {
            while Date() > bmExpiry {
                tempIds.removeFirst()
            }
        }

        guard let validBm = tempIds.first?["tempID"] as? String else { return "" }
        return validBm
    }

    var advtPayload: Data? {
        return UserDefaults.standard.data(forKey: userDefaultsAdvtKey)
    }

    // This variable stores the expiry date of the broadcast message. At the same time, we will use this expiry date as the expiry date for the encryted advertisement payload
    var advtPayloadExpiry: Date? {
        return UserDefaults.standard.object(forKey: userDefaultsAdvtExpiryKey) as? Date
    }

    func setup() {
        // Check payload validity
        if advtPayloadExpiry == nil ||  Date() > advtPayloadExpiry! {

            fetchBatchTempIdsFromServer { [unowned self](error: Error?, resp: (tempIds: [[String: Any]], refreshDate: Date)?) in
                guard let response = resp else {
                    Logger.DLog("No response, Error: \(String(describing: error))")
                    return
                }
                _ = self.setAdvtPayloadIntoUserDefaultsv2(response)
                UserDefaults.standard.set(response.tempIds, forKey: self.userDefaultsTempIdArrayKey)

            }

        }
    }

    func getTempId(onComplete: @escaping (String?) -> Void) {
        // Check refreshDate
        if advtPayloadExpiry == nil ||  Date() > advtPayloadExpiry! {
            fetchBatchTempIdsFromServer { [unowned self](error: Error?, resp: (tempIds: [[String: Any]], refreshDate: Date)?) in
                guard let response = resp else {
                    Logger.DLog("No response, Error: \(String(describing: error))")
                    return
                }

                _ = self.setAdvtPayloadIntoUserDefaultsv2(response)
                UserDefaults.standard.set(response.tempIds, forKey: self.userDefaultsTempIdArrayKey)
                UserDefaults.standard.set(response.refreshDate, forKey: self.userDefaultsAdvtExpiryKey)

                var dataArray = response

                if let bmExpiry = dataArray.tempIds.first?["expiryTime"] as? Date {
                    while Date() > bmExpiry {
                        dataArray.tempIds.removeFirst()
                    }
                }

                guard let validBm = dataArray.tempIds.first?["tempID"] as? String else { return }
                UserDefaults.standard.set(validBm, forKey: self.userDefaultsTempIdKey)

                onComplete(validBm)
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

    func fetchBatchTempIdsFromServer(onComplete: ((Error?, ([[String: Any]], Date)?) -> Void)?) {
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
        
        guard let wlResourceRequest = WLResourceRequest(url: fetchTempIDURL, method:"GET") else {
            Logger.logError(with: "Get tempID error. Error converting from fetchTempIDURL to URL: \(fetchTempIDURL)")
            return
        }
        
        wlResourceRequest.queryParameters = ["userId" : userid]
        
         wlResourceRequest.send(completionHandler: { (response, error) -> Void in
            
            // Handle error
            guard error == nil else {
                Logger.logError(with: "Get tempID error.  Request: \(wlResourceRequest.url) queryParameters: \(wlResourceRequest.queryParameters) Response: \(response  ?? WLResponse.init()) Error: \(error?.localizedDescription ?? "Error is nil")")

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
                    Logger.logError(with: "Get tempID error. For userid: \(userid). Temp id is not in Response: \(response ?? WLResponse.init()) Error: \(error?.localizedDescription ?? "Error is nil")")
                    Logger.DLog("Unable to get tempId or refreshTime from server. result of function call: \(String(describing: response?.responseText))")
                    onComplete?(NSError(domain: "BM", code: 9999, userInfo: nil), nil)
                    return
            }
            
            onComplete?(nil, (tempIDs, Date(timeIntervalSince1970: bmRefreshTime)))
        })
        
    }

    func setAdvtPayloadIntoUserDefaultsv2(_ response: (tempIds: [[String: Any]], refreshDate: Date)) -> Data? {

        var dataArray = response

        // Pop out expired tempId
        if let bmExpiry = dataArray.tempIds.first?["expiryTime"] as? Date {
            while Date() > bmExpiry {
                dataArray.tempIds.removeFirst()
            }
        }

        guard let validBm = dataArray.tempIds.first?["tempID"] as? String else { return nil }

        let peripheralCharStruct = PeripheralCharacteristicsDataV2(mp: DeviceInfo.getModel(), id: validBm, o: BluetraceConfig.OrgID, v: BluetraceConfig.ProtocolVersion)

        do {
            let encodedPeriCharStruct = try JSONEncoder().encode(peripheralCharStruct)
            if let string = String(data: encodedPeriCharStruct, encoding: .utf8) {
                Logger.DLog("UserDefaultsv2 \(string)")
            } else {
                print("not a valid UTF-8 sequence")
            }

            UserDefaults.standard.set(encodedPeriCharStruct, forKey: self.userDefaultsAdvtKey)
            UserDefaults.standard.set(response.refreshDate, forKey: self.userDefaultsAdvtExpiryKey)
            return encodedPeriCharStruct
        } catch {
            Logger.DLog("Error: \(error)")
        }

        return nil
    }

}
