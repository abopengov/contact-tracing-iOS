import Foundation
import XCTest

@testable import ABTraceTogether

// swiftlint:disable force_unwrapping
class DateExtensionTests: XCTestCase {
    func testNextTime() {
        let now = Date()
        let nextTime = now.nextTime

        let calendar = Calendar.current
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let expectedComponents = calendar.dateComponents(components, from: calendar.date(byAdding: .day, value: 1, to: now)!)
        let actualComponents = calendar.dateComponents(components, from: nextTime!)

        XCTAssertEqual(expectedComponents, actualComponents)
    }

    func testWithinTimePeriod_withPeriodSameDay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"

        let startTime = formatter.date(from: "2021/10/08 01:30")!
        let endTime = formatter.date(from: "2021/10/08 03:30")!

        let beforePeriod = formatter.date(from: "2021/10/08 01:00")!
        let withinPeriod = formatter.date(from: "2021/10/08 02:00")!
        let afterPeriod = formatter.date(from: "2021/10/08 04:00")!

        XCTAssertFalse(beforePeriod.withinTimePeriod(startTime: startTime, endTime: endTime))
        XCTAssertFalse(afterPeriod.withinTimePeriod(startTime: startTime, endTime: endTime))
        XCTAssertTrue(withinPeriod.withinTimePeriod(startTime: startTime, endTime: endTime))
    }

    func testWithinTimePeriod_withPeriodAcrossDays() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"

        let startTime = formatter.date(from: "2021/10/08 23:00")!
        let endTime = formatter.date(from: "2021/10/08 07:00")!

        let beforePeriod = formatter.date(from: "2021/10/08 22:00")!
        let withinPeriodFirstDay = formatter.date(from: "2021/10/08 23:30")!
        let withinPeriodSecondDay = formatter.date(from: "2021/10/08 01:00")!
        let afterPeriod = formatter.date(from: "2021/10/08 08:00")!

        XCTAssertFalse(beforePeriod.withinTimePeriod(startTime: startTime, endTime: endTime))
        XCTAssertFalse(afterPeriod.withinTimePeriod(startTime: startTime, endTime: endTime))
        XCTAssertTrue(withinPeriodFirstDay.withinTimePeriod(startTime: startTime, endTime: endTime))
        XCTAssertTrue(withinPeriodSecondDay.withinTimePeriod(startTime: startTime, endTime: endTime))
    }
}
