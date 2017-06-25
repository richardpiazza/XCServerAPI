//
//  BotTests.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 6/25/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import XCTest
@testable import XCServerAPI

class BotTests: XCTestCase {
    
    /// "configuration": {}
    /// "lastRevisionBlueprint": {}
    let json = """
        {
            "_id": "a7341f3521c7245492693c0d780006f9",
            "_rev": "11-764d634b664b50ed94f555fbaedb67b7",
            "group": {
                "name": "5C5B2618-7DF5-41AF-A799-14AEA4A93EFC"
            },
            "requiresUpgrade": false,
            "name": "XCServerAPI Bot",
            "type": 1,
            "sourceControlBlueprintIdentifier": "2FEE1B6D-3998-4075-BD05-E40164005048",
            "integration_counter": 5,
            "doc_type": "bot",
            "tinyID": "7803918",
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
    
    func testBot() {
        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        var bot: BotDocument
        do {
            bot = try decoder.decode(BotDocument.self, from: data)
        } catch {
            print(error)
            XCTFail()
            return
        }
        
        XCTAssertEqual(bot._id, "a7341f3521c7245492693c0d780006f9")
        XCTAssertEqual(bot._rev, "11-764d634b664b50ed94f555fbaedb67b7")
        XCTAssertEqual(bot.group.name, "5C5B2618-7DF5-41AF-A799-14AEA4A93EFC")
        XCTAssertEqual(bot.requiresUpgrade, false)
        XCTAssertEqual(bot.name, "XCServerAPI Bot")
        XCTAssertEqual(bot.type, 1)
        XCTAssertEqual(bot.sourceControlBlueprintIdentifier, "2FEE1B6D-3998-4075-BD05-E40164005048")
        XCTAssertEqual(bot.integrationCounter, 5)
        XCTAssertEqual(bot.docType, "bot")
        XCTAssertEqual(bot.tinyID, "7803918")
        XCTAssertNil(bot.configuration)
        XCTAssertNil(bot.lastRevisionBlueprint)
    }
}
