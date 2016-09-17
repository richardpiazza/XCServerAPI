//===----------------------------------------------------------------------===//
//
// JSONResponseTests.swift
//
// Copyright (c) 2016 Richard Piazza
// https://github.com/richardpiazza/XCServerCoreData
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//===----------------------------------------------------------------------===//

import XCTest
@testable import XCServerAPI

class JSONResponseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBotsResponse() {
        guard let response = Resources.Bots else {
            XCTFail()
            return
        }
        
        for bot in response.results {
            let configuration = bot.configuration
            XCTAssertNotNil(configuration)
            
            let lastRevision = bot.lastRevisionBlueprint
            XCTAssertNotNil(lastRevision)
            
            XCTAssertNotEqual(bot._id, "")
        }
    }
    
    func testBotResponse() {
        guard let bot = Resources.CodeQuickKit.Bot else {
            XCTFail()
            return
        }
        
        guard let revision = bot._rev else {
            XCTFail()
            return
        }
        
        XCTAssertNotEqual(revision, "")
        
        guard let blueprint = bot.lastRevisionBlueprint else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(blueprint.DVTSourceControlWorkspaceBlueprintNameKey, "CodeQuickKit")
        XCTAssertEqual(blueprint.DVTSourceControlWorkspaceBlueprintIdentifierKey, "D5C9B440-360C-46B5-941E-4E6BF1525503")
        
        guard let location = blueprint.DVTSourceControlWorkspaceBlueprintLocationsKey["3CBDEDAE95CE25E53B615AC684AAEE3F90A98DFE"] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(location.DVTSourceControlBranchIdentifierKey, "master")
    }
    
    func testStatsResponse() {
        guard let stats = Resources.Bakeshop.Stats else {
            XCTFail()
            return
        }
        
        guard let best = stats.bestSuccessStreak else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(best.success_streak?.intValue, 2)
        
        guard let analysis = stats.analysisWarnings else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(analysis.avg?.floatValue, 14.5)
        XCTAssertEqual(analysis.sum?.floatValue, 58)
        XCTAssertEqual(analysis.stdDev?.floatValue, 173.20508075688772)
    }
    
    func testIntegrationsResponse() {
        guard let response = Resources.Bakeshop.Integrations else {
            XCTFail()
            return
        }
        
        for integration in response.results {
            let assets = integration.assets
            XCTAssertNotNil(assets)
            
            if integration.currentStep == "completed" && integration.result == "succeeded" {
                let summary = integration.buildResultSummary
                XCTAssertNotNil(summary)
            }
            
            XCTAssertNotEqual(integration._id, "")
        }
    }
    
    func testIntegrationResponse() {
        guard let integration = Resources.Bakeshop.Integration else {
            XCTFail()
            return
        }
        
        guard let buildSummary = integration.buildResultSummary else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(buildSummary.warningChange, -2)
        XCTAssertEqual(buildSummary.testsCount, 3)
        
        guard let assets = integration.assets else {
            XCTFail()
            return
        }
        
        guard let log = assets.sourceControlLog else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(log.fileName, "sourceControl.log")
        XCTAssertEqual(log.size?.intValue, 2201)
        
        let devices = integration.testedDevices
        guard let device = devices.first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(device.platformIdentifier, "com.apple.platform.iphonesimulator")
        XCTAssertEqual(device.architecture, "i386")
        XCTAssertEqual(device.name, "iPhone 4s")
        XCTAssertEqual(device.connected, true)
        
        guard let tests = integration.testHierarchy else {
            XCTFail()
            return
        }
        
        guard let namedTests = tests["Bakeshop Tests"] as? [String : AnyObject] else {
            XCTFail()
            return
        }
        
        guard let serializationTests = namedTests["SerializationTests"] as? [String : AnyObject] else {
            XCTFail()
            return
        }
        
        guard let recipeTest = serializationTests["testSerializeComplexeRecipe()"] as? [String : NSNumber] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(recipeTest["F6B2A590-E67B-40F7-8857-7290451769A4"]?.intValue, 1)
        
        XCTAssertNotNil(integration._id, "")
    }
    
    func testIntegrationIssuesResponse() {
        guard let response = Resources.Bakeshop.Issues else {
            XCTFail()
            return
        }
        
        guard let warnings = response.warnings else {
            XCTFail()
            return
        }
        
        guard let issue = warnings.resolvedIssues.first else {
            XCTFail()
            return
        }
        
        XCTAssertNotEqual(issue._id, "")
        XCTAssertEqual(issue.target, "Bakeshop")
        XCTAssertEqual(issue.age, 79)
        XCTAssertEqual(issue.type, "warning")
        XCTAssertEqual(issue.issueType, "Swift Compiler Warning")
    }
    
    func testIntegrationCommitsResponse() {
        guard let response = Resources.Bakeshop.Commits else {
            XCTFail()
            return
        }
        
        guard let commits = response.results.first else {
            XCTFail()
            return
        }
        
        XCTAssertNotEqual(commits._id, "")
        
        guard let commit = commits.commits["6139C8319FDE4527BFD4EA6334BA1CE5BC0DE9DF"]?.first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(commit.XCSCommitHash, "acb245fde35565f98e09b02a5540f8735fd18682")
        XCTAssertEqual(commit.XCSCommitCommitChangeFilePaths.count, 2)
        
        guard let contributor = commit.XCSCommitContributor else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(contributor.XCSContributorName, "Richard Piazza")
    }
}
