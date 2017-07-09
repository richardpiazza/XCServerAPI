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
    
    /// Requests the '`/bots`' endpoint from the Xcode Server API.
    public func bots(_ completion: @escaping BotsCompletion) {
        self.get("bots") { (statusCode, headers, data, error) in
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
            
            guard let bots = Bots.decode(data: responseData) else {
                completion(nil, Errors.decodeResponse)
                return
            }
            
            completion(bots.results, nil)
        }
    }
    
    public typealias BotCompletion = (_ bot: BotDocument?, _ error: Error?) -> Void
    
    /// Requests the '`/bots/{id}`' endpoint from the Xcode Server API.
    public func bot(withIdentifier identifier: String, completion: @escaping BotCompletion) {
        self.get("bots/\(identifier)") { (statusCode, headers, data, error) in
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
            
            guard let bot = BotDocument.decode(data: responseData) else {
                completion(nil, Errors.decodeResponse)
                return
            }
            
            completion(bot, nil)
        }
    }
    
    public typealias StatsCompletion = (_ stats: Stats?, _ error: Error?) -> Void
    
    /// Requests the '`/bots/{id}/stats`' endpoint from the Xcode Server API.
    public func stats(forBotWithIdentifier identifier: String, completion: @escaping StatsCompletion) {
        self.get("bots/\(identifier)/stats") { (statusCode, headers, data, error) in
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
            
            guard let stats = Stats.decode(data: responseData) else {
                completion(nil, Errors.decodeResponse)
                return
            }
            
            completion(stats, nil)
        }
    }
}
