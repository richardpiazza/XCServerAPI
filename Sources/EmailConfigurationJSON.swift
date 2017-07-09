//===----------------------------------------------------------------------===//
//
// EmailConfigurationJSON.swift
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

public struct EmailConfiguration: Codable {
    public var ccAddresses: [String]?
    public var allowedDomainNames: [String]?
    public var includeCommitMessages: Bool?
    public var includeLogs: Bool?
    public var replyToAddress: String?
    public var includeIssueDetails: Bool?
    public var includeBotConfiguration: Bool?
    public var additionalRecipients: [String]?
    public var scmOptions: [String : Int]?
    public var emailCommitters: Bool?
    public var fromAddress: String?
    public var type: EmailType?
    public var includeResolvedIssues: Bool?
    public var weeklyScheduleDay: Int?
    public var minutesAfterHour: Int?
    public var hour: Int?
}

public class EmailConfigurationJSON: SerializableObject {
    public var emailCommitters: Bool = false
    public var additionalRecipients: [String] = [String]()
    public var includeCommitMessages: Bool = false
    public var includeIssueDetails: Bool = false
}
