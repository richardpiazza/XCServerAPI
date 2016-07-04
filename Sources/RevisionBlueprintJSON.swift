//===----------------------------------------------------------------------===//
//
// RevisionBlueprintJSON.swift
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

class RevisionBlueprintJSON: SerializableObject {
    var DVTSourceControlWorkspaceBlueprintIdentifierKey: String?
    var DVTSourceControlWorkspaceBlueprintNameKey: String?
    var DVTSourceControlWorkspaceBlueprintVersion: NSNumber?
    var DVTSourceControlWorkspaceBlueprintRelativePathToProjectKey: String?
    var DVTSourceControlWorkspaceBlueprintPrimaryRemoteRepositoryKey: String?
    var DVTSourceControlWorkspaceBlueprintRemoteRepositoriesKey: [RemoteRepositoryJSON]?
    var DVTSourceControlWorkspaceBlueprintLocationsKey: [String : BlueprintLocationJSON] = [String : BlueprintLocationJSON]()
    var DVTSourceControlWorkspaceBlueprintWorkingCopyRepositoryLocationsKey: [String : RepositoryLocationJSON] = [String : RepositoryLocationJSON]()
    var DVTSourceControlWorkspaceBlueprintRemoteRepositoryAuthenticationStrategiesKey: [String : AuthenticationStrategyJSON] = [String : AuthenticationStrategyJSON]()
    var DVTSourceControlWorkspaceBlueprintWorkingCopyStatesKey: [String : NSNumber]?
    var DVTSourceControlWorkspaceBlueprintWorkingCopyPathsKey: [String : String]?
    
    override func initializedObject(forPropertyName propertyName: String, withData data: NSObject) -> NSObject? {
        if propertyName == "DVTSourceControlWorkspaceBlueprintLocationsKey" {
            var initialized = [String : BlueprintLocationJSON]()
            
            guard let cast = data as? [String : SerializableDictionary] else {
                return initialized
            }
            
            for (key, value) in cast {
                initialized[key] = BlueprintLocationJSON(withDictionary: value)
            }
            
            return initialized
        } else if propertyName == "DVTSourceControlWorkspaceBlueprintWorkingCopyRepositoryLocationsKey" {
            var initialized = [String : RepositoryLocationJSON]()
            
            guard let cast = data as? [String : SerializableDictionary] else {
                return initialized
            }
            
            for (key, value) in cast {
                initialized[key] = RepositoryLocationJSON(withDictionary: value)
            }
            
            return initialized
        } else if propertyName == "DVTSourceControlWorkspaceBlueprintRemoteRepositoryAuthenticationStrategiesKey" {
            var initialized = [String : AuthenticationStrategyJSON]()
            
            guard let cast = data as? [String : SerializableDictionary] else {
                return initialized
            }
            
            for (key, value) in cast {
                initialized[key] = AuthenticationStrategyJSON(withDictionary: value)
            }
            
            return initialized
        }
        
        return super.initializedObject(forPropertyName: propertyName, withData: data)
    }
    
    override func objectClassOfCollectionType(forPropertyname propertyName: String) -> AnyClass? {
        if propertyName == "DVTSourceControlWorkspaceBlueprintRemoteRepositoriesKey" {
            return RemoteRepositoryJSON.self
        }
        
        return super.objectClassOfCollectionType(forPropertyname: propertyName)
    }
    
    var repositoryIds: [String] {
        var ids = [String]()
        
        if let remoteRepositories = self.DVTSourceControlWorkspaceBlueprintRemoteRepositoriesKey {
            for repo in remoteRepositories {
                if let id  = repo.DVTSourceControlWorkspaceBlueprintRemoteRepositoryIdentifierKey {
                    ids.append(id)
                }
            }
        }
        
        return ids
    }
}
