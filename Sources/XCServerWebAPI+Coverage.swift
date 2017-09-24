import Foundation
import CodeQuickKit
import BZipCompression

public extension XCServerWebAPI {
    
    public typealias CodeCoverageCompletion = (_ coverage: XCSCoverageHierarchy?, _ error: Error?) -> Void
    
    public func coverage(forIntegrationWithIdentifier identifier: String, completion: @escaping CodeCoverageCompletion) {
        self.get("integrations/\(identifier)/coverage") { (statusCode, headers, data, error) in
            guard statusCode != 401 else {
                completion(nil, Errors.authorization)
                return
            }
            
            guard statusCode == 200 else {
                if statusCode == 404 {
                    // 404 is a valid response, no coverage data.
                    completion(nil, nil)
                } else {
                    completion(nil, error)
                }
                return
            }
            
            guard let responseData = data else {
                completion(nil, Errors.decodeResponse)
                return
            }
            
            var decompressedData: Data
            do {
                decompressedData = try self.decompress(data: responseData)
            } catch let decompressionError {
                completion(nil, decompressionError)
                return
            }
            
            guard let coverageHierachy = XCSCoverageHierarchy.decode(data: decompressedData) else {
                completion(nil, Errors.decodeResponse)
                return
            }
            
            completion(coverageHierachy, nil)
        }
    }
    
    internal func decompress(data: Data) throws -> Data {
        let decompressedData = try BZipCompression.decompressedData(with: data)

        guard let decompressedString = String(data: decompressedData, encoding: .utf8) else {
            throw Errors.decodeResponse
        }

        guard let firstBrace = decompressedString.range(of: "{") else {
            throw Errors.decodeResponse
        }

        guard let lastBrace = decompressedString.range(of: "}", options: .backwards, range: nil, locale: nil) else {
            throw Errors.decodeResponse
        }

        let range = decompressedString.index(firstBrace.lowerBound, offsetBy: 0)..<decompressedString.index(lastBrace.lowerBound, offsetBy: 1)
        let json = decompressedString[range]

        guard let validData = json.data(using: .utf8) else {
            throw Errors.decodeResponse
        }

        return validData
    }
}
