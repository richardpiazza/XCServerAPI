//===----------------------------------------------------------------------===//
//
// XCServerWebAPI+Integrations.swift
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
    private struct Integrations: Codable {
        public var count: Int
        public var results: [IntegrationDocument]
    }
    
    public typealias IntegrationCompletion = (_ integration: IntegrationDocument?, _ error: Error?) -> Void
    public typealias IntegrationsCompletion = (_ integrations: [IntegrationDocument]?, _ error: Error?) -> Void
    
    /// Requests the '`/bots/{id}/integrations`' endpoint from the Xcode Server API.
    public func integrations(forBotWithIdentifier identifier: String, completion: @escaping IntegrationsCompletion) {
        self.get("bots/\(identifier)/integrations") { (statusCode, headers, data, error) in
            guard statusCode != 401 else {
                completion(nil, Errors.authorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                completion(nil, Errors.decodeResponse)
                return
            }
            
            guard let integrations = Integrations.decode(data: responseData) else {
                completion(nil, Errors.decodeResponse)
                return
            }
            
            completion(integrations.results, nil)
        }
    }
    
    /// Posts a request to the '`/bots/{id}`' endpoint from the Xcode Server API.
    public func runIntegration(forBotWithIdentifier identifier: String, completion: @escaping IntegrationCompletion) {
        self.post(nil, path: "bots/\(identifier)/integrations") { (statusCode, headers, data, error) in
            guard statusCode != 401 else {
                completion(nil, Errors.authorization)
                return
            }
            
            guard statusCode == 201 else {
                completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                completion(nil, Errors.decodeResponse)
                return
            }
            
            guard let integration = IntegrationDocument.decode(data: responseData) else {
                completion(nil, Errors.decodeResponse)
                return
            }
            
            completion(integration, nil)
        }
    }
    
    /// Requests the '`/integrations/{id}`' endpoint from the Xcode Server API.
    public func integration(withIdentifier identifier: String, completion: @escaping IntegrationCompletion) {
        self.get("integrations/\(identifier)") { (statusCode, headers, data, error) in
            guard statusCode != 401 else {
                completion(nil, Errors.authorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                completion(nil, Errors.decodeResponse)
                return
            }
            
            guard let integration = IntegrationDocument.decode(data: responseData) else {
                completion(nil, Errors.decodeResponse)
                return
            }
            
            completion(integration, nil)
        }
    }
}
