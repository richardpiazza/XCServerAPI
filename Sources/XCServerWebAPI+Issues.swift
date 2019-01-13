import Foundation
import CodeQuickKit

@available(*, deprecated)
public extension XCServerWebAPI {
    public struct Issues: Codable {
        public var buildServiceErrors: [XCSIssue]?
        public var buildServiceWarnings: [XCSIssue]?
        public var triggerErrors: [XCSIssue]?
        public var errors: XCSIssueGroup?
        public var warnings: XCSIssueGroup?
        public var testFailures: XCSIssueGroup?
        public var analyzerWarnings: XCSIssueGroup?
    }
    
    public typealias IssuesCompletion = (_ issues: Issues?, _ error: Error?) -> Void
    
    /// Requests the '`/integrations/{id}/issues`' endpoint from the Xcode Server API.
    public func issues(forIntegrationWithIdentifier identifier: String, completion: @escaping IssuesCompletion) {
        self.get("integrations/\(identifier)/issues") { (statusCode, headers, data, error) in
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
            
            guard let issues = Issues.decode(data: responseData) else {
                completion(nil, Errors.decodeResponse)
                return
            }
            
            completion(issues, nil)
        }
    }
}
