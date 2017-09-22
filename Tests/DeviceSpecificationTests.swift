//
//  DeviceSpecificationTests.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 6/24/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import XCTest
@testable import XCServerAPI

class DeviceSpecificationTests: XCTestCase {
    
    let ds = """
        {
            "filters": [
                {
                    "platform": {
                        "_id": "81a37f1603cadd6069d5b856520035c8",
                        "_rev": "231-60161daf2b8792858b98069f2df05adb",
                        "displayName": "iOS",
                        "simulatorIdentifier": "com.apple.platform.iphonesimulator",
                        "identifier": "com.apple.platform.iphoneos",
                        "buildNumber": "15A5304f",
                        "version": "11.0"
                    },
                    "filterType": 2,
                    "architectureType": 0
                }
          ],
          "deviceIdentifiers": []
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
    
    func testSpecification() {
        guard let data = ds.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        var deviceSpecification: DeviceSpecification
        do {
            deviceSpecification = try decoder.decode(DeviceSpecification.self, from: data)
        } catch {
            print(error)
            XCTFail()
            return
        }
        
        XCTAssertNotNil(deviceSpecification.deviceIdentifiers)
        XCTAssertEqual(deviceSpecification.deviceIdentifiers?.count, 0)
        
        guard let filter = deviceSpecification.filters?.first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(filter.filterType, 2)
        XCTAssertEqual(filter.architectureType, 0)
        
        guard let platform = filter.platform else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(platform._id, "81a37f1603cadd6069d5b856520035c8")
        XCTAssertEqual(platform._rev, "231-60161daf2b8792858b98069f2df05adb")
        XCTAssertEqual(platform.displayName, "iOS")
        XCTAssertEqual(platform.simulatorIdentifier, "com.apple.platform.iphonesimulator")
        XCTAssertEqual(platform.identifier, "com.apple.platform.iphoneos")
        XCTAssertEqual(platform.buildNumber, "15A5304f")
        XCTAssertEqual(platform.version, "11.0")
    }
}
