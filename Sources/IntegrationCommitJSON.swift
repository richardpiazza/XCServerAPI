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

class IntegrationCommitJSON: SerializableObject {
    var _id: String?
    var _rev: String?
    var doc_type: String?
    var tinyID: String?
    var integration: String?
    var botID: String?
    var botTinyID: String?
    var endedTimeDate: [Int] = [Int]()
    var commits: [String : [CommitJSON]] = [String : [CommitJSON]]()
    
    override func initializedObject(forPropertyName propertyName: String, withData data: NSObject) -> NSObject? {
        if propertyName == "commits" {
            var initialized = [String : [CommitJSON]]()
            
            guard let cast = data as? [String : [SerializableDictionary]] else {
                return initialized
            }
            
            for (key, value) in cast {
                var array = [CommitJSON]()
                for dictionary in value {
                    array.append(CommitJSON(withDictionary: dictionary))
                }
                initialized[key] = array
            }
            
            return initialized
        }
        
        return super.initializedObject(forPropertyName: propertyName, withData: data)
    }
}
