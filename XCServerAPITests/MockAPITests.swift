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
    let botIdentifier = "a7341f3521c7245492693c0d780006f9"
    let integrationIdentifier = "8a526f6a0ce6b83bb969758e0f0038b7"
    
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
        
        waitForExpectations(timeout: 5) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
    
    func testBots() {
        let exp = expectation(description: "bots")
        
        api.bots { (bots, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            guard let bs = bots else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(bs.count, 2)
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
    
    func testBot() {
        let exp = expectation(description: "bot")
        
        api.bot(withIdentifier: botIdentifier) { (bot, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            guard let b = bot else {
                XCTFail()
                return
            }
         
            XCTAssertEqual(b.integrationCounter, 15)
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
    
    func testBotStats() {
        let exp = expectation(description: "stats")
        
        api.stats(forBotWithIdentifier: botIdentifier) { (stats, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            guard let s = stats else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(s.warnings?.count, 7)
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
    
    func testBotIntegrations() {
        let exp = expectation(description: "integrations")
        
        api.integrations(forBotWithIdentifier: botIdentifier) { (integrations, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            guard let i = integrations else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(i.count, 14)
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
}
