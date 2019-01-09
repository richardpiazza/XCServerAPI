import Foundation
import CodeQuickKit
import BZipCompression

public protocol XCServerHTTPClientAuthorizationDelegate: class {
    func authorization(for fqdn: String?) -> HTTP.Authorization?
    func clearCredentials(for fqdn: String?)
}

public protocol XCServerHTTPClient: HTTPClient, HTTPCodable {
    static var authorizationDelegate: XCServerHTTPClientAuthorizationDelegate? { get set }
}

public enum XCServerHTTPClientError: Swift.Error, LocalizedError {
    case fqdn
    case authorization
    case xcodeServer
    case serilization
    
    public var errorDescription: String? {
        switch self {
        case .fqdn: return "Attempted to initialize with an invalid FQDN."
        case .authorization: return "The server returned a 401 response code."
        case .xcodeServer: return "This class was initialized without an XcodeServer entity."
        case .serilization: return "The response object could not be cast into the requested type."
        }
    }
}

public struct XCServerHTTPClientHeader {
    public static let xscAPIVersion = "x-xscapiversion"
}

public extension XCServerHTTPClient {
    public func request(method: HTTP.RequestMethod, path: String, queryItems: [URLQueryItem]?, data: Data?) throws -> URLRequest {
        let pathURL = baseURL.appendingPathComponent(path)
        
        var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            throw HTTP.Error.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let data = data {
            request.httpBody = data
            request.setValue("\(data.count)", forHTTPHeader: HTTP.Header.contentLength)
        }
        request.setValue(HTTP.Header.dateFormatter.string(from: Date()), forHTTPHeader: HTTP.Header.date)
        request.setValue(HTTP.MIMEType.applicationJson.rawValue, forHTTPHeader: HTTP.Header.accept)
        request.setValue(HTTP.MIMEType.applicationJson.rawValue, forHTTPHeader: HTTP.Header.contentType)
        
        if let authorizationDelegate = type(of: self).authorizationDelegate {
            if let authorization = authorizationDelegate.authorization(for: url.host) {
                request.setValue(authorization.headerValue, forHTTPHeader: HTTP.Header.authorization)
            }
        }
        
        return request
    }
}

// MARK: - Connection/Versioning
public extension XCServerHTTPClient {
    /// Requests the '`/ping`' endpoint from the Xcode Server API.
    public func ping(_ completion: @escaping HTTP.DataTaskCompletion) {
        self.get("ping", completion: completion)
    }
    
    public typealias VersionCompletion = (_ version: XCSVersion?, _ apiVersion: Int?, _ error: Error?) -> Void
    
    /// Requests the '`/versions`' endpoint from the Xcode Server API.
    public func versions(_ completion: @escaping VersionCompletion) {
        self.get("versions") { (statusCode, headers, data, error) in
            var apiVersion: Int?
            
            guard statusCode != 401 else {
                completion(nil, apiVersion, XCServerHTTPClientError.authorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, apiVersion, error)
                return
            }
            
            if let responseHeaders = headers {
                if let version = responseHeaders[XCServerHTTPClientHeader.xscAPIVersion] as? String {
                    apiVersion = Int(version)
                }
            }
            
            guard let responseData = data else {
                completion(nil, apiVersion, XCServerHTTPClientError.serilization)
                return
            }
            
            guard let versions = XCSVersion.decode(data: responseData) else {
                completion(nil, apiVersion, XCServerHTTPClientError.serilization)
                return
            }
            
            completion(versions, apiVersion, nil)
        }
    }
}

// MARK: - Bots
private struct Bots: Codable {
    public var count: Int
    public var results: [XCSBot]
}

public extension XCServerHTTPClient {
    
    public typealias BotsCompletion = (_ bots: [XCSBot]?, _ error: Error?) -> Void
    
