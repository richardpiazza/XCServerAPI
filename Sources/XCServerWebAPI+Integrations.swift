import Foundation
import CodeQuickKit

@available(*, deprecated)
public extension XCServerWebAPI {
    private struct Integrations: Codable {
        public var count: Int
        public var results: [XCSIntegration]
    }
    
    public typealias IntegrationCompletion = (_ integration: XCSIntegration?, _ error: Error?) -> Void
    public typealias IntegrationsCompletion = (_ integrations: [XCSIntegration]?, _ error: Error?) -> Void
    
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
            
            guard let integration = XCSIntegration.decode(data: responseData) else {
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
            
            guard let integration = XCSIntegration.decode(data: responseData) else {
                completion(nil, Errors.decodeResponse)
                return
            }
            
            completion(integration, nil)
        }
    }
}
