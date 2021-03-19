import Foundation
import Herald

class HeraldManager {
    static let shared = HeraldManager()
    private var sensorArray: SensorArray?

    func start() {
        guard sensorArray == nil else {
            return
        }

        let sendDistance = !FairEfficacyInstrumentation.shared.enabled
        let payloadDataSupplier = BlueTracePayloadDataSupplier(tempIdProvider: ConcreteTempIdProvider(), sendDistance: sendDistance)
        let sensorArray = SensorArray(payloadDataSupplier)
        sensorArray.add(delegate: BlueTraceSensorDelegate(blueTraceDataPersistence: CoreDataPersistence()))
        sensorArray.add(delegate: BluetoothStateManager.shared)

        if (FairEfficacyInstrumentation.shared.enabled) {
            FairEfficacyInstrumentation.shared.addEfficacyLogging(sensor: sensorArray)
        } else {
            BLESensorConfiguration.logLevel = .off
        }

        BLESensorConfiguration.payloadDataUpdateTimeInterval = 60.0 * 5

        sensorArray.start()
        self.sensorArray = sensorArray
    }

    func stop() {
        sensorArray?.stop()
        sensorArray = nil
    }
}
