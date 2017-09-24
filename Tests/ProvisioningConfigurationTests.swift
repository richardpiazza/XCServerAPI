//
//  ProvisioningConfigurationTests.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 6/25/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import XCTest
@testable import XCServerAPI

class ProvisioningConfigurationTests: XCTestCase {
    
    let pc = """
        {
            "addMissingDevicesToTeams": false,
            "manageCertsAndProfiles": false
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
    
    func testProvisioningConfiguration() {
        guard let data = pc.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        var provisioningConfiguration: XCSProvisioningConfiguration
        do {
            provisioningConfiguration = try decoder.decode(XCSProvisioningConfiguration.self, from: data)
        } catch {
            print(error)
            XCTFail()
            return
        }
        
        XCTAssertFalse(provisioningConfiguration.addMissingDevicesToTeams)
        XCTAssertFalse(provisioningConfiguration.manageCertsAndProfiles)
    }
}
