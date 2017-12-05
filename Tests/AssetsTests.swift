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
    
    func testAssets() {
        guard let assets = XCSAssets.decode(json: json) else {
            XCTFail()
            return
        }
        
        guard let xcodeBuildOutput = assets.xcodebuildOutput else {
            XCTFail()
            return
        }
        XCTAssertEqual(xcodeBuildOutput.size, 3183346)
        XCTAssertEqual(xcodeBuildOutput.fileName, "xcodebuild_result.bundle.zip")
        XCTAssertEqual(xcodeBuildOutput.allowAnonymousAccess, false)
        XCTAssertEqual(xcodeBuildOutput.relativePath, "a7341f3521c7245492693c0d780006f9-XCServerAPI Bot/8/xcodebuild_result.bundle.zip")
        
        guard let buildServiceLog = assets.buildServiceLog else {
            XCTFail()
            return
        }
        XCTAssertEqual(buildServiceLog.size, 13890)
        XCTAssertEqual(buildServiceLog.fileName, "buildService.log")
        XCTAssertEqual(buildServiceLog.allowAnonymousAccess, false)
        XCTAssertEqual(buildServiceLog.relativePath, "a7341f3521c7245492693c0d780006f9-XCServerAPI Bot/8/buildService.log")
        
        guard let xcodebuildLog = assets.xcodebuildLog else {
            XCTFail()
            return
        }
        XCTAssertEqual(xcodebuildLog.size, 1074831)
        XCTAssertEqual(xcodebuildLog.fileName, "xcodebuild.log")
        XCTAssertEqual(xcodebuildLog.allowAnonymousAccess, false)
        XCTAssertEqual(xcodebuildLog.relativePath, "a7341f3521c7245492693c0d780006f9-XCServerAPI Bot/8/xcodebuild.log")
        
        guard let sourceControlLog = assets.sourceControlLog else {
            XCTFail()
            return
        }
        XCTAssertEqual(sourceControlLog.size, 2223)
        XCTAssertEqual(sourceControlLog.fileName, "sourceControl.log")
        XCTAssertEqual(sourceControlLog.allowAnonymousAccess, false)
        XCTAssertEqual(sourceControlLog.relativePath, "a7341f3521c7245492693c0d780006f9-XCServerAPI Bot/8/sourceControl.log")
        
        guard let triggerAssets = assets.triggerAssets, triggerAssets.count == 2 else {
            XCTFail()
            return
        }
        
        let postIntegration = triggerAssets[0]
        XCTAssertEqual(postIntegration.size, 32)
        XCTAssertEqual(postIntegration.fileName, "trigger-after-0.log")
        XCTAssertEqual(postIntegration.allowAnonymousAccess, false)
        XCTAssertEqual(postIntegration.triggerName, "postintegration")
        XCTAssertEqual(postIntegration.relativePath, "a7341f3521c7245492693c0d780006f9-XCServerAPI Bot/8/trigger-after-0.log")
        
        let preIntegration = triggerAssets[1]
        XCTAssertEqual(preIntegration.size, 31)
        XCTAssertEqual(preIntegration.fileName, "trigger-before-0.log")
        XCTAssertEqual(preIntegration.allowAnonymousAccess, false)
        XCTAssertEqual(preIntegration.triggerName, "preintegration")
        XCTAssertEqual(preIntegration.relativePath, "a7341f3521c7245492693c0d780006f9-XCServerAPI Bot/8/trigger-before-0.log")
    }
}
