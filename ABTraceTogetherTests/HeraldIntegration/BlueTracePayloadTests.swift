import Herald
import XCTest

@testable import ABTraceTogether

class BlueTracePayloadTests: XCTestCase {
    func testCreateParse() throws {
        let tempId = "myid"
        let modelC = "Playbook"
        let txPower: UInt16 = 2
        let rssi: Int8 = -2

        let blueTracePayload = BlueTracePayload(
            tempId: tempId,
            modelC: modelC,
            txPower: txPower,
            rssi: rssi
        )

        let parsedBlueTracePayload = BlueTracePayload.parse(payloadData: PayloadData(blueTracePayload.data))
        XCTAssertEqual(parsedBlueTracePayload?.tempId, tempId)
        XCTAssertEqual(parsedBlueTracePayload?.modelC, modelC)
        XCTAssertEqual(parsedBlueTracePayload?.txPower, txPower)
        XCTAssertEqual(parsedBlueTracePayload?.rssi, rssi)
    }
}
