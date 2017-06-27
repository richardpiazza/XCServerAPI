//
//  StatsTests.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 6/26/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import XCTest
@testable import XCServerAPI

class StatsTests: XCTestCase {
    
    let json = """
        {
            "lastCleanIntegration": {
                "integrationID": "d7f19e1d0b0f1ea270f60154c21ddd0d",
                "endedTime": "2017-06-26T23:36:13.990Z"
            },
            "bestSuccessStreak": {
                "integrationID": "d7f19e1d0b0f1ea270f60154c21ddd0d",
                "success_streak": 3,
                "endedTime": "2017-06-26T23:36:13.990Z"
            },
            "numberOfIntegrations": 6,
            "numberOfCommits": 12,
            "averageIntegrationTime": {
                "sum": 577.1289999999999,
                "count": 3,
                "min": 166.791,
                "max": 208.35,
                "avg": 192.3763333333333,
                "stdDev": 141.4213562373095,
                "sumsqr": 112028.112325
            },
            "testAdditionRate": 9,
            "analysisWarnings": {
                "sum": 0,
                "count": 0,
                "min": 0,
                "max": 0,
                "avg": 0,
                "stdDev": 0
            },
            "testFailures": {
                "sum": 0,
                "count": 3,
                "min": 0,
                "max": 0,
                "avg": 0,
                "stdDev": 0,
                "sumsqr": 0
            },
            "errors": {
                "sum": 0,
                "count": 3,
                "min": 0,
                "max": 0,
                "avg": 0,
                "stdDev": 0,
                "sumsqr": 0
            },
            "regressedPerfTests": {
                "sum": 0,
                "count": 3,
                "min": 0,
                "max": 0,
                "avg": 0,
                "stdDev": 0,
                "sumsqr": 0
            },
            "warnings": {
                "sum": 0,
                "count": 3,
                "min": 0,
                "max": 0,
                "avg": 0,
                "stdDev": 0,
                "sumsqr": 0
            },
            "improvedPerfTests": {
                "sum": 0,
                "count": 3,
                "min": 0,
                "max": 0,
                "avg": 0,
                "stdDev": 0,
                "sumsqr": 0
            },
            "tests": {
                "sum": 34,
                "count": 3,
                "min": 9,
                "max": 13,
                "avg": 11.333333333333334,
                "stdDev": 141.42135623730948,
                "sumsqr": 394
            },
            "codeCoveragePercentageDelta": -10,
            "numberOfSuccessfulIntegrations": 3,
            "sinceDate": "2016-06-26T23:41:44.071Z"
        }
    """
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStats() {
        guard let stats = Stats.decode(json: json) else {
            XCTFail()
            return
        }
        
        XCTAssertNotNil(stats.lastCleanIntegration)
        XCTAssertEqual(stats.lastCleanIntegration?.integrationID, "d7f19e1d0b0f1ea270f60154c21ddd0d")
        XCTAssertNotNil(stats.lastCleanIntegration?.endedTime)
        var date = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 2017, month: 06, day: 26, hour: 23, minute: 36, second: 13, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil).date!
        var match = Calendar.current.compare(stats.lastCleanIntegration!.endedTime, to: date, toGranularity: .second)
        XCTAssertTrue(match == .orderedSame)
        XCTAssertNotNil(stats.bestSuccessStreak)
        XCTAssertEqual(stats.bestSuccessStreak?.integrationID, "d7f19e1d0b0f1ea270f60154c21ddd0d")
        XCTAssertEqual(stats.bestSuccessStreak?.successStreak, 3)
        XCTAssertNotNil(stats.bestSuccessStreak?.endedTime)
        date = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 2017, month: 06, day: 26, hour: 23, minute: 36, second: 13, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil).date!
        match = Calendar.current.compare(stats.bestSuccessStreak!.endedTime, to: date, toGranularity: .second)
        XCTAssertTrue(match == .orderedSame)
        XCTAssertEqual(stats.numberOfIntegrations, 6)
        XCTAssertEqual(stats.numberOfCommits, 12)
        XCTAssertEqual(stats.testAdditionRate, 9)
        XCTAssertEqual(stats.codeCoveragePercentageDelta, -10)
        XCTAssertEqual(stats.numberOfSuccessfulIntegrations, 3)
        XCTAssertNotNil(stats.sinceDate)
        date = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 2016, month: 06, day: 26, hour: 23, minute: 41, second: 44, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil).date!
        match = Calendar.current.compare(stats.sinceDate!, to: date, toGranularity: .second)
        XCTAssertTrue(match == .orderedSame)
        
        guard let averageIntegrationTime = stats.averageIntegrationTime else {
            XCTFail()
            return
        }
        
        XCTAssertEqualWithAccuracy(averageIntegrationTime.sum, 577.129, accuracy: 0.1)
        XCTAssertEqual(averageIntegrationTime.count, 3)
        XCTAssertEqualWithAccuracy(averageIntegrationTime.min, 166.791, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(averageIntegrationTime.max, 208.35, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(averageIntegrationTime.avg, 192.376, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(averageIntegrationTime.stdDev, 141.421, accuracy: 0.1)
        XCTAssertNotNil(averageIntegrationTime.sumsqr)
        XCTAssertEqualWithAccuracy(averageIntegrationTime.sumsqr!, 112028.112, accuracy: 0.1)
        
        guard let analysisWarnings = stats.analysisWarnings else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(analysisWarnings.sum, 0.0)
        XCTAssertEqual(analysisWarnings.count, 0)
        XCTAssertEqual(analysisWarnings.min, 0.0)
        XCTAssertEqual(analysisWarnings.max, 0.0)
        XCTAssertEqual(analysisWarnings.avg, 0.0)
        XCTAssertEqual(analysisWarnings.stdDev, 0.0)
        XCTAssertNil(analysisWarnings.sumsqr)
        
        guard let testFailures = stats.testFailures else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(testFailures.sum, 0.0)
        XCTAssertEqual(testFailures.count, 3)
        XCTAssertEqual(testFailures.min, 0.0)
        XCTAssertEqual(testFailures.max, 0.0)
        XCTAssertEqual(testFailures.avg, 0.0)
        XCTAssertEqual(testFailures.stdDev, 0.0)
        XCTAssertEqual(testFailures.sumsqr, 0.0)
        
        guard let errors = stats.errors else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(errors.sum, 0.0)
        XCTAssertEqual(errors.count, 3)
        XCTAssertEqual(errors.min, 0.0)
        XCTAssertEqual(errors.max, 0.0)
        XCTAssertEqual(errors.avg, 0.0)
        XCTAssertEqual(errors.stdDev, 0.0)
        XCTAssertEqual(errors.sumsqr, 0.0)
        
        guard let regressedPerfTests = stats.regressedPerfTests else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(regressedPerfTests.sum, 0.0)
        XCTAssertEqual(regressedPerfTests.count, 3)
        XCTAssertEqual(regressedPerfTests.min, 0.0)
        XCTAssertEqual(regressedPerfTests.max, 0.0)
        XCTAssertEqual(regressedPerfTests.avg, 0.0)
        XCTAssertEqual(regressedPerfTests.stdDev, 0.0)
        XCTAssertEqual(regressedPerfTests.sumsqr, 0.0)
        
        guard let warnings = stats.warnings else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(warnings.sum, 0.0)
        XCTAssertEqual(warnings.count, 3)
        XCTAssertEqual(warnings.min, 0.0)
        XCTAssertEqual(warnings.max, 0.0)
        XCTAssertEqual(warnings.avg, 0.0)
        XCTAssertEqual(warnings.stdDev, 0.0)
        XCTAssertEqual(warnings.sumsqr, 0.0)
        
        guard let improvedPerfTests = stats.improvedPerfTests else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(improvedPerfTests.sum, 0.0)
        XCTAssertEqual(improvedPerfTests.count, 3)
        XCTAssertEqual(improvedPerfTests.min, 0.0)
        XCTAssertEqual(improvedPerfTests.max, 0.0)
        XCTAssertEqual(improvedPerfTests.avg, 0.0)
        XCTAssertEqual(improvedPerfTests.stdDev, 0.0)
        XCTAssertEqual(improvedPerfTests.sumsqr, 0.0)
        
        guard let tests = stats.tests else {
            XCTFail()
            return
        }
        
        XCTAssertEqualWithAccuracy(tests.sum, 34, accuracy: 0.1)
        XCTAssertEqual(tests.count, 3)
        XCTAssertEqualWithAccuracy(tests.min, 9, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(tests.max, 13, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(tests.avg, 11.3, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(tests.stdDev, 141.421, accuracy: 0.1)
        XCTAssertNotNil(tests.sumsqr)
        XCTAssertEqualWithAccuracy(tests.sumsqr!, 394.0, accuracy: 0.1)
    }
}
