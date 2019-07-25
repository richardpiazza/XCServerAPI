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
    
    let api: MockAPI = {
        do {
            return try MockAPI()
        } catch {
            fatalError("Failed to instantiate MockAPI")
        }
    }()
    
    let invalidApi: InvalidMockAPI = {
        do {
            return try InvalidMockAPI()
        } catch {
            fatalError("Failed to instantiate InvalidMockAPI")
        }
    }()
    
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
        
        api.ping { (result) in
            switch result {
            case .value:
                exp.fulfill()
            default:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
    
    func testInvalidPing() {
        let exp = expectation(description: "ping")
        
        invalidApi.ping { (result) in
            switch result {
            case .error(let error):
                // SC: 404
                print(error)
                exp.fulfill()
            default:
                XCTFail()
            }
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
        
        api.versions { (result) in
            switch result {
            case .value(let value):
                XCTAssertEqual(value.1, 18)
                exp.fulfill()
            default:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
    
    func testInvalidVersions() {
        let exp = expectation(description: "versions")
        
        invalidApi.versions { (result) in
            switch result {
            case .error(_):
                // type: XCServerWebAPI.Errors.decodeResponse
                exp.fulfill()
            default:
                XCTFail()
            }
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
        
        api.bots { (result) in
            switch result {
            case .value(let bots):
                XCTAssertEqual(bots.count, 2)
                exp.fulfill()
            default:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
    
    func testInvalidBots() {
        let exp = expectation(description: "bots")
        
        invalidApi.bots { (result) in
            switch result {
            case .error(_):
                // type: XCServerWebAPI.Errors.authorization
                exp.fulfill()
            default:
                XCTFail()
            }
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
        
        api.bot(withIdentifier: botIdentifier) { (result) in
            switch result {
            case .value(let bot):
                XCTAssertEqual(bot.integrationCounter, 15)
                exp.fulfill()
            default:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
    
    func testInvalidBot() {
        let exp = expectation(description: "bot")
        
        invalidApi.bot(withIdentifier: botIdentifier) { (result) in
            switch result {
            case .error(_):
                // type: XCServerWebAPI.Errors.noXcodeServer
                exp.fulfill()
            default:
                XCTFail()
            }
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
        
        api.stats(forBotWithIdentifier: botIdentifier) { (result) in
            switch result {
            case .value(let stats):
                XCTAssertEqual(stats.warnings?.count, 7)
                exp.fulfill()
            default:
                XCTFail()
            }
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
        
        api.integrations(forBotWithIdentifier: botIdentifier) { (result) in
            switch result {
            case .value(let integrations):
                XCTAssertEqual(integrations.count, 14)
                exp.fulfill()
            default:
                XCTFail()
            }
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
        
        api.runIntegration(forBotWithIdentifier: botIdentifier) { (result) in
            switch result {
            case .value(let integration):
                XCTAssertEqual(integration.number, 15)
                XCTAssertEqual(integration.currentStep, .pending)
                exp.fulfill()
            default:
                XCTFail()
            }
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
        
        api.integration(withIdentifier: integrationIdentifier) { (result) in
            switch result {
            case .value(let integration):
                XCTAssertEqual(integration.number, 14)
                XCTAssertEqual(integration.result, .succeeded)
                XCTAssertNotNil(integration.testHierarchy)
                XCTAssertFalse(integration.testHierarchy!.hasFailures)
                exp.fulfill()
            default:
                XCTFail()
            }
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
        
        api.commits(forIntegrationWithIdentifier: integrationIdentifier) { (result) in
            switch result {
            case .value(let commits):
                XCTAssertEqual(commits.count, 1)
                
                guard let commit = commits.first else {
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
            default:
                XCTFail()
            }
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
        
        api.issues(forIntegrationWithIdentifier: integrationIdentifier) { (result) in
            switch result {
            case .value(let issues):
                XCTAssertEqual(issues.warnings?.resolvedIssues.count, 1)
                
                guard let issue = issues.warnings?.resolvedIssues.first else {
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
            default:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
    
    func testVerifyErrors() {
        var error: XCServerClientError = .fqdn
        XCTAssertEqual(error.localizedDescription, "Attempted to initialize with an invalid FQDN.")
        
        error = .xcodeServer
        XCTAssertEqual(error.localizedDescription, "This class was initialized without an XcodeServer entity.")
        
        error = .authorization
        XCTAssertEqual(error.localizedDescription, "The server returned a 401 response code.")
        
        error = .response
        XCTAssertEqual(error.localizedDescription, "The response did not contain valid data.")
        
        error = .serilization
        XCTAssertEqual(error.localizedDescription, "The response object could not be cast into the requested type.")
    }
}
