//===----------------------------------------------------------------------===//
//
// XCServerWebAPI+Coverage.swift
//
// Copyright (c) 2017 Richard Piazza
// https://github.com/richardpiazza/XCServerAPI
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//===----------------------------------------------------------------------===//

import Foundation
import CodeQuickKit
import BZipCompression

public extension XCServerWebAPI {
    
    public typealias CodeCoverageCompletion = (_ coverage: CoverageHierarchy?, _ error: Error?) -> Void
    
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
            
            guard let coverageHierachy = CoverageHierarchy.decode(data: decompressedData) else {
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
