import Foundation
import Herald
import XCTest

@testable import ABTraceTogether

class BlueTracePayloadDataSupplierTests: XCTestCase {
    let subject = BlueTracePayloadDataSupplier(tempIdProvider: TestTempIdProvidable())

    func testPayloadProvidedNoDevice() {
        guard let payload = subject.payload(PayloadTimestamp(), device: nil) else {
            XCTFail("payload should not be nil")
            return
        }

        let blueTracePayload = BlueTracePayload.parse(payloadData: payload)

        XCTAssertNotNil(blueTracePayload)
        XCTAssertEqual(0, blueTracePayload?.rssi)
        XCTAssertEqual(0, blueTracePayload?.txPower)
        XCTAssertNotEqual(0, blueTracePayload?.tempId.count)
    }

    func testPayloadsWithVariableLength() {
        let blueTracePayload1 = BlueTracePayload(
            tempId: "tempId",
            modelC: "modelC",
            txPower: 20,
            rssi: -51
        )

        let blueTracePayload2 = BlueTracePayload(
            tempId: "tempId2",
            modelC: "android",
            txPower: 21,
            rssi: -41
        )

        var payloadData = Data()
        payloadData.append(blueTracePayload1.data)
        payloadData.append(blueTracePayload2.data)

        let payloads = subject.payload(payloadData)

        XCTAssertEqual(payloads.count, 2)
    }
}

private class TestTempIdProvidable: TempIdProvidable {
    func getTempId() -> String? {
        "any-temp-id"
    }

    func fetchNewTempId(onComplete: @escaping (String?) -> Void) {
    }
}
