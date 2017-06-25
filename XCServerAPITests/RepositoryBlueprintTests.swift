//
//  RepositoryBlueprintTests.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 6/24/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import XCTest
@testable import XCServerAPI

class RepositoryBlueprintTests: XCTestCase {
    
    let revisionBlueprint = """
        {
            "DVTSourceControlWorkspaceBlueprintAdditionalValidationRemoteRepositoriesKey":[],
            "DVTSourceControlWorkspaceBlueprintLocationsKey":{
                "3B5CFDF38F1AD11BC1804F5A657156F5835DCED9":{
                    "DVTSourceControlBranchIdentifierKey":"master",
                    "DVTSourceControlLocationRevisionKey":"cdfd4c217d5b85530c2b81849d327e400af84015",
                    "DVTSourceControlBranchOptionsKey":4,
                    "DVTSourceControlBranchRemoteNameKey":"origin",
                    "DVTSourceControlWorkspaceBlueprintLocationTypeKey":"DVTSourceControlBranch"
                }
            },
            "DVTSourceControlWorkspaceBlueprintPrimaryRemoteRepositoryKey":"3B5CFDF38F1AD11BC1804F5A657156F5835DCED9",
            "DVTSourceControlWorkspaceBlueprintIdentifierKey":"8C2D69B0-B9A6-48BF-BB17-B7ABB0D34F2D",
            "DVTSourceControlWorkspaceBlueprintWorkingCopyPathsKey":{
                "3B5CFDF38F1AD11BC1804F5A657156F5835DCED9":"CrazyMonkey/"
            },
            "DVTSourceControlWorkspaceBlueprintNameKey":"Crazy Monkey Twin Cities",
            "DVTSourceControlWorkspaceBlueprintVersion":205,
            "DVTSourceControlWorkspaceBlueprintRelativePathToProjectKey":"Crazy Monkey Twin Cities.xcworkspace",
            "DVTSourceControlWorkspaceBlueprintRemoteRepositoriesKey":[
                {
                    "DVTSourceControlWorkspaceBlueprintRemoteRepositoryURLKey":"bitbucket.org:richardpiazza/com.crazymonkeytwincities.ios.git",
                    "DVTSourceControlWorkspaceBlueprintRemoteRepositorySystemKey":"com.apple.dt.Xcode.sourcecontrol.Git",
                    "DVTSourceControlWorkspaceBlueprintRemoteRepositoryIdentifierKey":"3B5CFDF38F1AD11BC1804F5A657156F5835DCED9"
                }
            ]
        }
    """
    let sourceControlBlueprint = """
        {
            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryAuthenticationStrategiesKey": {
                "FBDCD372C080F115B518613EB0C4141F30E28CCE": {
                    "DVTSourceControlWorkspaceBlueprintRemoteRepositoryAuthenticationTypeKey": "DVTSourceControlAuthenticationStrategy"
                }
            },
            "DVTSourceControlWorkspaceBlueprintRemoteRepositoriesKey": [
                {
                    "DVTSourceControlWorkspaceBlueprintRemoteRepositoryEnforceTrustCertFingerprintKey": true,
                    "DVTSourceControlWorkspaceBlueprintRemoteRepositoryURLKey": "https://github.com/richardpiazza/XCServerAPI",
                    "DVTSourceControlWorkspaceBlueprintRemoteRepositorySystemKey": "com.apple.dt.Xcode.sourcecontrol.Git",
                    "DVTSourceControlWorkspaceBlueprintRemoteRepositoryIdentifierKey": "FBDCD372C080F115B518613EB0C4141F30E28CCE"
                }
            ],
            "DVTSourceControlWorkspaceBlueprintLocationsKey": {
                "FBDCD372C080F115B518613EB0C4141F30E28CCE": {
                    "DVTSourceControlBranchIdentifierKey": "master",
                    "DVTSourceControlBranchOptionsKey": 4,
                    "DVTSourceControlWorkspaceBlueprintLocationTypeKey": "DVTSourceControlBranch"
                }
            },
            "DVTSourceControlWorkspaceBlueprintWorkingCopyRepositoryLocationsKey": {},
            "DVTSourceControlWorkspaceBlueprintVersion": 205,
            "DVTSourceControlWorkspaceBlueprintRelativePathToProjectKey": "XCServerAPI.xcworkspace",
            "DVTSourceControlWorkspaceBlueprintIdentifierKey": "1038633C-B1FD-4443-8741-8FCCB07FA7FE",
            "DVTSourceControlWorkspaceBlueprintAdditionalValidationRemoteRepositoriesKey": [],
            "DVTSourceControlWorkspaceBlueprintWorkingCopyStatesKey": {
                "FBDCD372C080F115B518613EB0C4141F30E28CCE": 0
            },
            "DVTSourceControlWorkspaceBlueprintNameKey": "XCServerAPI",
            "DVTSourceControlWorkspaceBlueprintWorkingCopyPathsKey": {
                "FBDCD372C080F115B518613EB0C4141F30E28CCE": "XCServerAPI/"
            },
            "DVTSourceControlWorkspaceBlueprintPrimaryRemoteRepositoryKey": "FBDCD372C080F115B518613EB0C4141F30E28CCE"
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
    
    func testRevisionBlueprint() {
        guard let data = revisionBlueprint.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        var blueprint: RepositoryBlueprint
        do {
            blueprint = try decoder.decode(RepositoryBlueprint.self, from: data)
        } catch {
            print(error)
            XCTFail()
            return
        }
        
        let primaryRepository = "3B5CFDF38F1AD11BC1804F5A657156F5835DCED9"
        
        XCTAssertEqual(blueprint.identifier, "8C2D69B0-B9A6-48BF-BB17-B7ABB0D34F2D")
        XCTAssertEqual(blueprint.name, "Crazy Monkey Twin Cities")
        XCTAssertEqual(blueprint.version, 205)
        XCTAssertEqual(blueprint.primaryRemoteRepository, primaryRepository)
        XCTAssertEqual(blueprint.relativePathToProject, "Crazy Monkey Twin Cities.xcworkspace")
        XCTAssertNotNil(blueprint.additionalValidationRemoteRepositories)
        XCTAssertEqual(blueprint.additionalValidationRemoteRepositories?.count, 0)
        XCTAssertNil(blueprint.workingCopyRepositoryLocations)
        XCTAssertNil(blueprint.remoteRepositoryAuthenticationStrategies)
        XCTAssertNil(blueprint.workingCopyStates)
        
        guard let remoteRepository = blueprint.remoteRepositories?.first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(remoteRepository.identifier, primaryRepository)
        XCTAssertEqual(remoteRepository.system, "com.apple.dt.Xcode.sourcecontrol.Git")
        XCTAssertEqual(remoteRepository.url, "bitbucket.org:richardpiazza/com.crazymonkeytwincities.ios.git")
        XCTAssertNil(remoteRepository.enforceTrustCertFingerprint)
        XCTAssertNil(remoteRepository.trustedCertFingerprint)
        
        guard let location = blueprint.locations?[primaryRepository] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(location.branchIdentifier, "master")
        XCTAssertEqual(location.remoteName, "origin")
        XCTAssertEqual(location.branchOptions, 4)
        XCTAssertEqual(location.locationType, "DVTSourceControlBranch")
        XCTAssertEqual(location.locationRevision, "cdfd4c217d5b85530c2b81849d327e400af84015")
        
        guard let workingCopyPath = blueprint.workingCopyPaths?[primaryRepository] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(workingCopyPath, "CrazyMonkey/")
    }
    
    func testSourceControlBlueprint() {
        guard let data = sourceControlBlueprint.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        var blueprint: RepositoryBlueprint
        do {
            blueprint = try decoder.decode(RepositoryBlueprint.self, from: data)
        } catch {
            print(error)
            XCTFail()
            return
        }
        
        let primaryRepository = "FBDCD372C080F115B518613EB0C4141F30E28CCE"
        
        XCTAssertEqual(blueprint.identifier, "1038633C-B1FD-4443-8741-8FCCB07FA7FE")
        XCTAssertEqual(blueprint.name, "XCServerAPI")
        XCTAssertEqual(blueprint.version, 205)
        XCTAssertEqual(blueprint.primaryRemoteRepository, primaryRepository)
        XCTAssertEqual(blueprint.relativePathToProject, "XCServerAPI.xcworkspace")
        XCTAssertNotNil(blueprint.additionalValidationRemoteRepositories)
        XCTAssertEqual(blueprint.additionalValidationRemoteRepositories?.count, 0)
        XCTAssertNotNil(blueprint.workingCopyRepositoryLocations)
        
        guard let remoteRepository = blueprint.remoteRepositories?.first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(remoteRepository.identifier, primaryRepository)
        XCTAssertEqual(remoteRepository.system, "com.apple.dt.Xcode.sourcecontrol.Git")
        XCTAssertEqual(remoteRepository.url, "https://github.com/richardpiazza/XCServerAPI")
        XCTAssertEqual(remoteRepository.enforceTrustCertFingerprint, true)
        XCTAssertNil(remoteRepository.trustedCertFingerprint)
        
        guard let location = blueprint.locations?[primaryRepository] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(location.branchIdentifier, "master")
        XCTAssertNil(location.remoteName)
        XCTAssertEqual(location.branchOptions, 4)
        XCTAssertEqual(location.locationType, "DVTSourceControlBranch")
        XCTAssertNil(location.locationRevision)
        
        guard let authenticationStrategies = blueprint.remoteRepositoryAuthenticationStrategies?[primaryRepository] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(authenticationStrategies.authenticationType, "DVTSourceControlAuthenticationStrategy")
        
        guard let workingCopyState = blueprint.workingCopyStates?[primaryRepository] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(workingCopyState, 0)
        
        guard let workingCopyPath = blueprint.workingCopyPaths?[primaryRepository] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(workingCopyPath, "XCServerAPI/")
    }
}
