//===----------------------------------------------------------------------===//
//
// XCServerWebAPI+Bots.swift
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
    private struct Bots: Codable {
        public var count: Int
        public var results: [BotDocument]
    }
    
    public typealias BotsCompletion = (_ bots: [BotDocument]?, _ error: Error?) -> Void
    
    public typealias XCServerWebAPIBotsCompletion = (_ bots: [BotJSON]?, _ error: NSError?) -> Void
    
    /// Requests the '`/bots`' endpoint from the Xcode Server API.
    public func getBots(_ completion: @escaping XCServerWebAPIBotsCompletion) {
        self.get("bots") { (statusCode, response, responseObject, error) in
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
            
            let typedResponse = BotsResponse(withDictionary: dictionary)
            
            completion(typedResponse.results, nil)
        }
    }
    
    public typealias XCServerWebAPIBotCompletion = (_ bot: BotJSON?, _ error: NSError?) -> Void
    
    /// Requests the '`/bots/{id}`' endpoint from the Xcode Server API.
    public func getBot(bot identifier: String, completion: @escaping XCServerWebAPIBotCompletion) {
        self.get("bots/\(identifier)") { (statusCode, response, responseObject, error) in
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
            
            let typedResponse = BotJSON(withDictionary: dictionary)
            
            completion(typedResponse, nil)
        }
    }
    
    public typealias XCServerWebAPIStatsCompletion = (_ stats: StatsJSON?, _ error: NSError?) -> Void
    
    /// Requests the '`/bots/{id}/stats`' endpoint from the Xcode Server API.
    public func getStats(forBot identifier: String, completion: @escaping XCServerWebAPIStatsCompletion) {
        self.get("bots/\(identifier)/stats") { (statusCode, response, responseObject, error) in
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
            
            let typedResponse = StatsJSON(withDictionary: dictionary)
            
            completion(typedResponse, nil)
        }
    }
    
    public typealias XCServerWebAPIIntegrationCompletion = (_ integration: IntegrationJSON?, _ error: NSError?) -> Void
    
    /// Posts a request to the '`/bots/{id}`' endpoint from the Xcode Server API.
    public func postBot(forBot identifier: String, completion: @escaping XCServerWebAPIIntegrationCompletion) {
        self.post(nil, path: "bots/\(identifier)/integrations") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(nil, self.invalidAuthorization)
                return
            }
            
            guard statusCode == 201 else {
                completion(nil, error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(nil, self.invalidResponseCast)
                return
            }
            
            let typedResponse = IntegrationJSON(withDictionary: dictionary)
            
            completion(typedResponse, nil)
        }
    }
}
