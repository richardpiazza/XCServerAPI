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

open class IntegrationJSON: SerializableObject {
    open var _id: String = ""
    open var _rev: String?
    open var doc_type: String?
    open var tinyID: String?
    open var number: Int = 0
    open var shouldClean: Bool = false
    open var currentStep: String?
    open var result: String?
    open var buildResultSummary: BuildResultSummaryJSON?
    open var queuedDate: String?
    open var startedTime: String?
    open var endedTime: String?
    open var endedTimeDate: [Int] = [Int]()
    open var duration: Float = 0
    open var success_streak: Int = 0
    open var tags: [String] = [String]()
    open var buildServiceFingerprint: String?
    open var testedDevices: [DeviceJSON] = [DeviceJSON]()
    open var testHierarchy: [String : AnyObject]?
    open var perfMetricNames: [String] = [String]()
    open var perfMetricKeyPaths: [String] = [String]()
    open var assets: IntegrationAssetsJSON?
    open var revisionBlueprint: RevisionBlueprintJSON?
    open var hasCoverageData: Bool?
    
    override open func propertyName(forSerializedKey serializedKey: String) -> String? {
        if serializedKey == "lastRevisionBlueprint" {
            return "revisionBlueprint"
        }
        
        return super.propertyName(forSerializedKey: serializedKey)
    }
    
    override open func objectClassOfCollectionType(forPropertyname propertyName: String) -> AnyClass? {
        if propertyName == "testedDevices" {
            return DeviceJSON.self
        }
        
        return super.objectClassOfCollectionType(forPropertyname: propertyName)
    }
}
