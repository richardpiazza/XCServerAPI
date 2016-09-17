//===----------------------------------------------------------------------===//
//
// IntegrationCommitJSON.swift
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

public class IntegrationCommitJSON: SerializableObject {
    public var _id: String?
    public var _rev: String?
    public var doc_type: String?
    public var tinyID: String?
    public var integration: String?
    public var botID: String?
    public var botTinyID: String?
    public var endedTimeDate: [Int] = [Int]()
    public var commits: [String : [CommitJSON]] = [String : [CommitJSON]]()
    
    override public func initializedObject(forPropertyName propertyName: String, withData data: NSObject) -> NSObject? {
        if propertyName == "commits" {
            var initialized = [String : [CommitJSON]]()
            
            guard let cast = data as? [String : [SerializableDictionary]] else {
                return initialized as NSObject?
            }
            
            for (key, value) in cast {
                var array = [CommitJSON]()
                for dictionary in value {
                    array.append(CommitJSON(withDictionary: dictionary))
                }
                initialized[key] = array
            }
            
            return initialized as NSObject?
        }
        
        return super.initializedObject(forPropertyName: propertyName, withData: data)
    }
}
