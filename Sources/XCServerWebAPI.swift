import Foundation
import CodeQuickKit

public typealias XCServerWebAPICredentials = (username: String, password: String?)
public typealias XCServerWebAPICredentialsHeader = (value: String, key: String)

@available(*, deprecated, message: "Use `XCServerClientAuthorizationDelegate`.")
public protocol XCServerWebAPICredentialDelegate {
    func credentials(forAPI api: XCServerWebAPI) -> XCServerWebAPICredentials?
    func credentialsHeader(forAPI api: XCServerWebAPI) -> XCServerWebAPICredentialsHeader?
    func clearCredentials(forAPI api: XCServerWebAPI)
}

@available(*, deprecated)
public extension XCServerWebAPICredentialDelegate {
    func credentialsHeader(forAPI api: XCServerWebAPI) -> XCServerWebAPICredentialsHeader? {
        guard let creds = credentials(forAPI: api) else {
            return nil
        }
        
        let username = creds.username
        let password = creds.password ?? ""
        
        let userpass = "\(username):\(password)"
        
        guard let data = userpass.data(using: String.Encoding.utf8, allowLossyConversion: true) else {
            return nil
        }
        
        let base64 = data.base64EncodedString(options: [])
        let auth = "Basic \(base64)"
        
        return XCServerWebAPICredentialsHeader(value: auth, key: HTTP.Header.authorization.rawValue)
    }
    
    func clearCredentials(forAPI api: XCServerWebAPI) {
        Log.info("Reset of XCServerWebAPI requested; Credentials should be cleared.")
    }
}

/// Wrapper for `WebAPI` that implements common Xcode Server requests.
@available(*, deprecated, message: "Use `XCServerClient`.")
public class XCServerWebAPI: WebAPI {
    
    public struct HTTPHeaders {
        public static let xscAPIVersion = "x-xscapiversion"
    }
    
    public enum Errors: Error, LocalizedError {
        case authorization
        case noXcodeServer
        case decodeResponse
        
        public var errorDescription: String? {
            switch self {
                case .authorization: return "The server returned a 401 response code."
                case .noXcodeServer: return "This class was initialized without an XcodeServer entity."
                case .decodeResponse: return "The response object could not be cast into the requested type."
            }
        }
    }
    
    /// Class implementing the NSURLSessionDelegate which forcefully bypasses
    /// untrusted SSL Certificates.
    public class XCServerDefaultSessionDelegate: NSObject, URLSessionDelegate {
        // MARK: - NSURLSessionDelegate
        @objc open func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            guard challenge.previousFailureCount < 1 else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            
            var credentials: URLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if let serverTrust = challenge.protectionSpace.serverTrust {
                    credentials = URLCredential(trust: serverTrust)
                }
            }
            
            completionHandler(.useCredential, credentials)
        }
    }
    
    /// Class implementing the XCServerWebAPICredentialDelgate
    public class XCServerDefaultCredentialDelegate: XCServerWebAPICredentialDelegate {
        // MARK: - XCServerWebAPICredentialsDelegate
        open func credentials(forAPI api: XCServerWebAPI) -> XCServerWebAPICredentials? {
            return nil
        }
    }
    
    public static var sessionDelegate: URLSessionDelegate = XCServerDefaultSessionDelegate()
    public static var credentialDelegate: XCServerWebAPICredentialDelegate = XCServerDefaultCredentialDelegate()
    fileprivate static var apis = [String : XCServerWebAPI]()
    
    public static func api(forFQDN fqdn: String) -> XCServerWebAPI {
        if let api = self.apis[fqdn] {
            return api
        }
        
        guard let api = XCServerWebAPI(fqdn: fqdn) else {
            preconditionFailure()
        }
        
        api.session.configuration.timeoutIntervalForRequest = 8
        api.session.configuration.timeoutIntervalForResource = 16
        api.session.configuration.httpCookieAcceptPolicy = .never
        api.session.configuration.httpShouldSetCookies = false
        
        self.apis[fqdn] = api
        
        return api
    }
    
    public static func resetAPI(forFQDN fqdn: String) {
        guard let api = self.apis[fqdn] else {
            return
        }
        
        credentialDelegate.clearCredentials(forAPI: api)
        
        self.apis[fqdn] = nil
    }
    
    public convenience init?(fqdn: String) {
        guard let url = URL(string: "https://\(fqdn):20343/api") else {
            return nil
        }
        
        self.init(baseURL: url, session: nil, delegate: XCServerWebAPI.sessionDelegate)
    }
    
    public func request(method: HTTP.RequestMethod, path: String, queryItems: [URLQueryItem]?, data: Data?) throws -> URLRequest {
        var request = try super.request(method: method, path: path, queryItems: queryItems, data: data)
        
        if let header = XCServerWebAPI.credentialDelegate.credentialsHeader(forAPI: self) {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
    
    // MARK: - Endpoints
    
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
                completion(nil, apiVersion, Errors.authorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, apiVersion, error)
                return
            }
            
            if let responseHeaders = headers {
                if let version = responseHeaders[HTTPHeaders.xscAPIVersion] as? String {
                    apiVersion = Int(version)
                }
            }
            
            guard let responseData = data else {
                completion(nil, apiVersion, Errors.decodeResponse)
                return
            }
            
            guard let versions = XCSVersion.decode(data: responseData) else {
                completion(nil, apiVersion, Errors.decodeResponse)
                return
            }
            
            completion(versions, apiVersion, nil)
        }
    }

}
