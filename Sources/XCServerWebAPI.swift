//===----------------------------------------------------------------------===//
//
// XCServerWebAPI.swift
//
// Copyright (c) 2016 Richard Piazza
// https://github.com/richardpiazza/XCServerCoreData
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
        
        return XCServerWebAPICredentialsHeader(value: auth, key: WebAPIHeaderKey.Authorization)
    }
}

/// Wrapper for `WebAPI` that implements common Xcode Server requests.
public class XCServerWebAPI: WebAPI {
    
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
        
        self.apis[fqdn] = api
        
        return api
    }
    
    public static func resetAPI(forFQDN fqdn: String) {
        if let _ = self.apis[fqdn] {
            self.apis[fqdn] = nil
        }
    }
    
    fileprivate let invalidAuthorization = NSError(domain: String(describing: XCServerWebAPI.self), code: 0, userInfo: [
        NSLocalizedDescriptionKey: "Invalid Authorization",
        NSLocalizedFailureReasonErrorKey: "The server returned a 401 response code.",
        NSLocalizedRecoverySuggestionErrorKey: "Have you specified a XCServerWebAPICredentialDelegate to handle authentication?"
        ])
    
    fileprivate let invalidXcodeServer = NSError(domain: String(describing: XCServerWebAPI.self), code: 0, userInfo: [
        NSLocalizedDescriptionKey: "Invalid Xcode Server",
        NSLocalizedFailureReasonErrorKey: "This class was initialized without an XcodeServer entity.",
        NSLocalizedRecoverySuggestionErrorKey: "Re-initialize this class using init(xcodeServer:)."
        ])
    
    fileprivate let invalidResponseCast = NSError(domain: String(describing: XCServerWebAPI.self), code: 0, userInfo: [
        NSLocalizedDescriptionKey: "Invalid responseObject",
        NSLocalizedFailureReasonErrorKey: "The response object could not be cast into the requested type.",
        NSLocalizedRecoverySuggestionErrorKey: "Check the request is sending a valid response."
        ])
    
    public convenience init(fqdn: String) {
        let url = URL(string: "https://\(fqdn):20343/api")
        self.init(baseURL: url, sessionDelegate: XCServerWebAPI.sessionDelegate)
    }
    
    override public func request(forPath path: String, queryItems: [URLQueryItem]?, method: WebAPIRequestMethod, data: Data?) -> NSMutableURLRequest? {
        guard let request = super.request(forPath: path, queryItems: queryItems, method: method, data: data) else {
            return nil
        }
        
        if let header = XCServerWebAPI.credentialDelegate.credentialsHeader(forAPI: self) {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
    
    // MARK: - Endpoints
    
    /// Requests the '`/ping`' endpoint from the Xcode Server API.
    public func getPing(_ completion: @escaping WebAPICompletion) {
        self.get("ping", completion: completion)
    }
    
    public typealias XCServerWebAPIVersionCompletion = (_ version: VersionJSON?, _ error: NSError?) -> Void
    
    /// Requests the '`/version`' endpoint from the Xcode Server API.
    public func getVersion(_ completion: @escaping XCServerWebAPIVersionCompletion) {
        self.get("version") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(nil, self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(nil, self.invalidResponseCast)
                return
            }
            
            let typedResponse = VersionJSON(withDictionary: dictionary)
            
            completion(typedResponse, nil)
        }
    }
    
    public typealias XCServerWebAPIBotsCompletion = (_ bots: [BotJSON]?, _ error: NSError?) -> Void
    
    /// Requests the '`/bots`' endpoint from the Xcode Server API.
    public func getBots(_ completion: @escaping XCServerWebAPIBotsCompletion) {
        self.get("bots") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(nil, self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(nil, self.invalidResponseCast)
                return
            }
            
            let typedResponse = BotsResponse(withDictionary: dictionary)
            
            completion(typedResponse.results, nil)
        }
    }
    
    public typealias XCServerWebAPIBotCompletion = (_ bot: BotJSON?, _ error: NSError?) -> Void
    
    /// Requests the '`/bots/{id}`' endpoint from the Xcode Server API.
    public func getBot(bot identifier: String, completion: @escaping XCServerWebAPIBotCompletion) {
        self.get("bots/\(identifier)") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(nil, self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(nil, self.invalidResponseCast)
                return
            }
            
            let typedResponse = BotJSON(withDictionary: dictionary)
            
            completion(typedResponse, nil)
        }
    }
    
    public typealias XCServerWebAPIStatsCompletion = (_ stats: StatsJSON?, _ error: NSError?) -> Void
    
    /// Requests the '`/bots/{id}/stats`' endpoint from the Xcode Server API.
    public func getStats(forBot identifier: String, completion: @escaping XCServerWebAPIStatsCompletion) {
        self.get("bots/\(identifier)/stats") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(nil, self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(nil, self.invalidResponseCast)
                return
            }
            
            let typedResponse = StatsJSON(withDictionary: dictionary)
            
            completion(typedResponse, nil)
        }
    }
    
    public typealias XCServerWebAPIIntegrationCompletion = (_ integration: IntegrationJSON?, _ error: NSError?) -> Void
    
    /// Posts a request to the '`/bots/{id}`' endpoint from the Xcode Server API.
    public func postBot(forBot identifier: String, completion: @escaping XCServerWebAPIIntegrationCompletion) {
        self.post(nil, path: "bots/\(identifier)/integrations") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(nil, self.invalidAuthorization)
                return
            }
            
            guard statusCode == 201 else {
                completion(nil, error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(nil, self.invalidResponseCast)
                return
            }
            
            let typedResponse = IntegrationJSON(withDictionary: dictionary)
            
            completion(typedResponse, nil)
        }
    }
    
    public typealias XCServerWebAPIIntegrationsCompletion = (_ integrations: [IntegrationJSON]?, _ error: NSError?) -> Void
    
    /// Requests the '`/bots/{id}/integrations`' endpoint from the Xcode Server API.
    public func getIntegrations(forBot identifier: String, completion: @escaping XCServerWebAPIIntegrationsCompletion) {
        self.get("bots/\(identifier)/integrations") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(nil, self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(nil, self.invalidResponseCast)
                return
            }
            
            let typedResponse = IntegrationsResponse(withDictionary: dictionary)
            
            completion(typedResponse.results, nil)
        }
    }
    
    /// Requests the '`/integrations/{id}`' endpoint from the Xcode Server API.
    public func getIntegration(integration identifier: String, completion: @escaping XCServerWebAPIIntegrationCompletion) {
        self.get("integrations/\(identifier)") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(nil, self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(nil, self.invalidResponseCast)
                return
            }
            
            let typedResponse = IntegrationJSON(withDictionary: dictionary)
            
            completion(typedResponse, nil)
        }
    }
    
    public typealias XCServerWebAPICommitsCompletion = (_ commits: [IntegrationCommitJSON]?, _ error: NSError?) -> Void
    
    /// Requests the '`/integrations/{id}/commits`' endpoint from the Xcode Server API.
    public func getCommits(forIntegration identifier: String, completion: @escaping XCServerWebAPICommitsCompletion) {
        self.get("integrations/\(identifier)/commits") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(nil, self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(nil, self.invalidResponseCast)
                return
            }
            
            let typedResponse = IntegrationCommitsResponse(withDictionary: dictionary)
            
            completion(typedResponse.results, nil)
        }
    }
    
    public typealias XCServerWebAPIIssuesCompletion = (_ issues: IntegrationIssuesResponse?, _ error: NSError?) -> Void
    
    /// Requests the '`/integrations/{id}/issues`' endpoint from the Xcode Server API.
    public func getIssues(forIntegration identifier: String, completion: @escaping XCServerWebAPIIssuesCompletion) {
        self.get("integrations/\(identifier)/issues") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(nil, self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(nil, self.invalidResponseCast)
                return
            }
            
            let typedResponse = IntegrationIssuesResponse(withDictionary: dictionary)
            
            completion(typedResponse, nil)
        }
    }
}
