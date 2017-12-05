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
    
    func testTriggers() {
        guard let triggers = [XCSTrigger].decode(json: json) else {
            XCTFail()
            return
        }
        
        guard triggers.count == 4 else {
            XCTFail()
            return
        }
        
        let preIntegrationTrigger = triggers[0]
        XCTAssertEqual(preIntegrationTrigger.name, "preintegration")
        XCTAssertEqual(preIntegrationTrigger.phase, .beforeIntegration)
        XCTAssertEqual(preIntegrationTrigger.type, .script)
        XCTAssertNotNil(preIntegrationTrigger.scriptBody)
        guard let preIntegrationConditions = preIntegrationTrigger.conditions else {
            XCTFail()
            return
        }
        XCTAssertEqual(preIntegrationConditions.status, 2)
        XCTAssertEqual(preIntegrationConditions.onAllIssuesResolved, true)
        XCTAssertEqual(preIntegrationConditions.onWarnings, true)
        XCTAssertEqual(preIntegrationConditions.onBuildErrors, true)
        XCTAssertEqual(preIntegrationConditions.onAnalyzerWarnings, true)
        XCTAssertEqual(preIntegrationConditions.onFailingTests, true)
        XCTAssertEqual(preIntegrationConditions.onSuccess, true)
        
        let postIntegrationTrigger = triggers[1]
        XCTAssertEqual(postIntegrationTrigger.name, "postintegration")
        XCTAssertEqual(postIntegrationTrigger.phase, .afterIntegration)
        XCTAssertEqual(postIntegrationTrigger.type, .script)
        XCTAssertNotNil(postIntegrationTrigger.scriptBody)
        guard let postIntegrationConditions = postIntegrationTrigger.conditions else {
            XCTFail()
            return
        }
        XCTAssertEqual(postIntegrationConditions.status, 2)
        XCTAssertEqual(postIntegrationConditions.onAllIssuesResolved, true)
        XCTAssertEqual(postIntegrationConditions.onWarnings, true)
        XCTAssertEqual(postIntegrationConditions.onBuildErrors, true)
        XCTAssertEqual(postIntegrationConditions.onAnalyzerWarnings, true)
        XCTAssertEqual(postIntegrationConditions.onFailingTests, true)
        XCTAssertEqual(postIntegrationConditions.onSuccess, true)
        
        let newIssueEmailTrigger = triggers[2]
        XCTAssertEqual(newIssueEmailTrigger.name, "newissueemail")
        XCTAssertEqual(newIssueEmailTrigger.phase, .afterIntegration)
        XCTAssertEqual(newIssueEmailTrigger.type, .email)
        XCTAssertEqual(newIssueEmailTrigger.scriptBody, "")
        guard let newIssueEmailConditions = newIssueEmailTrigger.conditions else {
            XCTFail()
            return
        }
        XCTAssertEqual(newIssueEmailConditions.status, 2)
        XCTAssertEqual(newIssueEmailConditions.onAllIssuesResolved, true)
        XCTAssertEqual(newIssueEmailConditions.onWarnings, true)
        XCTAssertEqual(newIssueEmailConditions.onBuildErrors, true)
        XCTAssertEqual(newIssueEmailConditions.onAnalyzerWarnings, true)
        XCTAssertEqual(newIssueEmailConditions.onFailingTests, true)
        XCTAssertEqual(newIssueEmailConditions.onSuccess, false)
        guard let newIssueEmailConfiguration = newIssueEmailTrigger.emailConfiguration else {
            XCTFail()
            return
        }
        XCTAssertEqual(newIssueEmailConfiguration.ccAddresses?.count, 0)
        XCTAssertEqual(newIssueEmailConfiguration.allowedDomainNames?.count, 0)
        XCTAssertEqual(newIssueEmailConfiguration.includeCommitMessages, true)
        XCTAssertEqual(newIssueEmailConfiguration.includeLogs, true)
        XCTAssertEqual(newIssueEmailConfiguration.replyToAddress, "")
        XCTAssertEqual(newIssueEmailConfiguration.includeIssueDetails, true)
        XCTAssertEqual(newIssueEmailConfiguration.includeBotConfiguration, true)
        XCTAssertEqual(newIssueEmailConfiguration.additionalRecipients?.count, 0)
        XCTAssertEqual(newIssueEmailConfiguration.emailCommitters, true)
        XCTAssertEqual(newIssueEmailConfiguration.fromAddress, "")
        XCTAssertEqual(newIssueEmailConfiguration.type, .newIssueFoundEmail)
        XCTAssertEqual(newIssueEmailConfiguration.includeResolvedIssues, true)
        XCTAssertEqual(newIssueEmailConfiguration.weeklyScheduleDay, 7)
        XCTAssertEqual(newIssueEmailConfiguration.minutesAfterHour, 0)
        XCTAssertEqual(newIssueEmailConfiguration.hour, 12)
        
        let periodicEmailTrigger = triggers[3]
        XCTAssertEqual(periodicEmailTrigger.name, "Periodic Email Report")
        XCTAssertEqual(periodicEmailTrigger.phase, .afterIntegration)
        XCTAssertEqual(periodicEmailTrigger.type, .email)
        XCTAssertEqual(periodicEmailTrigger.scriptBody, "")
        guard let periodicEmailConditions = periodicEmailTrigger.conditions else {
            XCTFail()
            return
        }
        XCTAssertEqual(periodicEmailConditions.status, 2)
        XCTAssertEqual(periodicEmailConditions.onAllIssuesResolved, true)
        XCTAssertEqual(periodicEmailConditions.onWarnings, true)
        XCTAssertEqual(periodicEmailConditions.onBuildErrors, true)
        XCTAssertEqual(periodicEmailConditions.onAnalyzerWarnings, true)
        XCTAssertEqual(periodicEmailConditions.onFailingTests, true)
        XCTAssertEqual(periodicEmailConditions.onSuccess, true)
        guard let periodicEmailConfiguration = periodicEmailTrigger.emailConfiguration else {
            XCTFail()
            return
        }
        XCTAssertEqual(periodicEmailConfiguration.ccAddresses?.count, 0)
        XCTAssertEqual(periodicEmailConfiguration.allowedDomainNames?.count, 0)
        XCTAssertEqual(periodicEmailConfiguration.includeCommitMessages, true)
        XCTAssertEqual(periodicEmailConfiguration.includeLogs, true)
        XCTAssertEqual(periodicEmailConfiguration.replyToAddress, "")
        XCTAssertEqual(periodicEmailConfiguration.includeIssueDetails, true)
        XCTAssertEqual(periodicEmailConfiguration.includeBotConfiguration, true)
        XCTAssertEqual(periodicEmailConfiguration.additionalRecipients?.count, 0)
        XCTAssertEqual(periodicEmailConfiguration.emailCommitters, true)
        XCTAssertEqual(periodicEmailConfiguration.fromAddress, "")
        XCTAssertEqual(periodicEmailConfiguration.type, .integrationReport)
        XCTAssertEqual(periodicEmailConfiguration.includeResolvedIssues, true)
        XCTAssertEqual(periodicEmailConfiguration.weeklyScheduleDay, 7)
        XCTAssertEqual(periodicEmailConfiguration.minutesAfterHour, 0)
        XCTAssertEqual(periodicEmailConfiguration.hour, 12)
    }
}
