//===----------------------------------------------------------------------===//
//
// APIResponses.swift
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

/// ## BotsResponse
/// This is the response structure received from the Xcode Server API when
/// querying /bots endpoint.
public class BotsResponse: SerializableObject {
    public var count: Int = 0
    public var results: [BotJSON] = [BotJSON]()
    
    override public func objectClassOfCollectionType(forPropertyname propertyName: String) -> AnyClass? {
        if propertyName == "results" {
            return BotJSON.self
        }
        
        return super.objectClassOfCollectionType(forPropertyname: propertyName)
    }
}

/// ## IntegrationsResponse
/// This is the response structure received from the Xcode Server API when
/// querying /bots/{id}/integrations endpoint.
public class IntegrationsResponse : SerializableObject {
    public var count: Int = 0
    public var results: [IntegrationJSON] = [IntegrationJSON]()
    
    override public func objectClassOfCollectionType(forPropertyname propertyName: String) -> AnyClass? {
        if propertyName == "results" {
            return IntegrationJSON.self
        }
        
        return super.objectClassOfCollectionType(forPropertyname: propertyName)
    }
}

/// ## IntegrationCommitsResponse
/// This is the response structure received from the Xcode Server API when
/// querying /integrations/{id}/commits endpoint.
public class IntegrationCommitsResponse : SerializableObject {
    public var count: Int = 0
    public var results: [IntegrationCommitJSON] = [IntegrationCommitJSON]()
    
    override public func objectClassOfCollectionType(forPropertyname propertyName: String) -> AnyClass? {
        if propertyName == "results" {
            return IntegrationCommitJSON.self
        }
        
        return super.objectClassOfCollectionType(forPropertyname: propertyName)
    }
}

/// ## IntegrationIssuesResponse
/// This is the response structure received from the Xcode Server API when
/// querying /integrations/{id}/issues endpoint.
public class IntegrationIssuesResponse : SerializableObject {
    public var errors: IntegrationIssuesJSON?
    public var warnings: IntegrationIssuesJSON?
    public var analyzerWarnings: IntegrationIssuesJSON?
    public var testFailures: IntegrationIssuesJSON?
    public var buildServiceErrors: [IssueJSON] = [IssueJSON]()
    public var buildServiceWarnings: [IssueJSON] = [IssueJSON]()
}
