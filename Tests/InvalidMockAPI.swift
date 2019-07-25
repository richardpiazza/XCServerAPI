import XCTest
@testable import XCServerAPI
import CodeQuickKit

fileprivate var _injectedResponses: [InjectedPath : InjectedResponse] = [:]

extension InvalidMockAPI: HTTPInjectable {
    public var injectedResponses: [InjectedPath : InjectedResponse] {
        get {
            return _injectedResponses
        }
        set(newValue) {
            _injectedResponses = newValue
        }
    }
}

class InvalidMockAPI: XCServerClient {
    
    public convenience init() throws {
        try self.init(fqdn: "localhost")
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
    
    override func execute(request: URLRequest, completion: @escaping HTTP.DataTaskCompletion) {
        let injectedPath = InjectedPath(request: request)
        
        guard let injectedResponse = injectedResponses[injectedPath] else {
            completion(0, nil, nil, HTTP.Error.invalidResponse)
            return
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(injectedResponse.timeout * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: { () -> Void in
            completion(injectedResponse.statusCode, injectedResponse.headers, injectedResponse.data, injectedResponse.error)
        })
        #else
        let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly: injectedResponse.timeout) ?? TimeInterval(floatLiteral: 0.0), repeats: false, block: { (timer) in
            completion(injectedResponse.statusCode, injectedResponse.headers, injectedResponse.data, injectedResponse.error)
        })
        #endif
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
        response.error = XCServerClientError.xcodeServer
        return response
    }
    
    public var statsResponse: InjectedResponse {
        var response = InjectedResponse()
        response.data = statsResponseJSON.data(using: .utf8)
        response.statusCode = 200
        return response
    }
    
    public var integrationsResponse: InjectedResponse {
        var response = InjectedResponse()
        response.data = integrationsResponseJSON.data(using: .utf8)
        response.statusCode = 200
        return response
    }
    
    public var integrationsRequest: InjectedResponse {
        var response = InjectedResponse()
        response.data = integrationRequestJSON.data(using: .utf8)
        response.statusCode = 201
        return response
    }
    
    public var integrationResponse: InjectedResponse {
        var response = InjectedResponse()
        response.data = integrationResponseJSON.data(using: .utf8)
        response.statusCode = 200
        return response
    }
    
    public var commitsResponse: InjectedResponse {
        var response = InjectedResponse()
        response.data = commitsResponseJSON.data(using: .utf8)
        response.statusCode = 200
        return response
    }
    
    public var issuesResponse: InjectedResponse {
        var response = InjectedResponse()
        response.data = issuesResponseJSON.data(using: .utf8)
        response.statusCode = 200
        return response
    }
}
