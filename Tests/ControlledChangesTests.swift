import XCTest
@testable import XCServerAPI

class ControlledChangesTests: XCTestCase {

    let json = """
        {
            "xcode": {
                "version": {
                    "after": "9.2",
                    "before": "9.1"
                },
                "buildNumber": {
                    "after": "9C40b",
                    "before": "9B55"
                }
            },
            "platforms": {
                "tvOS": {
                    "version": {
                        "before": "11.1",
                        "after": "11.2"
                    },
                    "buildNumber": {
                        "before": "15J580",
                        "after": "15K104"
                    }
                },
                "iOS": {
                    "version": {
                        "before": "11.1",
                        "after": "11.2"
                    },
                    "buildNumber": {
                        "before": "15B87",
                        "after": "15C107"
                    }
                },
                "macOS": {
                    "version": {
                        "before": "10.13.1",
                        "after": "10.13.2"
                    },
                    "buildNumber": {
                        "before": "17B41",
                        "after": "17C76"
                    }
                },
                "watchOS": {
                    "version": {
                        "before": "4.1",
                        "after": "4.2"
                    },
                    "buildNumber": {
                        "before": "15R844",
                        "after": "15S100"
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

    func testControlledChanges() {
        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        var controlledChanges: XCSControlledChanges
        do {
            controlledChanges = try decoder.decode(XCSControlledChanges.self, from: data)
        } catch {
            print(error)
            XCTFail()
            return
        }
        
        XCTAssertEqual(controlledChanges.xcode?.version?.before, "9.1")
    }
}
