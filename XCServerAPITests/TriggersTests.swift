//
//  TriggersTests.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 7/7/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import XCTest
@testable import XCServerAPI

class TriggersTests: XCTestCase {
    
    let json = """
        [
            {
                "phase": 1,
                "scriptBody": "#!/bin/sh\n\necho Pre-Integration Script Running\n\n",
                "type": 1,
                "name": "preintegration",
                "conditions": {
                    "status": 2,
                    "onAllIssuesResolved": true,
                    "onWarnings": true,
                    "onBuildErrors": true,
                    "onAnalyzerWarnings": true,
                    "onFailingTests": true,
                    "onSuccess": true
                }
            },
            {
                "phase": 2,
                "scriptBody": "#!/bin/sh\n\necho Post-Integration Script Running\n\n",
                "type": 1,
                "name": "postintegration",
                "conditions": {
                    "status": 2,
                    "onAllIssuesResolved": true,
                    "onWarnings": true,
                    "onBuildErrors": true,
                    "onAnalyzerWarnings": true,
                    "onFailingTests": true,
                    "onSuccess": true
                }
            },
            {
                "phase": 2,
                "scriptBody": "",
                "emailConfiguration": {
                    "ccAddresses": [],
                    "allowedDomainNames": [],
                    "includeCommitMessages": true,
                    "includeLogs": true,
                    "replyToAddress": "",
                    "includeIssueDetails": true,
                    "includeBotConfiguration": true,
                    "additionalRecipients": [],
                    "scmOptions": {
                        "FBDCD372C080F115B518613EB0C4141F30E28CCE": 1
                    },
                    "emailCommitters": true,
                    "fromAddress": "",
                    "type": 3,
                    "includeResolvedIssues": true,
                    "weeklyScheduleDay": 7,
                    "minutesAfterHour": 0,
                    "hour": 12
                },
                "type": 2,
                "name": "newissueemail",
                "conditions": {
                    "status": 2,
                    "onAllIssuesResolved": true,
                    "onWarnings": true,
                    "onBuildErrors": true,
                    "onAnalyzerWarnings": true,
                    "onFailingTests": true,
                    "onSuccess": false
                }
            },
            {
                "phase": 2,
                "scriptBody": "",
                "emailConfiguration": {
                    "ccAddresses": [],
                    "allowedDomainNames": [],
                    "includeCommitMessages": true,
                    "includeLogs": true,
                    "replyToAddress": "",
                    "includeIssueDetails": true,
                    "includeBotConfiguration": true,
                    "additionalRecipients": [],
                    "scmOptions": {
                        "FBDCD372C080F115B518613EB0C4141F30E28CCE": 1
                    },
                    "emailCommitters": true,
                    "fromAddress": "",
                    "type": 0,
                    "includeResolvedIssues": true,
                    "weeklyScheduleDay": 7,
                    "minutesAfterHour": 0,
                    "hour": 12
                },
                "type": 2,
                "name": "Periodic Email Report",
                "conditions": {
                    "status": 2,
                    "onAllIssuesResolved": true,
                    "onWarnings": true,
                    "onBuildErrors": true,
                    "onAnalyzerWarnings": true,
                    "onFailingTests": true,
                    "onSuccess": true
                }
            }
        ]
    """
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
}
