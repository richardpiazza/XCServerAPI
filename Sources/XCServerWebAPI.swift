//===----------------------------------------------------------------------===//
//
// XCServerWebAPI.swift
//
// Copyright (c) 2016 Richard Piazza
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

public typealias XCServerWebAPICredentials = (username: String, password: String?)
public typealias XCServerWebAPICredentialsHeader = (value: String, key: String)

public protocol XCServerWebAPICredentialDelegate {
    func credentials(forAPI api: XCServerWebAPI) -> XCServerWebAPICredentials?
    func credentialsHeader(forAPI api: XCServerWebAPI) -> XCServerWebAPICredentialsHeader?
    func clearCredentials(forAPI api: XCServerWebAPI)
}

public extension XCServerWebAPICredentialDelegate {
    public func credentialsHeader(forAPI api: XCServerWebAPI) -> XCServerWebAPICredentialsHeader? {
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
        
        return XCServerWebAPICredentialsHeader(value: auth, key: WebAPI.HTTPHeaderKey.Authorization)
    }
    
    public func clearCredentials(forAPI api: XCServerWebAPI) {
        Log.info("Reset of XCServerWebAPI requested; Credentials should be cleared.")
    }
}

/// Wrapper for `WebAPI` that implements common Xcode Server requests.
public class XCServerWebAPI: WebAPI {
    
    public struct HTTPHeaders {
        public static let xscAPIVersion = "x-xscapiversion"
    }
    
    public enum Errors: Error {
        case authorization
        case noXcodeServer
        case decodeResponse
        
        public var code: Int {
            switch self {
            case .authorization: return 0
            case .noXcodeServer: return 1
            case .decodeResponse: return 2
            }
        }
        
        public var localizedDescription: String {
            switch self {
            case .authorization: return "Invalid Authorization"
            case .noXcodeServer: return "No Xcode Server"
            case .decodeResponse: return "Failed To Decode Response"
            }
        }
        
        public var localizedFailureReason: String {
            switch self {
            case .authorization: return "The server returned a 401 response code."
            case .noXcodeServer: return "This class was initialized without an XcodeServer entity."
            case .decodeResponse: return "The response object could not be cast into the requested type."
            }
        }
        
        public var localizedRecoverySuggestion: String {
            switch self {
            case .authorization: return "Have you specified a XCServerWebAPICredentialDelegate to handle authentication?"
            case .noXcodeServer: return "Re-initialize this class using init(xcodeServer:)."
            case .decodeResponse: return "Check the request is sending a valid response."
            }
        }
        
        public var nsError: NSError {
            return NSError(domain: String(describing: self), code: self.code, userInfo: [
                    NSLocalizedDescriptionKey: self.localizedDescription,
                    NSLocalizedFailureReasonErrorKey: self.localizedFailureReason,
                    NSLocalizedRecoverySuggestionErrorKey: self.localizedRecoverySuggestion
                ])
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
        
        let api = XCServerWebAPI(fqdn: fqdn)
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
    
    public convenience init(fqdn: String) {
        let url = URL(string: "https://\(fqdn):20343/api")
        self.init(baseURL: url, sessionDelegate: XCServerWebAPI.sessionDelegate)
    }
    
    public override func request(method: WebAPI.HTTPRequestMethod, path: String, queryItems: [URLQueryItem]?, data: Data?) throws -> NSMutableURLRequest {
        let request = try super.request(method: method, path: path, queryItems: queryItems, data: data)
        
        if let header = XCServerWebAPI.credentialDelegate.credentialsHeader(forAPI: self) {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
    
    // MARK: - Endpoints
    
    /// Requests the '`/ping`' endpoint from the Xcode Server API.
    public func ping(_ completion: @escaping WebAPIRequestCompletion) {
        self.get("ping", completion: completion)
    }
    
    public typealias VersionCompletion = (_ version: VersionDocument?, _ apiVersion: Int?, _ error: Error?) -> Void
    
    /// Requests the '`/version`' endpoint from the Xcode Server API.
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
            
            guard let versions = VersionDocument.decode(data: responseData) else {
                completion(nil, apiVersion, Errors.decodeResponse)
                return
            }
            
            completion(versions, apiVersion, nil)
        }
    }

}
