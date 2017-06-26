//
//  IntegrationTests.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 6/25/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import XCTest
@testable import XCServerAPI

class IntegrationTests: XCTestCase {
    
    /// "bot": {}
    /// "revisionBlueprint: {}
    /// "testedDevices": []
    /// "testHierarchy": {}
    let json = """
        {
            "_id": "d7f19e1d0b0f1ea270f60154c2003e49",
            "_rev": "17-951dc5cf5aa7ceae4f6442086ab85ce9",
            "number": 4,
            "currentStep": "completed",
            "result": "succeeded",
            "queuedDate": "2017-06-25T13:24:05.801Z",
            "success_streak": 1,
            "shouldClean": false,
            "assets": {
                "xcodebuildOutput": {
                    "size": 3183346,
                    "fileName": "xcodebuild_result.bundle.zip",
                    "allowAnonymousAccess": false,
                    "relativePath": "a7341f3521c7245492693c0d780006f9-XCServerAPI Bot/4/xcodebuild_result.bundle.zip"
                },
                "buildServiceLog": {
                    "size": 45693,
                    "fileName": "buildService.log",
                    "allowAnonymousAccess": false,
                    "relativePath": "a7341f3521c7245492693c0d780006f9-XCServerAPI Bot/4/buildService.log"
                },
                "xcodebuildLog": {
                    "size": 1745204,
                    "fileName": "xcodebuild.log",
                    "allowAnonymousAccess": false,
                    "relativePath": "a7341f3521c7245492693c0d780006f9-XCServerAPI Bot/4/xcodebuild.log"
                },
                "sourceControlLog": {
                    "size": 2163,
                    "fileName": "sourceControl.log",
                    "allowAnonymousAccess": false,
                    "relativePath": "a7341f3521c7245492693c0d780006f9-XCServerAPI Bot/4/sourceControl.log"
                }
            },
            "doc_type": "integration",
            "tinyID": "9658B8D",
            "buildServiceFingerprint": "4F:EF:EB:BC:15:11:B4:0C:90:65:3B:0D:86:1A:C5:6F:71:14:54:42",
            "tags": [],
            "startedTime": "2017-06-25T13:24:06.933Z",
            "buildResultSummary": {
                "analyzerWarningCount": 0,
                "testFailureCount": 0,
                "testsChange": 12,
                "errorCount": 0,
                "testsCount": 12,
                "testFailureChange": 0,
                "warningChange": 0,
                "regressedPerfTestCount": 0,
                "warningCount": 0,
                "errorChange": 0,
                "improvedPerfTestCount": 0,
                "analyzerWarningChange": 0,
                "codeCoveragePercentage": 21,
                "codeCoveragePercentageDelta": 0
            },
            "endedTime": "2017-06-25T13:27:28.921Z",
            "endedTimeDate": [
                2017,
                6,
                25,
                13,
                27,
                28,
                921
            ],
            "duration": 201.988,
            "ccPercentage": 0,
            "ccPercentageDelta": 0,
            "perfMetricNames": [],
            "perfMetricKeyPaths": []
        }
    """
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIntegration() {
        let queuedDate = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 2017, month: 06, day: 25, hour: 13, minute: 24, second: 05, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil).date!
        let startDate = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 2017, month: 06, day: 25, hour: 13, minute: 24, second: 06, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil).date!
        let endDate = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 2017, month: 06, day: 25, hour: 13, minute: 27, second: 28, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil).date!
        
        guard let integration = IntegrationDocument.decode(json: json) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(integration._id, "d7f19e1d0b0f1ea270f60154c2003e49")
        XCTAssertEqual(integration._rev, "17-951dc5cf5aa7ceae4f6442086ab85ce9")
        XCTAssertEqual(integration.number, 4)
        XCTAssertEqual(integration.currentStep, .completed)
        XCTAssertEqual(integration.result, .succeeded)
        XCTAssertNotNil(integration.queuedDate)
        var match = Calendar.current.compare(integration.queuedDate!, to: queuedDate, toGranularity: .second)
        XCTAssertTrue(match == .orderedSame)
        XCTAssertEqual(integration.successStreak, 1)
        XCTAssertNotNil(integration.assets)
        XCTAssertEqual(integration.docType, "integration")
        XCTAssertEqual(integration.tinyID, "9658B8D")
        XCTAssertEqual(integration.buildServiceFingerprint, "4F:EF:EB:BC:15:11:B4:0C:90:65:3B:0D:86:1A:C5:6F:71:14:54:42")
        XCTAssertEqual(integration.tags?.count, 0)
        XCTAssertNotNil(integration.startedTime)
        match = Calendar.current.compare(integration.startedTime!, to: startDate, toGranularity: .second)
        XCTAssertTrue(match == .orderedSame)
        XCTAssertNotNil(integration.endedTime)
        match = Calendar.current.compare(integration.endedTime!, to: endDate, toGranularity: .second)
        XCTAssertTrue(match == .orderedSame)
        XCTAssertEqual(integration.endedTimeDate?.count, 7)
        XCTAssertEqual(integration.duration, 201.988)
        XCTAssertEqual(integration.ccPercentage, 0)
        XCTAssertEqual(integration.ccPercentageDelta, 0)
        XCTAssertEqual(integration.perfMetricNames?.count, 0)
        XCTAssertEqual(integration.perfMetricKeyPaths?.count, 0)
        
        guard let resultSummary = integration.buildResultSummary else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(resultSummary.analyzerWarningCount, 0)
        XCTAssertEqual(resultSummary.testFailureCount, 0)
        XCTAssertEqual(resultSummary.testsChange, 12)
        XCTAssertEqual(resultSummary.errorCount, 0)
        XCTAssertEqual(resultSummary.testsCount, 12)
        XCTAssertEqual(resultSummary.testFailureChange, 0)
        XCTAssertEqual(resultSummary.warningChange, 0)
        XCTAssertEqual(resultSummary.regressedPerfTestCount, 0)
        XCTAssertEqual(resultSummary.warningCount, 0)
        XCTAssertEqual(resultSummary.errorChange, 0)
        XCTAssertEqual(resultSummary.improvedPerfTestCount, 0)
        XCTAssertEqual(resultSummary.analyzerWarningChange, 0)
        XCTAssertEqual(resultSummary.codeCoveragePercentage, 21)
        XCTAssertEqual(resultSummary.codeCoveragePercentageDelta, 0)
    }
}
