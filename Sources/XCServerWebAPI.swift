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
        
        guard let data = userpass.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) else {
            return nil
        }
        
        let base64 = data.base64EncodedStringWithOptions([])
        let auth = "Basic \(base64)"
        
        return XCServerWebAPICredentialsHeader(value: auth, key: WebAPIHeaderKey.Authorization)
    }
}

/// Wrapper for `WebAPI` that implements common Xcode Server requests.
public class XCServerWebAPI: WebAPI {
    
    /// Class implementing the NSURLSessionDelegate which forcefully bypasses
    /// untrusted SSL Certificates.
    public class XCServerDefaultSessionDelegate: NSObject, NSURLSessionDelegate {
        // MARK: - NSURLSessionDelegate
        @objc public func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
            guard challenge.previousFailureCount < 1 else {
                completionHandler(.CancelAuthenticationChallenge, nil)
                return
            }
            
            var credentials: NSURLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if let serverTrust = challenge.protectionSpace.serverTrust {
                    credentials = NSURLCredential(trust: serverTrust)
                }
            }
            
            completionHandler(.UseCredential, credentials)
        }
    }
    
    /// Class implementing the XCServerWebAPICredentialDelgate
    public class XCServerDefaultCredentialDelegate: XCServerWebAPICredentialDelegate {
        // MARK: - XCServerWebAPICredentialsDelegate
        public func credentials(forAPI api: XCServerWebAPI) -> XCServerWebAPICredentials? {
            return nil
        }
    }
    
    public static var sessionDelegate: NSURLSessionDelegate = XCServerDefaultSessionDelegate()
    public static var credentialDelegate: XCServerWebAPICredentialDelegate = XCServerDefaultCredentialDelegate()
    private static var apis = [String : XCServerWebAPI]()
    
    public static func api(forFQDN fqdn: String) -> XCServerWebAPI {
        if let api = self.apis[fqdn] {
            return api
        }
        
        let api = XCServerWebAPI(fqdn: fqdn)
        api.session.configuration.timeoutIntervalForRequest = 8
        api.session.configuration.timeoutIntervalForResource = 16
        api.session.configuration.HTTPCookieAcceptPolicy = .Never
        
        self.apis[fqdn] = api
        
        return api
    }
    
    public static func resetAPI(forFQDN fqdn: String) {
        if let _ = self.apis[fqdn] {
            self.apis[fqdn] = nil
        }
    }
    
    private let invalidAuthorization = NSError(domain: String(XCServerWebAPI.self), code: 0, userInfo: [
        NSLocalizedDescriptionKey: "Invalid Authorization",
        NSLocalizedFailureReasonErrorKey: "The server returned a 401 response code.",
        NSLocalizedRecoverySuggestionErrorKey: "Have you specified a XCServerWebAPICredentialDelegate to handle authentication?"
        ])
    
    private let invalidXcodeServer = NSError(domain: String(XCServerWebAPI.self), code: 0, userInfo: [
        NSLocalizedDescriptionKey: "Invalid Xcode Server",
        NSLocalizedFailureReasonErrorKey: "This class was initialized without an XcodeServer entity.",
        NSLocalizedRecoverySuggestionErrorKey: "Re-initialize this class using init(xcodeServer:)."
        ])
    
    private let invalidResponseCast = NSError(domain: String(XCServerWebAPI.self), code: 0, userInfo: [
        NSLocalizedDescriptionKey: "Invalid responseObject",
        NSLocalizedFailureReasonErrorKey: "The response object could not be cast into the requested type.",
        NSLocalizedRecoverySuggestionErrorKey: "Check the request is sending a valid response."
        ])
    
    public convenience init(fqdn: String) {
        let url = NSURL(string: "https://\(fqdn):20343/api")
        self.init(baseURL: url, sessionDelegate: XCServerWebAPI.sessionDelegate)
    }
    
    public override func request(forPath path: String, queryItems: [NSURLQueryItem]?, method: WebAPIRequestMethod, data: NSData?) -> NSMutableURLRequest? {
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
    public func getPing(completion: WebAPICompletion) {
        self.get("ping", completion: completion)
    }
    
    public typealias XCServerWebAPIVersionCompletion = (version: VersionJSON?, error: NSError?) -> Void
    
    /// Requests the '`/version`' endpoint from the Xcode Server API.
    public func getVersion(completion: XCServerWebAPIVersionCompletion) {
        self.get("version") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(version: nil, error: self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(version: nil, error: error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(version: nil, error: self.invalidResponseCast)
                return
            }
            
            let typedResponse = VersionJSON(withDictionary: dictionary)
            
            completion(version: typedResponse, error: nil)
        }
    }
    
    public typealias XCServerWebAPIBotsCompletion = (bots: [BotJSON]?, error: NSError?) -> Void
    
    /// Requests the '`/bots`' endpoint from the Xcode Server API.
    public func getBots(completion: XCServerWebAPIBotsCompletion) {
        self.get("bots") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(bots: nil, error: self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(bots: nil, error: error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(bots: nil, error: self.invalidResponseCast)
                return
            }
            
            let typedResponse = BotsResponse(withDictionary: dictionary)
            
            completion(bots: typedResponse.results, error: nil)
        }
    }
    
    public typealias XCServerWebAPIBotCompletion = (bot: BotJSON?, error: NSError?) -> Void
    
    /// Requests the '`/bots/{id}`' endpoint from the Xcode Server API.
    public func getBot(bot identifier: String, completion: XCServerWebAPIBotCompletion) {
        self.get("bot/\(identifier)") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(bot: nil, error: self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(bot: nil, error: error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(bot: nil, error: self.invalidResponseCast)
                return
            }
            
            let typedResponse = BotJSON(withDictionary: dictionary)
            
            completion(bot: typedResponse, error: nil)
        }
    }
    
    public typealias XCServerWebAPIStatsCompletion = (stats: StatsJSON?, error: NSError?) -> Void
    
    /// Requests the '`/bots/{id}/stats`' endpoint from the Xcode Server API.
    public func getStats(forBot identifier: String, completion: XCServerWebAPIStatsCompletion) {
        self.get("bot/\(identifier)/stats") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(stats: nil, error: self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(stats: nil, error: error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(stats: nil, error: self.invalidResponseCast)
                return
            }
            
            let typedResponse = StatsJSON(withDictionary: dictionary)
            
            completion(stats: typedResponse, error: nil)
        }
    }
    
    public typealias XCServerWebAPIIntegrationCompletion = (integration: IntegrationJSON?, error: NSError?) -> Void
    
    /// Posts a request to the '`/bots/{id}`' endpoint from the Xcode Server API.
    public func postBot(forBot identifier: String, completion: XCServerWebAPIIntegrationCompletion) {
        self.post(nil, path: "bots/\(identifier)/integrations") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(integration: nil, error: self.invalidAuthorization)
                return
            }
            
            guard statusCode == 201 else {
                completion(integration: nil, error: error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(integration: nil, error: self.invalidResponseCast)
                return
            }
            
            let typedResponse = IntegrationJSON(withDictionary: dictionary)
            
            completion(integration: typedResponse, error: nil)
        }
    }
    
    public typealias XCServerWebAPIIntegrationsCompletion = (integrations: [IntegrationJSON]?, error: NSError?) -> Void
    
    /// Requests the '`/bots/{id}/integrations`' endpoint from the Xcode Server API.
    public func getIntegrations(forBot identifier: String, completion: XCServerWebAPIIntegrationsCompletion) {
        self.get("bots/\(identifier)/integrations") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(integrations: nil, error: self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(integrations: nil, error: error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(integrations: nil, error: self.invalidResponseCast)
                return
            }
            
            let typedResponse = IntegrationsResponse(withDictionary: dictionary)
            
            completion(integrations: typedResponse.results, error: nil)
        }
    }
    
    /// Requests the '`/integrations/{id}`' endpoint from the Xcode Server API.
    public func getIntegration(integration identifier: String, completion: XCServerWebAPIIntegrationCompletion) {
        self.get("integrations/\(identifier)") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(integration: nil, error: self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(integration: nil, error: error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(integration: nil, error: self.invalidResponseCast)
                return
            }
            
            let typedResponse = IntegrationJSON(withDictionary: dictionary)
            
            completion(integration: typedResponse, error: nil)
        }
    }
    
    public typealias XCServerWebAPICommitsCompletion = (commits: [IntegrationCommitJSON]?, error: NSError?) -> Void
    
    /// Requests the '`/integrations/{id}/commits`' endpoint from the Xcode Server API.
    public func getCommits(forIntegration identifier: String, completion: XCServerWebAPICommitsCompletion) {
        self.get("integrations/\(identifier)/commits") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(commits: nil, error: self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(commits: nil, error: error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(commits: nil, error: self.invalidResponseCast)
                return
            }
            
            let typedResponse = IntegrationCommitsResponse(withDictionary: dictionary)
            
            completion(commits: typedResponse.results, error: nil)
        }
    }
    
    public typealias XCServerWebAPIIssuesCompletion = (issues: IntegrationIssuesResponse?, error: NSError?) -> Void
    
    /// Requests the '`/integrations/{id}/issues`' endpoint from the Xcode Server API.
    public func getIssues(forIntegration identifier: String, completion: XCServerWebAPIIssuesCompletion) {
        self.get("integrations/\(identifier)/issues") { (statusCode, response, responseObject, error) in
            guard statusCode != 401 else {
                completion(issues: nil, error: self.invalidAuthorization)
                return
            }
            
            guard statusCode == 200 else {
                completion(issues: nil, error: error)
                return
            }
            
            guard let dictionary = responseObject as? SerializableDictionary else {
                completion(issues: nil, error: self.invalidResponseCast)
                return
            }
            
            let typedResponse = IntegrationIssuesResponse(withDictionary: dictionary)
            
            completion(issues: typedResponse, error: nil)
        }
    }
}
