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

public class RevisionBlueprintJSON: SerializableObject {
    public var DVTSourceControlWorkspaceBlueprintIdentifierKey: String?
    public var DVTSourceControlWorkspaceBlueprintNameKey: String?
    public var DVTSourceControlWorkspaceBlueprintVersion: Int = -1
    public var DVTSourceControlWorkspaceBlueprintRelativePathToProjectKey: String?
    public var DVTSourceControlWorkspaceBlueprintPrimaryRemoteRepositoryKey: String?
    public var DVTSourceControlWorkspaceBlueprintRemoteRepositoriesKey: [RemoteRepositoryJSON]?
    public var DVTSourceControlWorkspaceBlueprintLocationsKey: [String : BlueprintLocationJSON] = [String : BlueprintLocationJSON]()
    public var DVTSourceControlWorkspaceBlueprintWorkingCopyRepositoryLocationsKey: [String : RepositoryLocationJSON] = [String : RepositoryLocationJSON]()
    public var DVTSourceControlWorkspaceBlueprintRemoteRepositoryAuthenticationStrategiesKey: [String : AuthenticationStrategyJSON] = [String : AuthenticationStrategyJSON]()
    public var DVTSourceControlWorkspaceBlueprintWorkingCopyStatesKey: [String : NSNumber]?
    public var DVTSourceControlWorkspaceBlueprintWorkingCopyPathsKey: [String : String]?
    
    override public func initializedObject(forPropertyName propertyName: String, withData data: NSObject) -> NSObject? {
        if propertyName == "DVTSourceControlWorkspaceBlueprintLocationsKey" {
            var initialized = [String : BlueprintLocationJSON]()
            
            guard let cast = data as? [String : SerializableDictionary] else {
                return initialized as NSObject?
            }
            
            for (key, value) in cast {
                initialized[key] = BlueprintLocationJSON(withDictionary: value)
            }
            
            return initialized as NSObject?
        } else if propertyName == "DVTSourceControlWorkspaceBlueprintWorkingCopyRepositoryLocationsKey" {
            var initialized = [String : RepositoryLocationJSON]()
            
            guard let cast = data as? [String : SerializableDictionary] else {
                return initialized as NSObject?
            }
            
            for (key, value) in cast {
                initialized[key] = RepositoryLocationJSON(withDictionary: value)
            }
            
            return initialized as NSObject?
        } else if propertyName == "DVTSourceControlWorkspaceBlueprintRemoteRepositoryAuthenticationStrategiesKey" {
            var initialized = [String : AuthenticationStrategyJSON]()
            
            guard let cast = data as? [String : SerializableDictionary] else {
                return initialized as NSObject?
            }
            
            for (key, value) in cast {
                initialized[key] = AuthenticationStrategyJSON(withDictionary: value)
            }
            
            return initialized as NSObject?
        }
        
        return super.initializedObject(forPropertyName: propertyName, withData: data)
    }
    
    override public func objectClassOfCollectionType(forPropertyname propertyName: String) -> AnyClass? {
        if propertyName == "DVTSourceControlWorkspaceBlueprintRemoteRepositoriesKey" {
            return RemoteRepositoryJSON.self
        }
        
        return super.objectClassOfCollectionType(forPropertyname: propertyName)
    }
    
    public var repositoryIds: [String] {
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