    /// Requests the '`/bots`' endpoint from the Xcode Server API.
    public func bots(_ completion: @escaping BotsCompletion) {
        self.get("bots") { (statusCode, headers, data, error) in
            guard statusCode != 401 else {
                completion(nil, XCServerHTTPClientError.authorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                completion(nil, XCServerHTTPClientError.serilization)
                return
            }
            
            guard let bots = Bots.decode(data: responseData) else {
                completion(nil, XCServerHTTPClientError.serilization)
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
                completion(nil, XCServerHTTPClientError.authorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                completion(nil, XCServerHTTPClientError.serilization)
                return
            }
            
            guard let bot = XCSBot.decode(data: responseData) else {
                completion(nil, XCServerHTTPClientError.serilization)
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
                completion(nil, XCServerHTTPClientError.authorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                completion(nil, XCServerHTTPClientError.serilization)
                return
            }
            
            guard let stats = XCSStats.decode(data: responseData) else {
                completion(nil, XCServerHTTPClientError.serilization)
                return
            }
            
            completion(stats, nil)
        }
    }
}

// MARK: - Integrations
private struct Integrations: Codable {
    public var count: Int
    public var results: [XCSIntegration]
}

public extension XCServerHTTPClient {
    
    public typealias IntegrationCompletion = (_ integration: XCSIntegration?, _ error: Error?) -> Void
    public typealias IntegrationsCompletion = (_ integrations: [XCSIntegration]?, _ error: Error?) -> Void
    
    /// Requests the '`/bots/{id}/integrations`' endpoint from the Xcode Server API.
    public func integrations(forBotWithIdentifier identifier: String, completion: @escaping IntegrationsCompletion) {
        self.get("bots/\(identifier)/integrations") { (statusCode, headers, data, error) in
            guard statusCode != 401 else {
                completion(nil, XCServerHTTPClientError.authorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                completion(nil, XCServerHTTPClientError.serilization)
                return
            }
            
            guard let integrations = Integrations.decode(data: responseData) else {
                completion(nil, XCServerHTTPClientError.serilization)
                return
            }
            
            completion(integrations.results, nil)
        }
    }
    
    /// Posts a request to the '`/bots/{id}`' endpoint from the Xcode Server API.
    public func runIntegration(forBotWithIdentifier identifier: String, completion: @escaping IntegrationCompletion) {
        self.post(nil, path: "bots/\(identifier)/integrations") { (statusCode, headers, data, error) in
            guard statusCode != 401 else {
                completion(nil, XCServerHTTPClientError.authorization)
                return
            }
            
            guard statusCode == 201 else {
                completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                completion(nil, XCServerHTTPClientError.serilization)
                return
            }
            
            guard let integration = XCSIntegration.decode(data: responseData) else {
                completion(nil, XCServerHTTPClientError.serilization)
                return
            }
            
            completion(integration, nil)
        }
    }
    
    /// Requests the '`/integrations/{id}`' endpoint from the Xcode Server API.
    public func integration(withIdentifier identifier: String, completion: @escaping IntegrationCompletion) {
        self.get("integrations/\(identifier)") { (statusCode, headers, data, error) in
            guard statusCode != 401 else {
                completion(nil, XCServerHTTPClientError.authorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                completion(nil, XCServerHTTPClientError.serilization)
                return
            }
            
            guard let integration = XCSIntegration.decode(data: responseData) else {
                completion(nil, XCServerHTTPClientError.serilization)
                return
            }
            
            completion(integration, nil)
        }
    }
}

// MARK: - Commits
private struct IntegrationCommits: Codable {
    public var count: Int
    public var results: [XCSCommit]
}

public extension XCServerHTTPClient {
    
    public typealias IntegrationCommitsCompletion = (_ commits: [XCSCommit]?, _ error: Error?) -> Void
    
    /// Requests the '`/integrations/{id}/commits`' endpoint from the Xcode Server API.
    public func commits(forIntegrationWithIdentifier identifier: String, completion: @escaping IntegrationCommitsCompletion) {
        self.get("integrations/\(identifier)/commits") { (statusCode, headers, data, error) in
            guard statusCode != 401 else {
                completion(nil, XCServerHTTPClientError.authorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                completion(nil, XCServerHTTPClientError.serilization)
                return
            }
            
            guard let integrationCommits = IntegrationCommits.decode(data: responseData) else {
                completion(nil, XCServerHTTPClientError.serilization)
                return
            }
            
            completion(integrationCommits.results, nil)
        }
    }
}

// MARK: - Issues
public struct Issues: Codable {
    public var buildServiceErrors: [XCSIssue]?
    public var buildServiceWarnings: [XCSIssue]?
    public var triggerErrors: [XCSIssue]?
    public var errors: XCSIssueGroup?
    public var warnings: XCSIssueGroup?
    public var testFailures: XCSIssueGroup?
    public var analyzerWarnings: XCSIssueGroup?
}

public extension XCServerHTTPClient {
    
    public typealias IssuesCompletion = (_ issues: Issues?, _ error: Error?) -> Void
    
    /// Requests the '`/integrations/{id}/issues`' endpoint from the Xcode Server API.
    public func issues(forIntegrationWithIdentifier identifier: String, completion: @escaping IssuesCompletion) {
        self.get("integrations/\(identifier)/issues") { (statusCode, headers, data, error) in
            guard statusCode != 401 else {
                completion(nil, XCServerHTTPClientError.authorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                completion(nil, XCServerHTTPClientError.serilization)
                return
            }
            
            guard let issues = Issues.decode(data: responseData) else {
                completion(nil, XCServerHTTPClientError.serilization)
                return
            }
            
            completion(issues, nil)
        }
    }
}

// MARK: - Coverage
public extension XCServerHTTPClient {
    
    public typealias CodeCoverageCompletion = (_ coverage: XCSCoverageHierarchy?, _ error: Error?) -> Void
    
    public func coverage(forIntegrationWithIdentifier identifier: String, completion: @escaping CodeCoverageCompletion) {
        self.get("integrations/\(identifier)/coverage") { (statusCode, headers, data, error) in
            guard statusCode != 401 else {
                completion(nil, XCServerHTTPClientError.authorization)
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
                completion(nil, XCServerHTTPClientError.serilization)
                return
            }
            
            var decompressedData: Data
            do {
                decompressedData = try self.decompress(data: responseData)
            } catch let decompressionError {
                completion(nil, decompressionError)
                return
            }
            
            guard let coverageHierachy = XCSCoverageHierarchy.decode(data: decompressedData) else {
                completion(nil, XCServerHTTPClientError.serilization)
                return
            }
            
            completion(coverageHierachy, nil)
        }
    }
    
    internal func decompress(data: Data) throws -> Data {
        let decompressedData = try BZipCompression.decompressedData(with: data)
        
        guard let decompressedString = String(data: decompressedData, encoding: .utf8) else {
            throw XCServerHTTPClientError.serilization
        }
        
        guard let firstBrace = decompressedString.range(of: "{") else {
            throw XCServerHTTPClientError.serilization
        }
        
        guard let lastBrace = decompressedString.range(of: "}", options: .backwards, range: nil, locale: nil) else {
            throw XCServerHTTPClientError.serilization
        }
        
        let range = decompressedString.index(firstBrace.lowerBound, offsetBy: 0)..<decompressedString.index(lastBrace.lowerBound, offsetBy: 1)
        let json = decompressedString[range]
        
        guard let validData = json.data(using: .utf8) else {
            throw XCServerHTTPClientError.serilization
        }
        
        return validData
    }
}
