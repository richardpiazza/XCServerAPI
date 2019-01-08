import Foundation
import CodeQuickKit

public class XCServerClient: XCServerHTTPClient {
    
    public enum Error: Swift.Error, LocalizedError {
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
    
    public struct Header {
        public static let xscAPIVersion = "x-xscapiversion"
        
        private init() {}
    }
    
    public var baseURL: URL
    public var session: URLSession
    public var authorization: HTTP.Authorization?
    
    public static var authorizationDelegate: XCServerHTTPClientAuthorizationDelegate?
    
    public init(fqdn: String) throws {
        guard let url = URL(string: "https://\(fqdn):20343/api") else {
            throw Error.fqdn
        }
        
        baseURL = url
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: SelfSignedSessionDelegate(), delegateQueue: nil)
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
}
