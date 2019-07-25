import XCTest
@testable import XCServerAPI
import CodeQuickKit

fileprivate var _injectedResponses: [InjectedPath : InjectedResponse] = [:]

extension MockAPI: HTTPInjectable {
    public var injectedResponses: [InjectedPath : InjectedResponse] {
        get {
            return _injectedResponses
        }
        set(newValue) {
            _injectedResponses = newValue
        }
    }
}

class MockAPI: XCServerClient {
    
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
        response.data = versionResponseJSON.data(using: .utf8)
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
        response.data = botsResponseJSON.data(using: .utf8)
        response.statusCode = 200
        return response
    }
    
    public var botResponse: InjectedResponse {
        var response = InjectedResponse()
        response.data = botResponseJSON.data(using: .utf8)
        response.statusCode = 200
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
