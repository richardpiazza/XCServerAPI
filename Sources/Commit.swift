//===----------------------------------------------------------------------===//
//
// Commit.swift
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

public struct Commit: Codable {
    
    enum CodingKeys: String, CodingKey {
        case repositoryID = "XCSBlueprintRepositoryID"
        case commitChangeFilePaths = "XCSCommitCommitChangeFilePaths"
        case contributor = "XCSCommitContributor"
        case hash = "XCSCommitHash"
        case message = "XCSCommitMessage"
        case isMerge = "XCSCommitIsMerge"
        case timestamp = "XCSCommitTimestamp"
        case timestampDate = "XCSCommitTimestampDate"
    }
    
    public var repositoryID: String?
    public var commitChangeFilePaths: [CommitChangeFilePath]?
    public var contributor: CommitContributor?
    public var hash: String?
    public var message: String?
    public var isMerge: String?
    public var timestamp: Date?
    public var timestampDate: [Int]?
}
