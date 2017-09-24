//
//  DecodableTests.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 7/14/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import XCTest
@testable import XCServerAPI

class DecodableTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInvalidDecodable() {
        let invalidJson = "{}"
        var versionDocument = XCSVersion.decode(json: invalidJson)
        XCTAssertNil(versionDocument)
        
        let invalidString = String()
        versionDocument = XCSVersion.decode(json: invalidString)
        XCTAssertNil(versionDocument)
        
        let invalidData = Data()
        versionDocument = XCSVersion.decode(data: invalidData)
        XCTAssertNil(versionDocument)
    }
}
