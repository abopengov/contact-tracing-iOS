import CoreData
import XCTest

@testable import ABTraceTogether
@testable import Herald

class BlueTraceSensorDelegateTests: XCTestCase {
    let oneSecond: Double = 1

    var subject: BlueTraceSensorDelegate?
    private let stubDataPersistence = TestDataPersistence()

    override func setUp() {
        super.setUp()
        subject = BlueTraceSensorDelegate(blueTraceDataPersistence: stubDataPersistence, recentTimeThresholdSeconds: oneSecond)
    }

    func testSensorDataReceived_saveRecordWithTimeThreshold() throws {
        let blueTracePayload = BlueTracePayload(
            tempId: "tempId",
            modelC: "modelC",
            txPower: 20,
            rssi: -51
        )

        subject?.sensor(
            SensorType.BLE,
            didMeasure: Proximity(
                unit: ProximityMeasurementUnit.RSSI,
                value: -51,
                calibration: Calibration(unit: CalibrationMeasurementUnit.BLETransmitPower, value: 20)
            ),
            fromTarget: "fromTargetString",
            withPayload: PayloadData(blueTracePayload.data)
        )

        subject?.sensor(
            SensorType.BLE,
            didMeasure: Proximity(
                unit: ProximityMeasurementUnit.RSSI,
                value: -51,
                calibration: Calibration(unit: CalibrationMeasurementUnit.BLETransmitPower, value: 20)
            ),
            fromTarget: "fromTargetString",
            withPayload: PayloadData(blueTracePayload.data)
        )

        subject?.sensor(
            SensorType.BLE,
            didMeasure: Proximity(
                unit: ProximityMeasurementUnit.RSSI,
                value: -51,
                calibration: Calibration(unit: CalibrationMeasurementUnit.BLETransmitPower, value: 20)
            ),
            fromTarget: "fromTargetString",
            withPayload: PayloadData(blueTracePayload.data)
        )

        XCTAssertEqual(stubDataPersistence.saveEncounterCount, 1)

        sleep(UInt32(oneSecond))

        subject?.sensor(
            SensorType.BLE,
            didMeasure: Proximity(
                unit: ProximityMeasurementUnit.RSSI,
                value: -51,
                calibration: Calibration(unit: CalibrationMeasurementUnit.BLETransmitPower, value: 20)
            ),
            fromTarget: "fromTargetString",
            withPayload: PayloadData(blueTracePayload.data)
        )

        XCTAssertEqual(stubDataPersistence.saveEncounterCount, 2)
    }

    func testSensorDataReceived_clearOutdatedRecentContactEvents() {
        let blueTracePayload = BlueTracePayload(
            tempId: "tempId",
            modelC: "modelC",
            txPower: 20,
            rssi: -51
        )

        subject?.sensor(
            SensorType.BLE,
            didMeasure: Proximity(
                unit: ProximityMeasurementUnit.RSSI,
                value: -51,
                calibration: Calibration(unit: CalibrationMeasurementUnit.BLETransmitPower, value: 20)
            ),
            fromTarget: "fromTargetString",
            withPayload: PayloadData(blueTracePayload.data)
        )

        sleep(UInt32(oneSecond))

        subject?.sensor(
            SensorType.BLE,
            didMeasure: Proximity(
                unit: ProximityMeasurementUnit.RSSI,
                value: -51,
                calibration: Calibration(unit: CalibrationMeasurementUnit.BLETransmitPower, value: 20)
            ),
            fromTarget: "differentTargetString",
            withPayload: PayloadData(blueTracePayload.data)
        )

        XCTAssertEqual(subject?.recentContactEvents.count, 1)
    }
}

private class TestDataPersistence: BlueTraceDataPersisting {
    var saveEncounterCount = 0

    func saveEncounter(encounterRecord: EncounterRecord) {
        saveEncounterCount += 1
    }
}
