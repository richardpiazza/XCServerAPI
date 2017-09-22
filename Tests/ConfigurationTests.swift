//
//  ConfigurationTests.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 6/25/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import XCTest
@testable import XCServerAPI

class ConfigurationTests: XCTestCase {
    
    /// "provisioningConfiguration": {}
    /// "deviceSpecification": {}
    /// "sourceControlBlueprint": {}
    let config = """
        {
            "triggers": [],
            "hourOfIntegration": 0,
            "performsUpgradeIntegration": false,
            "disableAppThinning": false,
            "periodicScheduleInterval": 0,
            "buildEnvironmentVariables": {},
            "schemeName": "XCServerAPI",
            "additionalBuildArguments": [],
            "codeCoveragePreference": 2,
            "performsTestAction": true,
            "scheduleType": 3,
            "useParallelDeviceTesting": true,
            "performsArchiveAction": false,
            "builtFromClean": 0,
            "performsAnalyzeAction": true,
            "exportsProductFromArchive": true,
            "weeklyScheduleDay": 0,
            "runOnlyDisabledTests": false,
            "testingDestinationType": 0,
            "minutesAfterHourToIntegrate": 0,
            "testLocalizations": []
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
    
    func testConfiguration() {
        guard let data = config.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        var configuration: Configuration
        do {
            configuration = try decoder.decode(Configuration.self, from: data)
        } catch {
            print(error)
            XCTFail()
            return
        }
        
        XCTAssertNotNil(configuration.triggers)
        XCTAssertEqual(configuration.triggers?.count, 0)
        XCTAssertEqual(configuration.hourOfIntegration, 0)
        XCTAssertEqual(configuration.performsUpgradeIntegration, false)
        XCTAssertEqual(configuration.disableAppThinning, false)
        XCTAssertEqual(configuration.periodicScheduleInterval, .none)
        XCTAssertNotNil(configuration.buildEnvironmentVariables)
        XCTAssertEqual(configuration.buildEnvironmentVariables?.count, 0)
        XCTAssertEqual(configuration.schemeName, "XCServerAPI")
        XCTAssertNotNil(configuration.additionalBuildArguments)
        XCTAssertEqual(configuration.additionalBuildArguments?.count, 0)
        XCTAssertEqual(configuration.codeCoveragePreference, .useSchemeSetting)
        XCTAssertEqual(configuration.performsTestAction, true)
        XCTAssertEqual(configuration.scheduleType, .manual)
        XCTAssertEqual(configuration.useParallelDeviceTesting, true)
        XCTAssertEqual(configuration.performsArchiveAction, false)
        XCTAssertEqual(configuration.builtFromClean, .never)
        XCTAssertEqual(configuration.performsAnalyzeAction, true)
        XCTAssertEqual(configuration.exportsProductFromArchive, true)
        XCTAssertEqual(configuration.weeklyScheduleDay, 0)
        XCTAssertEqual(configuration.runOnlyDisabledTests, false)
        XCTAssertEqual(configuration.testingDestinationType, 0)
        XCTAssertEqual(configuration.minutesAfterHourToIntegrate, 0)
        XCTAssertNotNil(configuration.testLocalizations)
        XCTAssertEqual(configuration.testLocalizations?.count, 0)
    }
}
