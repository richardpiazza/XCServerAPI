//
//  IntegrationTests.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 6/25/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import XCTest

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
    
    let decoder = JSONDecoder()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
}
