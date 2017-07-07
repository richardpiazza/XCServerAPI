//
//  AssetsTests.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 7/7/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import XCTest
@testable import XCServerAPI

class AssetsTests: XCTestCase {
    
    let json = """
        {
            "xcodebuildOutput": {
                "size": 3183346,
                "fileName": "xcodebuild_result.bundle.zip",
                "allowAnonymousAccess": false,
                "relativePath": "a7341f3521c7245492693c0d780006f9-XCServerAPI Bot/8/xcodebuild_result.bundle.zip"
            },
            "buildServiceLog": {
                "size": 13890,
                "fileName": "buildService.log",
                "allowAnonymousAccess": false,
                "relativePath": "a7341f3521c7245492693c0d780006f9-XCServerAPI Bot/8/buildService.log"
            },
            "xcodebuildLog": {
                "size": 1074831,
                "fileName": "xcodebuild.log",
                "allowAnonymousAccess": false,
                "relativePath": "a7341f3521c7245492693c0d780006f9-XCServerAPI Bot/8/xcodebuild.log"
            },
            "triggerAssets": [
                {
                    "size": 32,
                    "fileName": "trigger-after-0.log",
                    "allowAnonymousAccess": false,
                    "triggerName": "postintegration",
                    "relativePath": "a7341f3521c7245492693c0d780006f9-XCServerAPI Bot/8/trigger-after-0.log"
                },
                {
                    "size": 31,
                    "fileName": "trigger-before-0.log",
                    "allowAnonymousAccess": false,
                    "triggerName": "preintegration",
                    "relativePath": "a7341f3521c7245492693c0d780006f9-XCServerAPI Bot/8/trigger-before-0.log"
                }
            ],
            "sourceControlLog": {
                "size": 2223,
                "fileName": "sourceControl.log",
                "allowAnonymousAccess": false,
                "relativePath": "a7341f3521c7245492693c0d780006f9-XCServerAPI Bot/8/sourceControl.log"
            }
        }
    """
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
}
