//
//  CommitTests.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 6/26/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import XCTest
@testable import XCServerAPI

class CommitTests: XCTestCase {
    
    let json = """
        {
            "_id": "d7f19e1d0b0f1ea270f60154c21dec9e",
            "_rev": "3-7ddfc480b7c985b59eb4449fd3f5e4af",
            "commits": {
                "FBDCD372C080F115B518613EB0C4141F30E28CCE": [
                    {
                        "XCSBlueprintRepositoryID": "FBDCD372C080F115B518613EB0C4141F30E28CCE",
                        "XCSCommitCommitChangeFilePaths": [
                            {
                                "status": 4,
                                "filePath": "Sources/BuildResultSummaryJSON.swift"
                            },
                            {
                                "status": 4,
                                "filePath": "Sources/DeviceJSON.swift"
                            },
                            {
                                "status": 4,
                                "filePath": "XCServerAPITests/DeviceTests.swift"
                            },
                            {
                                "status": 4,
                                "filePath": "Sources/IntegrationJSON.swift"
                            },
                            {
                                "status": 4,
                                "filePath": "XCServerAPITests/IntegrationTests.swift"
                            },
                            {
                                "status": 4,
                                "filePath": "Sources/ProxiedDevice.swift"
                            }
                        ],
                        "XCSCommitContributor": {
                            "XCSContributorEmails": [
                                "richard@richardpiazza.com"
                            ],
                            "XCSContributorName": "Richard Piazza",
                            "XCSContributorDisplayName": "Richard Piazza"
                        },
                        "XCSCommitHash": "e8e94b57de8d5ca012683e978b494b71c92fbf17",
                        "XCSCommitMessage": "Swift 4 Integration\n",
                        "XCSCommitIsMerge": "NO",
                        "XCSCommitTimestamp": "2017-06-26T17:06:13.000Z",
                        "XCSCommitTimestampDate": [
                            2017,
                            6,
                            26,
                            17,
                            6,
                            13,
                            0
                        ]
                    },
                    {
                        "XCSBlueprintRepositoryID": "FBDCD372C080F115B518613EB0C4141F30E28CCE",
                        "XCSCommitCommitChangeFilePaths": [
                            {
                                "status": 4,
                                "filePath": "Sources/AssetJSON.swift"
                            },
                            {
                                "status": 1,
                                "filePath": "XCServerAPITests/TestHierarchyTests.swift"
                            }
                        ],
                        "XCSCommitContributor": {
                            "XCSContributorEmails": [
                                "richard@richardpiazza.com"
                            ],
                            "XCSContributorName": "Richard Piazza",
                            "XCSContributorDisplayName": "Richard Piazza"
                        },
                        "XCSCommitHash": "631c25dda78202667e462d3945382111dbadd865",
                        "XCSCommitMessage": "Swift 4 Device/Test Hierarchy\n",
                        "XCSCommitIsMerge": "NO",
                        "XCSCommitTimestamp": "2017-06-26T13:34:18.000Z",
                        "XCSCommitTimestampDate": [
                            2017,
                            6,
                            26,
                            13,
                            34,
                            18,
                            0
                        ]
                    }
                ]
            },
            "integration": "d7f19e1d0b0f1ea270f60154c21ddd0d",
            "botID": "a7341f3521c7245492693c0d780006f9",
            "botTinyID": "7803918",
            "endedTimeDate": [
                2017,
                6,
                26,
                23,
                33,
                29,
                380
            ],
            "doc_type": "commit",
            "tinyID": "6907B14"
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
    
    func testCommitDocument() {
        guard let commitDocument = XCSCommit.decode(json: json) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(commitDocument._id, "d7f19e1d0b0f1ea270f60154c21dec9e")
        XCTAssertEqual(commitDocument._rev, "3-7ddfc480b7c985b59eb4449fd3f5e4af")
        XCTAssertEqual(commitDocument.integration, "d7f19e1d0b0f1ea270f60154c21ddd0d")
        XCTAssertEqual(commitDocument.botID, "a7341f3521c7245492693c0d780006f9")
        XCTAssertEqual(commitDocument.botTinyID, "7803918")
        XCTAssertEqual(commitDocument.docType, "commit")
        XCTAssertEqual(commitDocument.tinyID, "6907B14")
        XCTAssertEqual(commitDocument.endedTimeDate?.count, 7)
        XCTAssertEqual(commitDocument.commits?.keys.count, 1)
        
        let repositoryID = "FBDCD372C080F115B518613EB0C4141F30E28CCE"
        
        guard let commits = commitDocument.commits?[repositoryID] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(commits.count, 2)
        
        guard let first = commits.first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(first.repositoryID, repositoryID)
        XCTAssertNotNil(first.commitChangeFilePaths)
        XCTAssertEqual(first.commitChangeFilePaths?.count, 6)
        XCTAssertEqual(first.commitChangeFilePaths![1].filePath, "Sources/DeviceJSON.swift")
        XCTAssertNotNil(first.contributor)
        XCTAssertEqual(first.contributor?.emails?.count, 1)
        XCTAssertEqual(first.contributor!.displayName, "Richard Piazza")
        XCTAssertEqual(first.hash, "e8e94b57de8d5ca012683e978b494b71c92fbf17")
        XCTAssertEqual(first.message, "Swift 4 Integration")
        XCTAssertEqual(first.isMerge, "NO")
        XCTAssertNotNil(first.timestamp)
        var date = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 2017, month: 06, day: 26, hour: 17, minute: 06, second: 13, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil).date!
        var match = Calendar.current.compare(first.timestamp!, to: date, toGranularity: .second)
        XCTAssertTrue(match == .orderedSame)
        XCTAssertEqual(first.timestampDate?.count, 7)
        
        guard let second = commits.last else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(second.repositoryID, repositoryID)
        XCTAssertNotNil(second.commitChangeFilePaths)
        XCTAssertEqual(second.commitChangeFilePaths?.count, 2)
        XCTAssertEqual(second.commitChangeFilePaths![1].filePath, "XCServerAPITests/TestHierarchyTests.swift")
        XCTAssertNotNil(second.contributor)
        XCTAssertEqual(second.contributor?.emails?.count, 1)
        XCTAssertEqual(second.contributor!.displayName, "Richard Piazza")
        XCTAssertEqual(second.hash, "631c25dda78202667e462d3945382111dbadd865")
        XCTAssertEqual(second.message, "Swift 4 Device/Test Hierarchy")
        XCTAssertEqual(second.isMerge, "NO")
        XCTAssertNotNil(second.timestamp)
        date = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 2017, month: 06, day: 26, hour: 13, minute: 34, second: 18, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil).date!
        match = Calendar.current.compare(second.timestamp!, to: date, toGranularity: .second)
        XCTAssertTrue(match == .orderedSame)
        XCTAssertEqual(second.timestampDate?.count, 7)
    }
}
