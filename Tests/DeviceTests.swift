//
//  DeviceTests.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 6/25/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import XCTest
@testable import XCServerAPI

class DeviceTests: XCTestCase {
    
    let json = """
        {
            "activeProxiedDevice": {
                "modelUTI": "com.apple.watch-42mm-series2-1",
                "connected": true,
                "modelCode": "Watch2,4",
                "simulator": true,
                "osVersion": "4.0",
                "modelName": "Apple Watch Series 2 - 42mm",
                "deviceType": "com.apple.iphone-simulator",
                "supported": true,
                "identifier": "73389756-7707-4E18-93A2-DEB08CE8B6E7",
                "enabledForDevelopment": true,
                "architecture": "i386",
                "isServer": false,
                "doc_type": "device",
                "trusted": true,
                "platformIdentifier": "com.apple.platform.watchsimulator",
                "name": "Apple Watch Series 2 - 42mm",
                "retina": false
            },
            "osVersion": "11.0",
            "connected": true,
            "simulator": true,
            "modelCode": "iPhone9,2",
            "deviceType": "com.apple.iphone-simulator",
            "modelName": "iPhone 7 Plus",
            "revision": "9797-851af72b8e7c6de6b0500b5585455703",
            "modelUTI": "com.apple.iphone-7-plus-1",
            "name": "iPhone 7 Plus",
            "trusted": true,
            "doc_type": "device",
            "supported": true,
            "identifier": "9B0227C6-807D-4E6D-B7A1-0064524E7334",
            "enabledForDevelopment": true,
            "platformIdentifier": "com.apple.platform.iphonesimulator",
            "ID": "7b0bfdf8f209bf9b85b8aa020500cca7",
            "architecture": "x86_64",
            "retina": false,
            "isServer": false,
            "tinyID": "7505AAB"
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
    
    func testDevice() {
        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        var device: DeviceDocument
        do {
            device = try decoder.decode(DeviceDocument.self, from: data)
        } catch {
            print(error)
            XCTFail()
            return
        }
        
        XCTAssertEqual(device.osVersion, "11.0")
        XCTAssertEqual(device.connected, true)
        XCTAssertEqual(device.simulator, true)
        XCTAssertEqual(device.modelCode, "iPhone9,2")
        XCTAssertEqual(device.deviceType, "com.apple.iphone-simulator")
        XCTAssertEqual(device.modelName, "iPhone 7 Plus")
        XCTAssertEqual(device.revision, "9797-851af72b8e7c6de6b0500b5585455703")
        XCTAssertEqual(device.modelUTI, "com.apple.iphone-7-plus-1")
        XCTAssertEqual(device.name, "iPhone 7 Plus")
        XCTAssertEqual(device.trusted, true)
        XCTAssertEqual(device.docType, "device")
        XCTAssertEqual(device.supported, true)
        XCTAssertEqual(device.identifier, "9B0227C6-807D-4E6D-B7A1-0064524E7334")
        XCTAssertEqual(device.enabledForDevelopment, true)
        XCTAssertEqual(device.platformIdentifier, "com.apple.platform.iphonesimulator")
        XCTAssertEqual(device.ID, "7b0bfdf8f209bf9b85b8aa020500cca7")
        XCTAssertEqual(device.architecture, "x86_64")
        XCTAssertEqual(device.retina, false)
        XCTAssertEqual(device.isServer, false)
        XCTAssertEqual(device.tinyID, "7505AAB")
        
        guard let proxiedDevice = device.activeProxiedDevice else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(proxiedDevice.modelUTI, "com.apple.watch-42mm-series2-1")
        XCTAssertEqual(proxiedDevice.connected, true)
        XCTAssertEqual(proxiedDevice.modelCode, "Watch2,4")
        XCTAssertEqual(proxiedDevice.simulator, true)
        XCTAssertEqual(proxiedDevice.osVersion, "4.0")
        XCTAssertEqual(proxiedDevice.modelName, "Apple Watch Series 2 - 42mm")
        XCTAssertEqual(proxiedDevice.deviceType, "com.apple.iphone-simulator")
        XCTAssertEqual(proxiedDevice.supported, true)
        XCTAssertEqual(proxiedDevice.identifier, "73389756-7707-4E18-93A2-DEB08CE8B6E7")
        XCTAssertEqual(proxiedDevice.enabledForDevelopment, true)
        XCTAssertEqual(proxiedDevice.architecture, "i386")
        XCTAssertEqual(proxiedDevice.isServer, false)
        XCTAssertEqual(proxiedDevice.docType, "device")
        XCTAssertEqual(proxiedDevice.trusted, true)
        XCTAssertEqual(proxiedDevice.platformIdentifier, "com.apple.platform.watchsimulator")
        XCTAssertEqual(proxiedDevice.name, "Apple Watch Series 2 - 42mm")
        XCTAssertEqual(proxiedDevice.retina, false)
    }
}
