import CoreData
import Foundation
import Herald
import IBMMobileFirstPlatformFoundation

class BlueTraceSensorDelegate {
    static let DEFAULT_RECENT_TIME_THRESHOLD_SECONDS: Double = 60
    let blueTraceDataPersistence: BlueTraceDataPersisting
    let recentTimeThresholdSeconds: Double

    var recentContactEvents: [String: Date] = [:]

    init(blueTraceDataPersistence: BlueTraceDataPersisting, recentTimeThresholdSeconds: Double = DEFAULT_RECENT_TIME_THRESHOLD_SECONDS) {
        self.blueTraceDataPersistence = blueTraceDataPersistence
        self.recentTimeThresholdSeconds = recentTimeThresholdSeconds
    }

    private func processPayload(proximity: Proximity, targetId: TargetIdentifier, payload: PayloadData) {
        let uniqueIdentifier = "\(targetId)\(payload.hashValue)"
        if let payloadExpiryDate = recentContactEvents[uniqueIdentifier], payloadExpiryDate > Date() {
            return
        }
        clearExpiredContactEvents()

        var rssi: Double = 0
        if (proximity.unit == ProximityMeasurementUnit.RSSI) {
            rssi = proximity.value
        }

        var txPower: Double = 0
        if (proximity.calibration?.unit == CalibrationMeasurementUnit.BLETransmitPower) {
            txPower = proximity.calibration?.value ?? 0
        }

        if let blueTracePayload = BlueTracePayload.parse(payloadData: payload) {
            let record = EncounterRecord(
                msg: blueTracePayload.tempId,
                modelC: blueTracePayload.modelC,
                modelP: DeviceInfo.getModel(),
                rssi: rssi,
                txPower: txPower,
                org: BluetraceConfig.OrgID,
                v: BluetraceConfig.ProtocolVersion
            )

            blueTraceDataPersistence.saveEncounter(encounterRecord: record)
            var expiryDate = Date()
            expiryDate.addTimeInterval(recentTimeThresholdSeconds)
            recentContactEvents[uniqueIdentifier] = expiryDate
        }
    }

    private func clearExpiredContactEvents() {
        recentContactEvents = recentContactEvents.filter {
            $0.value >= Date()
        }
    }
}

extension BlueTraceSensorDelegate: SensorDelegate {
    func sensor(_ sensor: SensorType, didMeasure: Proximity, fromTarget: TargetIdentifier, withPayload: PayloadData) {
        self.processPayload(proximity: didMeasure, targetId: fromTarget, payload: withPayload)
    }
}
