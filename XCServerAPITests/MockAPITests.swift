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
    
    func testPing() {
        let exp = expectation(description: "ping")
        
        api.ping { (statusCode, headers, data, error) in
            guard statusCode == 204 else {
                XCTFail()
                return
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
    
    func testVersions() {
        let exp = expectation(description: "versions")
        
        api.versions({ (versions, apiVersion, error) in
            guard let version = apiVersion else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(version, 18)
            
            exp.fulfill()
        })
        
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
    
    func testRequestIntegration() {
        let exp = expectation(description: "integrations")
        
        api.runIntegration(forBotWithIdentifier: botIdentifier) { (integration, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            guard let i = integration else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(i.number, 15)
            XCTAssertEqual(i.currentStep, .pending)
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
    
    func testIntegration() {
        let exp = expectation(description: "integration")
        
        api.integration(withIdentifier: integrationIdentifier) { (integration, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            guard let i = integration else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(i.number, 14)
            XCTAssertEqual(i.result, .succeeded)
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
    
    func testCommits() {
        let exp = expectation(description: "commits")
        
        api.commits(forIntegrationWithIdentifier: integrationIdentifier) { (commits, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            guard let c = commits else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(c.count, 1)
            
            guard let commit = c.first else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(commit._rev, "3-30a51c2080754b8762455e97f9633184")
            
            guard let repoCommits = commit.commits?["FBDCD372C080F115B518613EB0C4141F30E28CCE"] else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(repoCommits.first?.commitChangeFilePaths?.count, 23)
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
    
    func testIssues() {
        let exp = expectation(description: "issues")
        
        api.issues(forIntegrationWithIdentifier: integrationIdentifier) { (issues, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            guard let i = issues else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(i.warnings?.resolvedIssues.count, 1)
            
            guard let issue = i.warnings?.resolvedIssues.first else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(issue.age, 2)
            
            guard let suspectStrategy = issue.issueAuthors?.first?.suspectStrategy else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(suspectStrategy.reliability, 30)
            
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
