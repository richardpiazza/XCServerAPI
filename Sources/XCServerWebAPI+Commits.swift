import Foundation
import CodeQuickKit

@available(*, deprecated)
public extension XCServerWebAPI {
    private struct IntegrationCommits: Codable {
        public var count: Int
        public var results: [XCSCommit]
    }
    
    public typealias IntegrationCommitsCompletion = (_ commits: [XCSCommit]?, _ error: Error?) -> Void
    
    /// Requests the '`/integrations/{id}/commits`' endpoint from the Xcode Server API.
    public func commits(forIntegrationWithIdentifier identifier: String, completion: @escaping IntegrationCommitsCompletion) {
        self.get("integrations/\(identifier)/commits") { (statusCode, headers, data, error) in
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
            
            guard let integrationCommits = IntegrationCommits.decode(data: responseData) else {
                completion(nil, Errors.decodeResponse)
                return
            }
            
            completion(integrationCommits.results, nil)
        }
    }
}
