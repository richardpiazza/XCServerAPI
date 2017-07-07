//===----------------------------------------------------------------------===//
//
// XCServerWebAPI+Commits.swift
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

public extension XCServerWebAPI {
    private struct IntegrationCommits: Codable {
        public var count: Int
        public var results: [CommitDocument]
    }
    
    public typealias IntegrationCommitsCompletion = (_ commits: [CommitDocument]?, _ error: Error?) -> Void
    
    public typealias XCServerWebAPICommitsCompletion = (_ commits: [IntegrationCommitJSON]?, _ error: NSError?) -> Void
    
    /// Requests the '`/integrations/{id}/commits`' endpoint from the Xcode Server API.
    public func getCommits(forIntegration identifier: String, completion: @escaping XCServerWebAPICommitsCompletion) {
        self.get("integrations/\(identifier)/commits") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(nil, self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(nil, self.invalidResponseCast)
                return
            }
            
            let typedResponse = IntegrationCommitsResponse(withDictionary: dictionary)
            
            completion(typedResponse.results, nil)
        }
    }
}
