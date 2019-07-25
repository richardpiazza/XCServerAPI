import XCTest
@testable import XCServerAPI

extension Data {
    var controlCharacterSanitized: Data {
        guard let stringRepresentation = String(data: self, encoding: .utf8) else {
            return self
        }
        
        var mutableRepresentation = stringRepresentation
        while let range = mutableRepresentation.rangeOfCharacter(from: CharacterSet.controlCharacters) {
            let char = mutableRepresentation[range]
            switch char {
            case "\n":
//                mutableRepresentation.replaceSubrange(range, with: "\\n")
                mutableRepresentation.replaceSubrange(range, with: "")
            default:
                print("Unhandled control character: '\(char)'")
                break
            }
        }
        
        guard let returnData = mutableRepresentation.data(using: .utf8) else {
            return self
        }
        
        return returnData
    }
}

struct XCSMinimalIntegration: Codable {
    enum CodingKeys: String, CodingKey {
        case _id
        case _rev
        case number
        case currentStep
        case result
        case queuedDate
        case successStreak = "success_streak"
        case shouldClean
        case assets
        case docType = "doc_type"
        case tinyID
        case buildServiceFingerprint
        case tags
        case startedTime
        case buildResultSummary
        case endedTime
        case endedTimeDate
        case duration
        case ccPercentage
        case ccPercentageDelta
        case perfMetricNames
        case perfMetricKeyPaths
//        case bot
//        case revisionBlueprint
//        case testedDevices
        case testHierarchy
//        case controlledChanges
    }
    
    public var _id: String
    public var _rev: String
    public var number: Int
    public var currentStep: XCSIntegrationStep
    public var result: XCSIntegrationResult
    public var queuedDate: Date?
    public var successStreak: Int?
    public var shouldClean: Bool?
    public var assets: XCSAssets?
    public var docType: String = "integration"
    public var tinyID: String?
    public var buildServiceFingerprint: String?
    public var tags: [String]?
    public var startedTime: Date?
    public var buildResultSummary: XCSBuildResultSummary?
    public var endedTime: Date?
    public var endedTimeDate: [Int]?
    public var duration: Double?
    public var ccPercentage: Int?
    public var ccPercentageDelta: Int?
    public var perfMetricNames: [String]?
    public var perfMetricKeyPaths: [String]?
//    public var bot: XCSBot?
//    public var revisionBlueprint: XCSRepositoryBlueprint?
//    public var testedDevices: [XCSDevice]?
    public var testHierarchy: XCSTestHierarchy?
//    public var controlledChanges: XCSControlledChanges?
}

class InvalidIntegrationDecodeTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInvalidIntegration() {
        guard let data = invalidIntegrationJSON.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
            if let _ = dictionary as? [String : Any] {
                print("JSONSerialization passed")
            }
        } catch {
            print(error)
            print(String(data: data, encoding: .utf8)!)
        }
        
        let integration = XCSMinimalIntegration.decode(data: data)
        XCTAssertEqual(integration?._id, "7165830f996e973601a81f0b28a4b4f3")
    }
}
