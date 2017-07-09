//===----------------------------------------------------------------------===//
//
// DeviceDocument.swift
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

public struct DeviceDocument: Codable {
    
    enum CodingKeys: String, CodingKey {
        case osVersion
        case connected
        case simulator
        case modelCode
        case deviceType
        case modelName
        case revision
        case modelUTI
        case name
        case trusted
        case docType = "doc_type"
        case supported
        case identifier
        case enabledForDevelopment
        case platformIdentifier
        case ID
        case architecture
        case retina
        case isServer
        case tinyID
        case activeProxiedDevice
    }
    
    public var osVersion: String?
    public var connected: Bool?
    public var simulator: Bool?
    public var modelCode: String?
    public var deviceType: String?
    public var modelName: String?
    public var revision: String?
    public var modelUTI: String?
    public var name: String?
    public var trusted: Bool?
    public var docType: String = "device"
    public var supported: Bool?
    public var identifier: String?
    public var enabledForDevelopment: Bool?
    public var platformIdentifier: String?
    public var ID: String?
    public var architecture: String?
    public var retina: Bool?
    public var isServer: Bool?
    public var tinyID: String?
    public var activeProxiedDevice: ProxiedDeviceDocument?
}
