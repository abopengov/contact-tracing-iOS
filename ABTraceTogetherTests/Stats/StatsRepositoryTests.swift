import Foundation
import XCTest

@testable import ABTraceTogether

class StatsRepositoryTests: XCTestCase {
    private let statsClient = TestStatsClient()
    private let dailyStatsCache = TestDailyStatsCache(keyName: "dailyStats")
    private let zoneStatsCache = TestZoneStatsCache(keyName: "zoneStats")
    private let municipalityStatsCache = TestMunicipalityStatsCache(keyName: "municipalityStats")

    private var subject: StatsRepository?

    override func setUp() {
        super.setUp()

        subject = StatsRepository(
            statsClient: statsClient,
            dailyStatsCache: dailyStatsCache,
            zoneStatsCache: zoneStatsCache,
            municipalityStatsCache: municipalityStatsCache
        )
    }

    func testGetDailyStats_withCache() throws {
        let expectation = self.expectation(description: "getDailyStats")
        var actualDailyStats: [DailyStats]?

        dailyStatsCache.dailyStats = [sampleDailyStats]

        subject?.getDailyStats { dailyStats in
            actualDailyStats = dailyStats
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(actualDailyStats?[0].date, sampleDailyStats.date)
        XCTAssertFalse(statsClient.dailyStatsCalled)
    }

    func testGetDailyStats_withExpiredCache_fetchesAndUpdatesCache() throws {
        let expectation = self.expectation(description: "getDailyStats")
        var actualDailyStats: [DailyStats]?

        dailyStatsCache.hasExpired = true
        statsClient.dailyStats = [sampleDailyStats]

        subject?.getDailyStats { dailyStats in
            actualDailyStats = dailyStats
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(actualDailyStats?[0].date, sampleDailyStats.date)
        XCTAssertTrue(statsClient.dailyStatsCalled)
        XCTAssertTrue(dailyStatsCache.setCalled)
    }

    func testGetDailyStats_withNetworkErrorAndNoCache() throws {
        let expectation = self.expectation(description: "getDailyStats")
        var actualDailyStats: [DailyStats]?

        dailyStatsCache.hasExpired = true

        subject?.getDailyStats { dailyStats in
            actualDailyStats = dailyStats
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(actualDailyStats)
    }

    func testGetDailyStats_withNetworkErrorAndWithCache() throws {
        let expectation = self.expectation(description: "getDailyStats")
        var actualDailyStats: [DailyStats]?

        dailyStatsCache.hasExpired = true
        dailyStatsCache.dailyStats = [sampleDailyStats]

        subject?.getDailyStats { dailyStats in
            actualDailyStats = dailyStats
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(actualDailyStats?[0].date, sampleDailyStats.date)
    }

    func testGetZoneStats_withCache() throws {
        let expectation = self.expectation(description: "getZoneStats")
        var actualZoneStats: [ZoneStats]?

        zoneStatsCache.zoneStats = [sampleZoneStats]

        subject?.getZoneStats { zoneStats in
            actualZoneStats = zoneStats
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(actualZoneStats?[0].zone, sampleZoneStats.zone)
        XCTAssertFalse(statsClient.dailyStatsCalled)
    }

    func testGetZoneStats_withExpiredCache_fetchesAndUpdatesCache() throws {
        let expectation = self.expectation(description: "getZoneStats")
        var actualZoneStats: [ZoneStats]?

        zoneStatsCache.hasExpired = true
        statsClient.zoneStats = [sampleZoneStats]

        subject?.getZoneStats { zoneStats in
            actualZoneStats = zoneStats
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(actualZoneStats?[0].zone, sampleZoneStats.zone)
        XCTAssertTrue(statsClient.zoneStatsCalled)
        XCTAssertTrue(zoneStatsCache.setCalled)
    }

    func testGetZoneStats_withNetworkErrorAndNoCache() throws {
        let expectation = self.expectation(description: "getZoneStats")
        var actualZoneStats: [ZoneStats]?

        zoneStatsCache.hasExpired = true

        subject?.getZoneStats { zoneStats in
            actualZoneStats = zoneStats
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(actualZoneStats)
    }

    func testGetZoneStats_withNetworkErrorAndWithCache() throws {
        let expectation = self.expectation(description: "getZoneStats")
        var actualZoneStats: [ZoneStats]?

        zoneStatsCache.hasExpired = true
        zoneStatsCache.zoneStats = [sampleZoneStats]

        subject?.getZoneStats { zoneStats in
            actualZoneStats = zoneStats
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(actualZoneStats?[0].zone, sampleZoneStats.zone)
    }

    func testGetMunicipalityStats_withCache() throws {
        let expectation = self.expectation(description: "getMunicipalityStats")
        var actualMunicipalityStats: [MunicipalityStats]?

        municipalityStatsCache.municipalityStats = [sampleMunicipalityStats]

        subject?.getMunicipalityStats { municipalityStats in
            actualMunicipalityStats = municipalityStats
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(actualMunicipalityStats?[0].municipality, sampleMunicipalityStats.municipality)
        XCTAssertFalse(statsClient.dailyStatsCalled)
    }

    func testGetMunicipalityStats_withExpiredCache_fetchesAndUpdatesCache() throws {
        let expectation = self.expectation(description: "getMunicipalityStats")
        var actualMunicipalityStats: [MunicipalityStats]?

        municipalityStatsCache.hasExpired = true
        statsClient.municipalityStats = [sampleMunicipalityStats]

        subject?.getMunicipalityStats { municipalityStats in
            actualMunicipalityStats = municipalityStats
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(actualMunicipalityStats?[0].municipality, sampleMunicipalityStats.municipality)
        XCTAssertTrue(statsClient.municipalityStatsCalled)
        XCTAssertTrue(municipalityStatsCache.setCalled)
    }

    func testGetMunicipalityStats_withNetworkErrorAndNoCache() throws {
        let expectation = self.expectation(description: "getMunicipalityStats")
        var actualMunicipalityStats: [MunicipalityStats]?

        municipalityStatsCache.hasExpired = true

        subject?.getMunicipalityStats { municipalityStats in
            actualMunicipalityStats = municipalityStats
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(actualMunicipalityStats)
    }

    func testGetMunicipalityStats_withNetworkErrorAndWithCache() throws {
        let expectation = self.expectation(description: "getMunicipalityStats")
        var actualMunicipalityStats: [MunicipalityStats]?

        municipalityStatsCache.hasExpired = true
        municipalityStatsCache.municipalityStats = [sampleMunicipalityStats]

        subject?.getMunicipalityStats { municipalityStats in
            actualMunicipalityStats = municipalityStats
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(actualMunicipalityStats?[0].municipality, sampleMunicipalityStats.municipality)
    }
}

private let sampleDailyStats = DailyStats(
    date: Date(),
    casesReported: 123,
    cumulativeCases: 123,
    variantsReportedToday: 123,
    vaccineDosesGivenToday: 123,
    cumulativeVaccineDoses: 123,
    activeCasesReported: 123,
    peopleFullyVaccinated: 123
)

private let sampleZoneStats = ZoneStats(
    zone: "zone1",
    zoneCode: "zone-code-1",
    totalCases: 123,
    activeCases: 123,
    activeCasesPer100Thousand: 123
)

private let sampleMunicipalityStats = MunicipalityStats(
    municipality: "Municipality Name",
    activeCases: 123
)

private class TestDailyStatsCache: StatsCache<DailyStats> {
    var getCalled = false
    var setCalled = false
    var dailyStats: [DailyStats]?
    var hasExpired = false

    override func get() -> [DailyStats]? {
        getCalled = true
        return dailyStats
    }

    override func set(_ stats: [DailyStats]) {
        setCalled = true
        dailyStats = stats
    }

    override func isExpired() -> Bool {
        hasExpired
    }
}

private class TestZoneStatsCache: StatsCache<ZoneStats> {
    var getCalled = false
    var setCalled = false
    var zoneStats: [ZoneStats]?
    var hasExpired = false

    override func get() -> [ZoneStats]? {
        getCalled = true
        return zoneStats
    }

    override func set(_ stats: [ZoneStats]) {
        setCalled = true
        zoneStats = stats
    }

    override func isExpired() -> Bool {
        hasExpired
    }
}

private class TestMunicipalityStatsCache: StatsCache<MunicipalityStats> {
    var getCalled = false
    var setCalled = false
    var municipalityStats: [MunicipalityStats]?
    var hasExpired = false

    override func get() -> [MunicipalityStats]? {
        getCalled = true
        return municipalityStats
    }

    override func set(_ stats: [MunicipalityStats]) {
        setCalled = true
        municipalityStats = stats
    }

    override func isExpired() -> Bool {
        hasExpired
    }
}
