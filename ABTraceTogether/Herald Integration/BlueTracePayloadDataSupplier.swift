import Foundation
import Herald

class BlueTracePayloadDataSupplier: PayloadDataSupplier {
    private let tempIdProvider: TempIdProvidable
    private let sendDistance: Bool

    init(tempIdProvider: TempIdProvidable, sendDistance: Bool = true) {
        self.tempIdProvider = tempIdProvider
        self.sendDistance = sendDistance
    }

    func legacyPayload(_ timestamp: PayloadTimestamp, device: Device?) -> PayloadData? {
        nil
    }

    func payload(_ timestamp: PayloadTimestamp, device: Device?) -> PayloadData? {
        let payloadData = PayloadData()

        if let tempId = tempIdProvider.getTempId() {
            if tempId != EncounterMessageManager.TEMP_ID_NOT_FOUND && !tempId.isEmpty {
                let tracerPayload = BlueTracePayload(
                    tempId: tempId,
                    modelC: DeviceInfo.getModel(),
                    txPower: getTxPower(device: device),
                    rssi: getRssi(device: device)
                    )
                payloadData.append(tracerPayload.data)
            } else {
                Logger.DLog("No tempId available for payload supplier.")

                tempIdProvider.fetchNewTempId { tempId in
                    if (tempId != nil) {
                        Logger.DLog("Fetched new tempId for payload supplier.")
                    } else {
                        Logger.DLog("Failed to fetch tempId for payload supplier.")
                    }
                }
            }
        }

        return payloadData
    }

    private func getTxPower(device: Device?) -> UInt16 {
        guard sendDistance else {
            return 0
        }

        guard let txPower = (device as? BLEDevice)?.txPower else {
            return 0
        }

        return UInt16(txPower)
    }

    private func getRssi(device: Device?) -> Int8 {
        guard sendDistance else {
            return 0
        }

        guard let rssi = (device as? BLEDevice)?.rssi else {
            return 0
        }

        return Int8(rssi)
    }

    func payload(_ data: Data) -> [PayloadData] {
        var payloads: [PayloadData] = []

        var index = 0
        repeat {
            if let extractedPayload = nextPayload(index: index, data: data) {
                payloads.append(extractedPayload)
                index += extractedPayload.count
            } else {
                break
            }
        } while(true)

        return payloads
    }

    private func nextPayload(index: Int, data: Data) -> PayloadData? {
        guard let innerPayloadLength = data.uint16(index + 5) else {
            return nil
        }

        return PayloadData(data.subdata(in: index..<index + 7 + Int(innerPayloadLength)))
    }
}
