//
//  MockAPITests.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 7/12/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import XCTest
@testable import XCServerAPI

class MockAPITests: XCTestCase {
    
    let api = MockAPI()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDiscoveryResponses() {
        let pingExpectation = expectation(description: "ping")
        let versionsExpectation = expectation(description: "versions")
        
        api.ping { (statusCode, headers, data, error) in
            guard statusCode == 204 else {
                XCTFail()
                return
            }
            
            pingExpectation.fulfill()
            
            self.api.versions({ (versions, apiVersion, error) in
                guard let version = apiVersion else {
                    XCTFail()
                    return
                }
                
                XCTAssertEqual(version, 18)
                
                versionsExpectation.fulfill()
            })
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
    
//    func testBots() {
//        let exp = expectation(description: "bots")
//        exp.fulfill()
//    }
//    
//    func testBot() {
//        let exp = expectation(description: "bot")
//        exp.fulfill()
//    }
//    
//    func testBotStats() {
//        let exp = expectation(description: "stats")
//        exp.fulfill()
//    }
//    
//    func testBotIntegrations() {
//        let exp = expectation(description: "integrations")
//        exp.fulfill()
//    }
}
