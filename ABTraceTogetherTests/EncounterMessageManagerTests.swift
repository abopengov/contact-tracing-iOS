import XCTest

@testable import ABTraceTogether

class EncounterMessageManagerTests: XCTestCase {
    // 30 mins before
    //        Epoch timestamp: 1605679200
    //        Timestamp in milliseconds: 1605679200000
    //        Date and time (GMT): Wednesday, November 18, 2020 6:00:00 AM
    //        Date and time (your time zone): Wednesday, November 18, 2020 1:00:00 AM GMT-05:00

    // 15 mins before
    //        Epoch timestamp: 1605678300
    //        Timestamp in milliseconds: 1605678300000
    //        Date and time (GMT): Wednesday, November 18, 2020 5:45:00 AM
    //        Date and time (your time zone): Wednesday, November 18, 2020 12:45:00 AM GMT-05:00

    // current
    //        Epoch timestamp: 1605680100
    //        Timestamp in milliseconds: 1605680100000
    //        Date and time (GMT): Wednesday, November 18, 2020 6:15:00 AM
    //        Date and time (your time zone): Wednesday, November 18, 2020 1:15:00 AM GMT-05:00

    // 15 mins after
    //        Epoch timestamp: 1605681000
    //        Timestamp in milliseconds: 1605681000000
    //        Date and time (GMT): Wednesday, November 18, 2020 6:30:00 AM
    //        Date and time (your time zone): Wednesday, November 18, 2020 1:30:00 AM GMT-05:00

    // 30 mins after
    //    Epoch timestamp: 1605681900
    //    Timestamp in milliseconds: 1605681900000
    //    Date and time (GMT): Wednesday, November 18, 2020 6:45:00 AM
    //    Date and time (your time zone): Wednesday, November 18, 2020 1:45:00 AM GMT-05:00

    let encounterMessageManager = EncounterMessageManager()

    let tempIDs = [
        [
            "startTime": Double(1_605_680_100),
            "tempID": "tempId1",
            "expiryTime": Double(1_605_679_200)
        ],
        [
            "startTime": Double(1_605_680_100),
            "tempID": "tempId2",
            "expiryTime": Double(1_605_678_300)
        ],
        [
            "startTime": Double(1_605_680_100),
            "tempID": "tempId3",
            "expiryTime": Double(1_605_681_000)
        ]
    ]

    func testCleanupAndgetTempIdWithOneNotExpired() {
        let tempID = encounterMessageManager.cleanupAndgetTempId(
            tempIDs,
            currentDate: Date(timeIntervalSince1970: 1_605_680_100)
        )?.tempID

        XCTAssertEqual(tempID, "tempId3", "cleanedArray should have 1 item")
    }

    func testCleanupAndgetTempIdWithAllExpired() {
        let tempID = encounterMessageManager.cleanupAndgetTempId(
            tempIDs,
            currentDate: Date(timeIntervalSince1970: 1_605_681_900)
        )?.tempID

        XCTAssertNil(tempID, "All expired should return nil")
    }

    func testCleanupAndgetTempIdWithFirstExpired() {
        let tempID = encounterMessageManager.cleanupAndgetTempId(
            tempIDs,
            currentDate: Date(timeIntervalSince1970: 1_605_679_200)
        )?.tempID

        XCTAssertEqual(tempID, "tempId3", "cleanedArray should have 1 item")
    }
}
