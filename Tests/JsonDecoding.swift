import Foundation
@testable import XCServerAPI

var testSuite_jsonDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    return formatter
}

var testSuite_jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(testSuite_jsonDateFormatter)
    return decoder
}()

public extension Decodable {
    static func decode(json: String) -> Self? {
        var mutable = json
        while let range = mutable.rangeOfCharacter(from: CharacterSet.controlCharacters) {
            mutable.removeSubrange(range)
        }
        
        guard let data = mutable.data(using: .utf8) else {
            return nil
        }
        
        return decode(data: data)
    }
    
    static func decode(data: Data) -> Self? {
        do {
            return try testSuite_jsonDecoder.decode(Self.self, from: data)
        } catch {
            return nil
        }
    }
}
