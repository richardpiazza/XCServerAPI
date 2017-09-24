import Foundation
import CodeQuickKit

public extension XCServerWebAPI {
    private struct Bots: Codable {
        public var count: Int
        public var results: [XCSBot]
    }
    
    public typealias BotsCompletion = (_ bots: [XCSBot]?, _ error: Error?) -> Void
    
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
    
    public typealias BotCompletion = (_ bot: XCSBot?, _ error: Error?) -> Void
    
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
            
            guard let bot = XCSBot.decode(data: responseData) else {
                completion(nil, Errors.decodeResponse)
                return
            }
            
            completion(bot, nil)
        }
    }
    
    public typealias StatsCompletion = (_ stats: XCSStats?, _ error: Error?) -> Void
    
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
            
            guard let stats = XCSStats.decode(data: responseData) else {
                completion(nil, Errors.decodeResponse)
                return
            }
            
            completion(stats, nil)
        }
    }
}
