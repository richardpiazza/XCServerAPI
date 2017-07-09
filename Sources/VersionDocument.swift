//===----------------------------------------------------------------------===//
//
// VersionDocument.swift
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

public struct VersionDocument: Codable {
    
    enum CodingKeys: String, CodingKey {
        case _id
        case _rev
        case docType = "doc_type"
        case tinyID
        case os
        case xcode
        case xcodeServer
        case server
    }
    
    public var _id: String
    public var _rev: String
    public var docType: String
    public var tinyID: String
    /// macOS version (i.e. 10.12 (16A201w))
    public var os: String?
    /// Xcode version used for builds (i.e. 8.0 (8S128d))
    public var xcode: String?
    /// The Xcode Server API version (i.e. 2.0)
    public var xcodeServer: String?
    /// The Server.app version (i.e. 5.1.50 (16S1083q))
    public var server: String?
}
