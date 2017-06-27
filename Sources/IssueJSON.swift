//===----------------------------------------------------------------------===//
//
// IssueJSON.swift
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

public struct Issue: Codable {
    public var _id: String
    public var _rev: String
    public var message: String?
    public var type: String?
    public var fixItType: String?
    public var issueType: String?
    public var commits: [Commit]?
    public var integrationID: String?
    public var age: Int?
    public var status: Int?
    public var issueAuthors: [IssueAuthor]?
}

public class IssueJSON: SerializableObject, XCServerDocument {
    public var _id: String = ""
    public var _rev: String = ""
    
    public var status: Int = 0
    public var target: String?
    public var testCase: String?
    public var lineNumber: Int?
    public var documentLocationData: String?
    public var documentFilePath: String?
    public var age: Int = 0
    public var message: String?
    public var integrationID: String?
    public var type: String?
    public var issueType: String?
    
    public var commits: [CommitJSON] = [CommitJSON]()
    public var issueAuthors: [IssueAuthorJSON] = [IssueAuthorJSON]()
    
    override public func objectClassOfCollectionType(forPropertyname propertyName: String) -> AnyClass? {
        if propertyName == "commits" {
            return CommitJSON.self
        } else if propertyName == "issueAuthors" {
            return IssueAuthorJSON.self
        }
        
        return super.objectClassOfCollectionType(forPropertyname: propertyName)
    }
}
