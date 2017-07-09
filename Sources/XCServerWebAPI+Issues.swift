//===----------------------------------------------------------------------===//
//
// XCServerWebAPI+Issues.swift
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
    public struct Issues: Codable {
        public var buildServiceErrors: [Issue]?
        public var buildServiceWarnings: [Issue]?
        public var triggerErrors: [Issue]?
        public var errors: IssueGroup?
        public var warnings: IssueGroup?
        public var testFailures: IssueGroup?
        public var analyzerWarnings: IssueGroup?
    }
    
    public typealias IssuesCompletion = (_ issues: Issues?, _ error: Error?) -> Void
    
    public typealias XCServerWebAPIIssuesCompletion = (_ issues: IntegrationIssuesResponse?, _ error: NSError?) -> Void
    
    /// Requests the '`/integrations/{id}/issues`' endpoint from the Xcode Server API.
    public func getIssues(forIntegration identifier: String, completion: @escaping XCServerWebAPIIssuesCompletion) {
        self.get("integrations/\(identifier)/issues") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(nil, Errors.authorization.nsError)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(nil, Errors.decodeResponse.nsError)
                return
            }
            
            let typedResponse = IntegrationIssuesResponse(withDictionary: dictionary)
            
            completion(typedResponse, nil)
        }
    }
}
