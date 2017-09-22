//
//  TestHierarchyTests.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 6/25/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import XCTest
@testable import XCServerAPI

class TestHierarchyTests: XCTestCase {
    
    let json = """
        {
            "XCServerAPITests": {
                "RepositoryBlueprintTests": {
                    "testRevisionBlueprint()": {
                        "56951068-6554-4286-A5F4-A4BFACC6AC09": 1,
                        "610E1DAC-B998-47AA-9265-0D637751D578": 1,
                        "037C7660-993F-4645-816B-3EF6054C6999": 1,
                        "C738F84C-1AFB-424F-A12F-38B9F5F264DC": 1,
                        "42AEFA93-EB65-4392-8207-F809BCB46F6C": 1,
                        "F9F320A4-E114-4782-85A3-F9AA49849027": 1,
                        "D08EA7F9-C9EF-4B92-8EA9-49B0B8C7C487": 1,
                        "58649C3E-3496-4F16-8612-F4CABD8353A8": 1,
                        "5A52C8C4-B1E7-4E4F-B7A7-5387FAD60A33": 1,
                        "5683264C-37B7-43B7-A837-17A6A709720F": 1,
                        "1CFE8A83-0920-40FE-81C9-59BEFC06E79A": 1,
                        "8B077D3E-22B9-4E82-AC90-446F46969909": 1,
                        "3BC0F91B-1840-429F-B778-AFECB76E41A7": 1,
                        "9B0227C6-807D-4E6D-B7A1-0064524E7334": 1,
                        "C2265CA7-4A6F-4CDD-96D2-7C2D619BD91A": 1
                    },
                    "testSourceControlBlueprint()": {
                        "56951068-6554-4286-A5F4-A4BFACC6AC09": 1,
                        "610E1DAC-B998-47AA-9265-0D637751D578": 1,
                        "037C7660-993F-4645-816B-3EF6054C6999": 1,
                        "C738F84C-1AFB-424F-A12F-38B9F5F264DC": 1,
                        "42AEFA93-EB65-4392-8207-F809BCB46F6C": 1,
                        "F9F320A4-E114-4782-85A3-F9AA49849027": 1,
                        "D08EA7F9-C9EF-4B92-8EA9-49B0B8C7C487": 1,
                        "58649C3E-3496-4F16-8612-F4CABD8353A8": 1,
                        "5A52C8C4-B1E7-4E4F-B7A7-5387FAD60A33": 1,
                        "5683264C-37B7-43B7-A837-17A6A709720F": 1,
                        "1CFE8A83-0920-40FE-81C9-59BEFC06E79A": 1,
                        "8B077D3E-22B9-4E82-AC90-446F46969909": 1,
                        "3BC0F91B-1840-429F-B778-AFECB76E41A7": 1,
                        "9B0227C6-807D-4E6D-B7A1-0064524E7334": 1,
                        "C2265CA7-4A6F-4CDD-96D2-7C2D619BD91A": 1
                    },
                    "_xcsAggrDeviceStatus": {
                        "56951068-6554-4286-A5F4-A4BFACC6AC09": 1,
                        "610E1DAC-B998-47AA-9265-0D637751D578": 1,
                        "037C7660-993F-4645-816B-3EF6054C6999": 1,
                        "C738F84C-1AFB-424F-A12F-38B9F5F264DC": 1,
                        "42AEFA93-EB65-4392-8207-F809BCB46F6C": 1,
                        "F9F320A4-E114-4782-85A3-F9AA49849027": 1,
                        "D08EA7F9-C9EF-4B92-8EA9-49B0B8C7C487": 1,
                        "58649C3E-3496-4F16-8612-F4CABD8353A8": 1,
                        "5A52C8C4-B1E7-4E4F-B7A7-5387FAD60A33": 1,
                        "5683264C-37B7-43B7-A837-17A6A709720F": 1,
                        "1CFE8A83-0920-40FE-81C9-59BEFC06E79A": 1,
                        "8B077D3E-22B9-4E82-AC90-446F46969909": 1,
                        "3BC0F91B-1840-429F-B778-AFECB76E41A7": 1,
                        "9B0227C6-807D-4E6D-B7A1-0064524E7334": 1,
                        "C2265CA7-4A6F-4CDD-96D2-7C2D619BD91A": 1
                    }
                }
            }
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
    
    func testTestHierarchy() {
        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        var hierarchy: TestHierarchy
        do {
            hierarchy = try decoder.decode(TestHierarchy.self, from: data)
        } catch {
            print(error)
            XCTFail()
            return
        }
        
        guard let module = hierarchy["XCServerAPITests"] else {
            XCTFail()
            return
        }
        
        guard let `class` = module["RepositoryBlueprintTests"] else {
            XCTFail()
            return
        }
        
        guard let results = `class`.methodResults else {
            XCTFail()
            return
        }
        
        guard let sourceControlTest = results["testSourceControlBlueprint()"] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(sourceControlTest.keys.count, 15)
        
        guard let deviceResult = sourceControlTest["9B0227C6-807D-4E6D-B7A1-0064524E7334"] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(deviceResult, 1)
    }
}
