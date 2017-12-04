import Foundation
import CodeQuickKit

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
            return try XCServerJSONDecoder.default.decode(Self.self, from: data)
        } catch {
            Log.error(error, message: "Failed to decode type '\(String(describing: Self.self)): \(error.localizedDescription)'")
            return nil
        }
    }
}
