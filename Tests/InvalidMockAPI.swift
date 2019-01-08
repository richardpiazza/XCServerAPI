import XCTest
@testable import XCServerAPI
import CodeQuickKit

class InvalidMockAPI: XCServerWebAPI {
    
    public func url(forResource resource: String) -> URL {
        let bundle = Bundle(for: type(of: self))
        if let url = bundle.url(forResource: resource, withExtension: "json") {
            return url
        }
        
        let path = FileManager.default.currentDirectoryPath
        let url = URL(fileURLWithPath: path).appendingPathComponent("Tests").appendingPathComponent(resource).appendingPathExtension("json")
        
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("Failed to locate resource \(resource).json")
        }
        
        return url
    }
    
    public convenience init() {
        guard let url = URL(string: "https://localhost:20343/api") else {
            preconditionFailure()
        }
        
        self.init(baseURL: url, session: nil, delegate: XCServerWebAPI.sessionDelegate)
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/ping")] = pingResponse
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/versions")] = versionsResponse
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/bots")] = botsResponse
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/bots/a7341f3521c7245492693c0d780006f9")] = botResponse
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/bots/a7341f3521c7245492693c0d780006f9/stats")] = statsResponse
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/bots/a7341f3521c7245492693c0d780006f9/integrations")] = integrationsResponse
        self.injectedResponses[InjectedPath(method: .post, absolutePath: "https://localhost:20343/api/bots/a7341f3521c7245492693c0d780006f9/integrations")] = integrationsRequest
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/integrations/8a526f6a0ce6b83bb969758e0f0038b7")] = integrationResponse
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/integrations/8a526f6a0ce6b83bb969758e0f0038b7/commits")] = commitsResponse
        self.injectedResponses[InjectedPath(string: "https://localhost:20343/api/integrations/8a526f6a0ce6b83bb969758e0f0038b7/issues")] = issuesResponse
    }
    
    /// Expected Errors
    /// - Status Code: 404
    public var pingResponse: InjectedResponse {
        var response = InjectedResponse()
        response.statusCode = 404
        return response
    }
    
    /// Expected Errors
    /// - No Data
    public var versionsResponse: InjectedResponse {
        var response = InjectedResponse()
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
    
    /// Expected Errors
    /// - Status Code: 401
    public var botsResponse: InjectedResponse {
        var response = InjectedResponse()
        response.statusCode = 401
        return response
    }
    
    /// Expected Errors
    /// - Status Code: 201
    public var botResponse: InjectedResponse {
        var response = InjectedResponse()
        response.statusCode = 201
        response.error = Errors.noXcodeServer
        return response
    }
    
    public var statsResponse: InjectedResponse {
        var response = InjectedResponse()
        let url = self.url(forResource: "StatsResponse")
        response.data = FileManager.default.contents(atPath: url.path)
        response.statusCode = 200
        return response
    }
    
    public var integrationsResponse: InjectedResponse {
        var response = InjectedResponse()
        let url = self.url(forResource: "IntegrationsResponse")
        response.data = FileManager.default.contents(atPath: url.path)
        response.statusCode = 200
        return response
    }
    
    public var integrationsRequest: InjectedResponse {
        var response = InjectedResponse()
        let url = self.url(forResource: "IntegrationsRequest")
        response.data = FileManager.default.contents(atPath: url.path)
        response.statusCode = 201
        return response
    }
    
    public var integrationResponse: InjectedResponse {
        var response = InjectedResponse()
        let url = self.url(forResource: "IntegrationResponse")
        response.data = FileManager.default.contents(atPath: url.path)
        response.statusCode = 200
        return response
    }
    
    public var commitsResponse: InjectedResponse {
        var response = InjectedResponse()
        let url = self.url(forResource: "CommitsResponse")
        response.data = FileManager.default.contents(atPath: url.path)
        response.statusCode = 200
        return response
    }
    
    public var issuesResponse: InjectedResponse {
        var response = InjectedResponse()
        let url = self.url(forResource: "IssuesResponse")
        response.data = FileManager.default.contents(atPath: url.path)
        response.statusCode = 200
        return response
    }
}
