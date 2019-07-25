import XCTest
@testable import XCServerAPI

class IssueTests: XCTestCase {
    
    let json = """
        {
            "buildServiceErrors": [
                {
                    "_id": "2286f794a9593d215b14353c88003ddc",
                    "_rev": "4-ded492faa8669e75813590bed735127f",
                    "message": "Couldn’t communicate with a helper application.",
                    "type": "buildServiceError",
                    "fixItType": "scm-failure",
                    "issueType": "buildServiceError",
                    "commits": [],
                    "integrationID": "2286f794a9593d215b14353c88001968",
                    "age": 0,
                    "status": 0,
                    "issueAuthors": []
                }
            ],
            "buildServiceWarnings": [
                {
                    "_id": "2286f794a9593d215b14353c88002e3e",
                    "_rev": "4-b37166c811e0b3a991840427c27d8e4c",
                    "message": "An error occurred updating existing checkout. Falling back to a clean checkout.",
                    "type": "buildServiceWarning",
                    "issueType": "buildServiceWarning",
                    "commits": [],
                    "integrationID": "2286f794a9593d215b14353c88001968",
                    "age": 0,
                    "status": 0,
                    "issueAuthors": []
                }
            ],
            "triggerErrors": [],
            "errors": {
                "unresolvedIssues": [],
                "freshIssues": [],
                "resolvedIssues": [],
                "silencedIssues": []
            },
            "warnings": {
                "unresolvedIssues": [],
                "freshIssues": [],
                "resolvedIssues": [],
                "silencedIssues": []
            },
            "testFailures": {
                "unresolvedIssues": [],
                "freshIssues": [],
                "resolvedIssues": [],
                "silencedIssues": []
            },
            "analyzerWarnings": {
                "unresolvedIssues": [],
                "freshIssues": [],
                "resolvedIssues": [],
                "silencedIssues": []
            }
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
    
    func testIssues() {
        guard let issues = XCServerClient.Issues.decode(json: json) else {
            XCTFail()
            return
        }
        
        guard let buildServiceErrors = issues.buildServiceErrors else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(buildServiceErrors.count, 1)
        
        guard let error = buildServiceErrors.first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(error._id, "2286f794a9593d215b14353c88003ddc")
        XCTAssertEqual(error._rev, "4-ded492faa8669e75813590bed735127f")
        XCTAssertEqual(error.message, "Couldn’t communicate with a helper application.")
        XCTAssertEqual(error.type, "buildServiceError")
        XCTAssertEqual(error.fixItType, "scm-failure")
        XCTAssertEqual(error.issueType, "buildServiceError")
        XCTAssertNotNil(error.commits)
        XCTAssertEqual(error.commits?.count, 0)
        XCTAssertEqual(error.integrationID, "2286f794a9593d215b14353c88001968")
        XCTAssertEqual(error.age, 0)
        XCTAssertEqual(error.status, 0)
        XCTAssertNotNil(error.issueAuthors)
        XCTAssertEqual(error.issueAuthors?.count, 0)
        
        guard let buildServiceWarnings = issues.buildServiceWarnings else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(buildServiceWarnings.count, 1)
        
        guard let warning = buildServiceWarnings.first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(warning._id, "2286f794a9593d215b14353c88002e3e")
        XCTAssertEqual(warning._rev, "4-b37166c811e0b3a991840427c27d8e4c")
        XCTAssertEqual(warning.message, "An error occurred updating existing checkout. Falling back to a clean checkout.")
        XCTAssertEqual(warning.type, "buildServiceWarning")
        XCTAssertNil(warning.fixItType)
        XCTAssertEqual(warning.issueType, "buildServiceWarning")
        XCTAssertNotNil(warning.commits)
        XCTAssertEqual(warning.commits?.count, 0)
        XCTAssertEqual(warning.integrationID, "2286f794a9593d215b14353c88001968")
        XCTAssertEqual(warning.age, 0)
        XCTAssertEqual(warning.status, 0)
        XCTAssertNotNil(warning.issueAuthors)
        XCTAssertEqual(warning.issueAuthors?.count, 0)
    }
}
