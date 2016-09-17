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
open class BotsResponse: SerializableObject {
    open var count: Int = 0
    open var results: [BotJSON] = [BotJSON]()
    
    override open func objectClassOfCollectionType(forPropertyname propertyName: String) -> AnyClass? {
        if propertyName == "results" {
            return BotJSON.self
        }
        
        return super.objectClassOfCollectionType(forPropertyname: propertyName)
    }
}

/// ## IntegrationsResponse
/// This is the response structure received from the Xcode Server API when
/// querying /bots/{id}/integrations endpoint.
open class IntegrationsResponse : SerializableObject {
    open var count: Int = 0
    open var results: [IntegrationJSON] = [IntegrationJSON]()
    
    override open func objectClassOfCollectionType(forPropertyname propertyName: String) -> AnyClass? {
        if propertyName == "results" {
            return IntegrationJSON.self
        }
        
        return super.objectClassOfCollectionType(forPropertyname: propertyName)
    }
}

/// ## IntegrationCommitsResponse
/// This is the response structure received from the Xcode Server API when
/// querying /integrations/{id}/commits endpoint.
open class IntegrationCommitsResponse : SerializableObject {
    open var count: Int = 0
    open var results: [IntegrationCommitJSON] = [IntegrationCommitJSON]()
    
    override open func objectClassOfCollectionType(forPropertyname propertyName: String) -> AnyClass? {
        if propertyName == "results" {
            return IntegrationCommitJSON.self
        }
        
        return super.objectClassOfCollectionType(forPropertyname: propertyName)
    }
}

/// ## IntegrationIssuesResponse
/// This is the response structure received from the Xcode Server API when
/// querying /integrations/{id}/issues endpoint.
open class IntegrationIssuesResponse : SerializableObject {
    open var errors: IntegrationIssuesJSON?
    open var warnings: IntegrationIssuesJSON?
    open var analyzerWarnings: IntegrationIssuesJSON?
    open var testFailures: IntegrationIssuesJSON?
    open var buildServiceErrors: [IssueJSON] = [IssueJSON]()
    open var buildServiceWarnings: [IssueJSON] = [IssueJSON]()
    
    open override func objectClassOfCollectionType(forPropertyname propertyName: String) -> AnyClass? {
        switch propertyName {
        case "buildServiceErrors", "buildServiceWarnings": return IssueJSON.self
        default: return super.objectClassOfCollectionType(forPropertyname: propertyName)
        }
    }
}
