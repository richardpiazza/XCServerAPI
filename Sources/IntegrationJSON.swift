//===----------------------------------------------------------------------===//
//
// IntegrationJSON.swift
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

public class IntegrationJSON: SerializableObject {
    public var _id: String = ""
    public var _rev: String?
    public var doc_type: String?
    public var tinyID: String?
    public var number: Int = 0
    public var shouldClean: Bool = false
    public var currentStep: String?
    public var result: String?
    public var buildResultSummary: BuildResultSummaryJSON?
    public var queuedDate: String?
    public var startedTime: String?
    public var endedTime: String?
    public var endedTimeDate: [Int] = [Int]()
    public var duration: Float = 0
    public var success_streak: Int = 0
    public var tags: [String] = [String]()
    public var buildServiceFingerprint: String?
    public var testedDevices: [DeviceJSON] = [DeviceJSON]()
    public var testHierarchy: [String : AnyObject]?
    public var perfMetricNames: [String] = [String]()
    public var perfMetricKeyPaths: [String] = [String]()
    public var assets: IntegrationAssetsJSON?
    public var revisionBlueprint: RevisionBlueprintJSON?
    public var hasCoverageData: Bool?
    
    override public func propertyName(forSerializedKey serializedKey: String) -> String? {
        if serializedKey == "lastRevisionBlueprint" {
            return "revisionBlueprint"
        }
        
        return super.propertyName(forSerializedKey: serializedKey)
    }
    
    override public func objectClassOfCollectionType(forPropertyname propertyName: String) -> AnyClass? {
        if propertyName == "testedDevices" {
            return DeviceJSON.self
        }
        
        return super.objectClassOfCollectionType(forPropertyname: propertyName)
    }
}
