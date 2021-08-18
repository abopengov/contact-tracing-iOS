import Foundation
import Herald

class HeraldManager {
    static let shared = HeraldManager()
    private final let PAYLOAD_UPDATE_FREQUENCY = 60.0 * 5
    private var started = false
    private lazy var sensorArray: SensorArray = {
        BLESensorConfiguration.logLevel = .off
        BLESensorConfiguration.payloadDataUpdateTimeInterval = PAYLOAD_UPDATE_FREQUENCY

        let sendDistance = !FairEfficacyInstrumentation.shared.enabled
        let payloadDataSupplier = BlueTracePayloadDataSupplier(tempIdProvider: ConcreteTempIdProvider(), sendDistance: sendDistance)
        let sensorArray = SensorArray(payloadDataSupplier)

        sensorArray.add(delegate: BlueTraceSensorDelegate(blueTraceDataPersistence: CoreDataPersistence()))
        sensorArray.add(delegate: BluetoothStateManager.shared)

        if (FairEfficacyInstrumentation.shared.enabled) {
            FairEfficacyInstrumentation.shared.addEfficacyLogging(sensor: sensorArray)
            BLESensorConfiguration.logLevel = .debug
        }

        return sensorArray
    }()

    func start() {
        guard started == false else {
            return
        }
        sensorArray.start()
        started = true
    }

    func stop() {
        guard started == true else {
            return
        }
        sensorArray.stop()
        started = false
    }
}
