import Foundation
import CodeQuickKit
import BZipCompression

public protocol XCServerClientAuthorizationDelegate: class {
    func authorization(for fqdn: String?) -> HTTP.Authorization?
    func clearCredentials(for fqdn: String?)
}

public enum XCServerClientError: Swift.Error, LocalizedError {
    case fqdn
    case xcodeServer
    case authorization
    case response
    case serilization
    
    public var errorDescription: String? {
        switch self {
        case .fqdn: return "Attempted to initialize with an invalid FQDN."
        case .xcodeServer: return "This class was initialized without an XcodeServer entity."
        case .authorization: return "The server returned a 401 response code."
        case .response: return "The response did not contain valid data."
        case .serilization: return "The response object could not be cast into the requested type."
        }
    }
}

public struct XCServerClientHeader {
    public static let xscAPIVersion = "x-xscapiversion"
}

public class XCServerClient: HTTPClient, HTTPCodable {
    
    public var baseURL: URL
    public var session: URLSession
    public var authorization: HTTP.Authorization?
    public var jsonEncoder: JSONEncoder
    public var jsonDecoder: JSONDecoder
    
    /// Delegate responsible for handling all authentication for
    /// `XCServerClient` instances.
    public static var authorizationDelegate: XCServerClientAuthorizationDelegate?
    
    private static var jsonDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }
    
    private static var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(jsonDateFormatter)
        return encoder
    }()
    
    private static var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(jsonDateFormatter)
        return decoder
    }()
    
    public init(fqdn: String) throws {
        guard let url = URL(string: "https://\(fqdn):20343/api") else {
            throw XCServerClientError.fqdn
        }
        
        baseURL = url
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: SelfSignedSessionDelegate(), delegateQueue: nil)
        jsonEncoder = type(of: self).jsonEncoder
        jsonDecoder = type(of: self).jsonDecoder
    }
    
    fileprivate static var clients: [String : XCServerClient] = [:]
    
    public static func client(forFQDN fqdn: String) throws -> XCServerClient {
        if let client = clients[fqdn] {
            return client
        }
        
        let client = try XCServerClient(fqdn: fqdn)
        client.session.configuration.timeoutIntervalForRequest = 8
        client.session.configuration.timeoutIntervalForResource = 16
        client.session.configuration.httpCookieAcceptPolicy = .never
        client.session.configuration.httpShouldSetCookies = false
        
        clients[fqdn] = client
        
        return client
    }
    
    public static func resetClient(forFQDN fqdn: String) {
        authorizationDelegate?.clearCredentials(for: fqdn)
        clients[fqdn] = nil
    }
    
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

extension XCServerClient {
    private func serverResult<T>(_ statusCode: Int, _ headers: [AnyHashable : Any]?, data: T?, _ error: Swift.Error?) -> XCServerResult<T> {
        guard statusCode != 401 else {
            return .error(XCServerClientError.authorization)
        }
        
        guard statusCode == 200 || statusCode == 201 else {
            return .error(error ?? XCServerClientError.response)
        }
        
        guard let result = data else {
            return .error(error ?? XCServerClientError.serilization)
        }
        
        return .value(result)
    }
    
    private func decompress(data: Data) throws -> Data {
        let decompressedData = try BZipCompression.decompressedData(with: data)
        
        guard let decompressedString = String(data: decompressedData, encoding: .utf8) else {
            throw XCServerClientError.serilization
        }
        
        guard let firstBrace = decompressedString.range(of: "{") else {
            throw XCServerClientError.serilization
        }
        
        guard let lastBrace = decompressedString.range(of: "}", options: .backwards, range: nil, locale: nil) else {
            throw XCServerClientError.serilization
        }
        
        let range = decompressedString.index(firstBrace.lowerBound, offsetBy: 0)..<decompressedString.index(lastBrace.lowerBound, offsetBy: 1)
        let json = decompressedString[range]
        
        guard let validData = json.data(using: .utf8) else {
            throw XCServerClientError.serilization
        }
        
        return validData
    }
}

// MARK: - Connection/Versioning
public extension XCServerClient {
    
    /// Requests the '`/ping`' endpoint from the Xcode Server API.
    public func ping(_ completion: @escaping (XCServerResult<Void>) -> Void) {
        get("ping") { (statusCode, headers, data: Data?, error) in
            guard statusCode == 204 else {
                completion(.error(XCServerClientError.xcodeServer))
                return
            }
            
            completion(.value(()))
        }
    }
    
    public func versions(_ completion: @escaping (XCServerResult<(XCSVersion, Int?)>) -> Void) {
        get("versions") { (statusCode, headers, data: XCSVersion?, error) in
            guard statusCode != 401 else {
                completion(.error(XCServerClientError.authorization))
                return
            }
            
            guard statusCode == 200 else {
                completion(.error(error ?? XCServerClientError.response))
                return
            }
            
            guard let result = data else {
                completion(.error(error ?? XCServerClientError.serilization))
                return
            }
            
            var apiVersion: Int?
            
            if let responseHeaders = headers {
                if let version = responseHeaders[XCServerClientHeader.xscAPIVersion] as? String {
                    apiVersion = Int(version)
                }
            }
            
            completion(.value((result, apiVersion)))
        }
    }
}

// MARK: - Bots
public extension XCServerClient {
    private struct Bots: Codable {
        public var count: Int
        public var results: [XCSBot]
    }
    
