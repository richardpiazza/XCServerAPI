//===----------------------------------------------------------------------===//
//
// IntegrationDocument.swift
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

public struct IntegrationDocument: Codable {
    
    enum CodingKeys: String, CodingKey {
        case _id
        case _rev
        case number
        case currentStep
        case result
        case queuedDate
        case successStreak = "success_streak"
        case shouldClean
        case assets
        case docType = "doc_type"
        case tinyID
        case buildServiceFingerprint
        case tags
        case startedTime
        case buildResultSummary
        case endedTime
        case endedTimeDate
        case duration
        case ccPercentage
        case ccPercentageDelta
        case perfMetricNames
        case perfMetricKeyPaths
        case bot
        case revisionBlueprint
        case testedDevices
        case testHierarchy
    }
    
    public var _id: String
    public var _rev: String
    public var number: Int
    public var currentStep: IntegrationStep
    public var result: IntegrationResult
    public var queuedDate: Date?
    public var successStreak: Int?
    public var shouldClean: Bool?
    public var assets: Assets?
    public var docType: String = "integration"
    public var tinyID: String?
    public var buildServiceFingerprint: String?
    public var tags: [String]?
    public var startedTime: Date?
    public var buildResultSummary: BuildResultSummary?
    public var endedTime: Date?
    public var endedTimeDate: [Int]?
    public var duration: Double?
    public var ccPercentage: Int?
    public var ccPercentageDelta: Int?
    public var perfMetricNames: [String]?
    public var perfMetricKeyPaths: [String]?
    public var bot: BotDocument?
    public var revisionBlueprint: RepositoryBlueprint?
    public var testedDevices: [DeviceDocument]?
    public var testHierarchy: TestHierarchy?
}
