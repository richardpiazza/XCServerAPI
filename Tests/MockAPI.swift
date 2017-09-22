//
//  MockAPI.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 7/12/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import Foundation
@testable import XCServerAPI

class MockAPI: XCServerWebAPI {
    
    public convenience init() {
        let url = URL(string: "https://localhost:20343/api")
        self.init(baseURL: url, sessionDelegate: XCServerWebAPI.sessionDelegate)
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/ping")] = pingResponse
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/versions")] = versionsResponse
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/bots")] = botsResponse
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/bots/a7341f3521c7245492693c0d780006f9")] = botResponse
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/bots/a7341f3521c7245492693c0d780006f9/stats")] = statsResponse
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/bots/a7341f3521c7245492693c0d780006f9/integrations")] = integrationsResponse
        self.injectedResponses[InjectedPath(method: .post, string: "https://localhost:20343/api/bots/a7341f3521c7245492693c0d780006f9/integrations")] = integrationsRequest
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/integrations/8a526f6a0ce6b83bb969758e0f0038b7")] = integrationResponse
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/integrations/8a526f6a0ce6b83bb969758e0f0038b7/commits")] = commitsResponse
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/integrations/8a526f6a0ce6b83bb969758e0f0038b7/issues")] = issuesResponse
    }
    
    public var pingResponse: InjectedResponse {
        var response = InjectedResponse()
        response.statusCode = 204
        response.headers = [
            "Etag" : "W/\"a-oQDOV50e1MN2H/N8GYi+8w\"",
            "x-xscapiversion" : "18",
            "Keep-Alive" : "timeout=5; max=100",
            "Connection" : "keep-alive",
            "Set-Cookie" : "session=s%3Ag34rWKkpyAl6FE7xDcFV_JiSVZ-Z9qc6.PI0ukpIIFI2CpsfY1XSDbinKJNRY%2BFJ%2F5Ap4Pw6wtgM; Path=/; Expires=Thu, 13 Jul 2017 12:39:55 GMT; HttpOnly; Secure",
            "Date" : "Wed, 12 Jul 2017 12:39:55 GMT"
        ]
        return response
    }
    
    public var versionsResponse: InjectedResponse {
        var response = InjectedResponse()
        let url = Bundle(for: type(of: self)).url(forResource: "VersionResponse", withExtension: "json")!
        response.data = FileManager.default.contents(atPath: url.path)
        response.statusCode = 200
        response.headers = [
            "Connection" : "keep-alive",
            "Content-Type" : "application/json",
            "Vary" : "Accept-Encoding",
            "Date" : "Wed, 12 Jul 2017 13:25:05 GMT",
            "Content-Encoding" : "gzip",
            "Keep-Alive" : "timeout=5; max=100",
            "x-xscapiversion" : "18",
            "Transfer-Encoding" : "Identity"
        ]
        return response
    }
    
    public var botsResponse: InjectedResponse {
        var response = InjectedResponse()
        let url = Bundle(for: type(of: self)).url(forResource: "BotsResponse", withExtension: "json")!
        response.data = FileManager.default.contents(atPath: url.path)
        response.statusCode = 200
        return response
    }
    
    public var botResponse: InjectedResponse {
        var response = InjectedResponse()
        let url = Bundle(for: type(of: self)).url(forResource: "BotResponse", withExtension: "json")!
        response.data = FileManager.default.contents(atPath: url.path)
        response.statusCode = 200
        return response
    }
    
    public var statsResponse: InjectedResponse {
        var response = InjectedResponse()
        let url = Bundle(for: type(of: self)).url(forResource: "StatsResponse", withExtension: "json")!
        response.data = FileManager.default.contents(atPath: url.path)
        response.statusCode = 200
        return response
    }
    
    public var integrationsResponse: InjectedResponse {
        var response = InjectedResponse()
        let url = Bundle(for: type(of: self)).url(forResource: "IntegrationsResponse", withExtension: "json")!
        response.data = FileManager.default.contents(atPath: url.path)
        response.statusCode = 200
        return response
    }
    
    public var integrationsRequest: InjectedResponse {
        var response = InjectedResponse()
        let url = Bundle(for: type(of: self)).url(forResource: "IntegrationsRequest", withExtension: "json")!
        response.data = FileManager.default.contents(atPath: url.path)
        response.statusCode = 201
        return response
    }
    
    public var integrationResponse: InjectedResponse {
        var response = InjectedResponse()
        let url = Bundle(for: type(of: self)).url(forResource: "IntegrationResponse", withExtension: "json")!
        response.data = FileManager.default.contents(atPath: url.path)
        response.statusCode = 200
        return response
    }
    
    public var commitsResponse: InjectedResponse {
        var response = InjectedResponse()
        let url = Bundle(for: type(of: self)).url(forResource: "CommitsResponse", withExtension: "json")!
        response.data = FileManager.default.contents(atPath: url.path)
        response.statusCode = 200
        return response
    }
    
    public var issuesResponse: InjectedResponse {
        var response = InjectedResponse()
        let url = Bundle(for: type(of: self)).url(forResource: "IssuesResponse", withExtension: "json")!
        response.data = FileManager.default.contents(atPath: url.path)
        response.statusCode = 200
        return response
    }
}
