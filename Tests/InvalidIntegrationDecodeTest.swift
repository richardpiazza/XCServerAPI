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

class InvalidIntegrationDecodeTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    public func url(forResource resource: String) -> URL {
        let bundle = Bundle(for: type(of: self))
        if let url = bundle.url(forResource: resource, withExtension: "json") {
            return url
        }
        
        let path = FileManager.default.currentDirectoryPath
        let url = URL(fileURLWithPath: path).appendingPathComponent("Tests").appendingPathComponent(resource).appendingPathExtension("json")
        
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("Failed to locate resource \(resource).json")
        }
        
        return url
    }
    
    func testInvalidIntegration() {
        let url = self.url(forResource: "InvalidIntegration")
        guard let data = FileManager.default.contents(atPath: url.path) else {
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
        
        do {
            let integration = try XCServerJSONDecoder.default.decode(XCSIntegration.self, from: data)
            print(integration._id)
        } catch {
            print(error)
            XCTFail()
        }
    }
}