    /// Requests the '`/bots`' endpoint from the Xcode Server API.
    public func bots(_ completion: @escaping (XCServerResult<[XCSBot]>) -> Void) {
        get("bots") { (statusCode, headers, data: Bots?, error) in
            completion(self.serverResult(statusCode, headers, data: data?.results, error))
        }
    }
    
    /// Requests the '`/bots/{id}`' endpoint from the Xcode Server API.
    public func bot(withIdentifier identifier: String, completion: @escaping (XCServerResult<XCSBot>) -> Void) {
        get("bots/\(identifier)") { (statusCode, headers, data: XCSBot?, error) in
            completion(self.serverResult(statusCode, headers, data: data, error))
        }
    }
    
    /// Requests the '`/bots/{id}/stats`' endpoint from the Xcode Server API.
    public func stats(forBotWithIdentifier identifier: String, completion: @escaping (XCServerResult<XCSStats>) -> Void) {
        get("bots/\(identifier)/stats") { (statusCode, headers, data: XCSStats?, error) in
            completion(self.serverResult(statusCode, headers, data: data, error))
        }
    }
}

// MARK: - Integrations
public extension XCServerClient {
    private struct Integrations: Codable {
        public var count: Int
        public var results: [XCSIntegration]
    }
    
    /// Requests the '`/bots/{id}/integrations`' endpoint from the Xcode Server API.
    public func integrations(forBotWithIdentifier identifier: String, completion: @escaping (XCServerResult<[XCSIntegration]>) -> Void) {
        get("bots/\(identifier)/integrations") { (statusCode, headers, data: Integrations?, error) in
            completion(self.serverResult(statusCode, headers, data: data?.results, error))
        }
    }
    
    /// Posts a request to the '`/bots/{id}`' endpoint from the Xcode Server API.
    public func runIntegration(forBotWithIdentifier identifier: String, completion: @escaping (XCServerResult<XCSIntegration>) -> Void) {
        post(nil, path: "bots/\(identifier)/integrations") { (statusCode, headers, data: XCSIntegration?, error) in
            completion(self.serverResult(statusCode, headers, data: data, error))
        }
    }
    
    /// Requests the '`/integrations/{id}`' endpoint from the Xcode Server API.
    public func integration(withIdentifier identifier: String, completion: @escaping (XCServerResult<XCSIntegration>) -> Void) {
        get("integrations/\(identifier)") { (statusCode, headers, data: XCSIntegration?, error) in
            completion(self.serverResult(statusCode, headers, data: data, error))
        }
    }
}

// MARK: - Commits
public extension XCServerClient {
    private struct IntegrationCommits: Codable {
        public var count: Int
        public var results: [XCSCommit]
    }
    
    /// Requests the '`/integrations/{id}/commits`' endpoint from the Xcode Server API.
    public func commits(forIntegrationWithIdentifier identifier: String, completion: @escaping (XCServerResult<[XCSCommit]>) -> Void) {
        get("integrations/\(identifier)/commits") { (statusCode, headers, data: IntegrationCommits?, error) in
            completion(self.serverResult(statusCode, headers, data: data?.results, error))
        }
    }
}

// MARK: - Issues
public extension XCServerClient {
    public struct Issues: Codable {
        public var buildServiceErrors: [XCSIssue]?
        public var buildServiceWarnings: [XCSIssue]?
        public var triggerErrors: [XCSIssue]?
        public var errors: XCSIssueGroup?
        public var warnings: XCSIssueGroup?
        public var testFailures: XCSIssueGroup?
        public var analyzerWarnings: XCSIssueGroup?
    }
    
    /// Requests the '`/integrations/{id}/issues`' endpoint from the Xcode Server API.
    public func issues(forIntegrationWithIdentifier identifier: String, completion: @escaping (XCServerResult<Issues>) -> Void) {
        get("integrations/\(identifier)/issues") { (statusCode, headers, data: Issues?, error) in
            completion(self.serverResult(statusCode, headers, data: data, error))
        }
    }
}

// MARK: - Coverage
public extension XCServerClient {
    
    /// Requests the '`/integrations/{id}/coverage`' endpoint from the Xcode Server API.
    public func coverage(forIntegrationWithIdentifier identifier: String, completion: @escaping (XCServerResult<XCSCoverageHierarchy?>) -> Void) {
        get("integrations/\(identifier)/coverage") { (statusCode, headers, data: Data?, error) in
            guard statusCode != 401 else {
                completion(.error(XCServerClientError.authorization))
                return
            }
            
            guard statusCode == 200 else {
                if statusCode == 404 {
                    // 404 is a valid response, no coverage data.
                    completion(.value(nil))
                } else {
                    completion(.error(error ?? XCServerClientError.response))
                }
                return
            }
            
            guard let result = data else {
                completion(.error(error ?? XCServerClientError.serilization))
                return
            }
            
            let decompressedData: Data
            do {
                decompressedData = try self.decompress(data: result)
            } catch let decompressionError {
                completion(.error(decompressionError))
                return
            }
            
            let coverage: XCSCoverageHierarchy
            do {
                coverage = try self.jsonDecoder.decode(XCSCoverageHierarchy.self, from: decompressedData)
            } catch let serializationError {
                completion(.error(serializationError))
                return
            }
            
            completion(.value(coverage))
        }
    }
}
