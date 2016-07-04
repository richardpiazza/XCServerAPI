//===----------------------------------------------------------------------===//
//
// ConfigurationJSON.swift
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

class ConfigurationJSON: SerializableObject {
    var schemeName: String!
    var builtFromClean: Int = 0
    var performsTestAction: Bool = false
    var performsAnalyzeAction: Bool = false
    var performsArchiveAction: Bool = false
    var testingDestinationType: Int = 0
    var testingDeviceIDs: [String] = [String]()
    var scheduleType: Int = 0
    var periodicScheduleInterval: Int = 0
    var weeklyScheduleDay: Int = 0
    var hourOfIntegration: Int = 0
    var minutesAfterHourToIntegrate: Int = 0
    var triggers: [TriggerJSON] = [TriggerJSON]()
    var sourceControlBlueprint: RevisionBlueprintJSON?
    var codeCoveragePreference: NSNumber?
    var deviceSpecification: DeviceSpecificationJSON?
    
    override func objectClassOfCollectionType(forPropertyname propertyName: String) -> AnyClass? {
        if propertyName == "triggers" {
            return TriggerJSON.self
        }
        
        return super.objectClassOfCollectionType(forPropertyname: propertyName)
    }
}
