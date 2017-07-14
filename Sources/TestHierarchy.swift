//===----------------------------------------------------------------------===//
//
// TestHierarchy.swift
//
// Copyright (c) 2017 Richard Piazza
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

public typealias TestModuleName = String
public typealias TestClassName = String
public typealias TestMethodName = String
public typealias DeviceIdentifier = String
public typealias DeviceResults = [DeviceIdentifier : Int]
public typealias MethodResults = [TestMethodName : DeviceResults]
public typealias ClassHierarchy = [TestClassName : Results]
public typealias TestHierarchy = [TestModuleName : ClassHierarchy]

public enum Results: Codable {
    case method(methodResults: MethodResults)
    case device(deviceResults: DeviceResults)
    
    enum Errors: Error {
        case mismatchType
    }
    
    var methodResults: MethodResults? {
        switch self {
        case .method(let methodResults):
            return methodResults
        default:
            return nil
        }
    }
    
    var deviceResults: DeviceResults? {
        switch self {
        case .device(let deviceResults):
            return deviceResults
        default:
            return nil
        }
    }
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            let data = try container.decode(MethodResults.self)
            self = Results.method(methodResults: data)
            return
        } catch {
        }
        
        do {
            let container = try decoder.singleValueContainer()
            let data = try container.decode(DeviceResults.self)
            self = Results.device(deviceResults: data)
            return
        } catch {
        }
        
        throw Errors.mismatchType
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .device(let deviceResults):
            try container.encode(deviceResults)
        case .method(let methodResults):
            try container.encode(methodResults)
        }
    }
}

public struct Tests {
    public var modules: [Module] = []
    public var pass: Bool {
        return modules.contains { (m) -> Bool in
            return m.pass == true
        }
    }
    
    internal init(testHierarchy: TestHierarchy) {
        for moduleKey in testHierarchy.keys.sorted() {
            if let m = testHierarchy[moduleKey] {
                modules.append(Module(name: moduleKey, classHierarchy: m))
            }
        }
    }
}

public struct Module {
    public var name: String = "Module"
    public var classes: [Class] = []
    public var aggregateResults: DeviceResults?
    public var pass: Bool {
        guard let results = aggregateResults else {
            return classes.contains(where: { (c) -> Bool in
                return c.pass == true
            })
        }
        
        let hasFailure = results.contains { (key, value) -> Bool in
            return value != 1
        }
        
        return !hasFailure
    }
    
    internal init(name: String, classHierarchy: ClassHierarchy) {
        self.name = name
        for classKey in classHierarchy.keys.sorted() {
            if classKey == "_xcsAggrDeviceStatus" {
                if let results = classHierarchy[classKey]?.deviceResults {
                    aggregateResults = results
                }
            } else {
                if let results = classHierarchy[classKey]?.methodResults {
                    classes.append(Class(name: classKey, methodResults: results))
                }
            }
        }
    }
}

public struct Class {
    public var name: String = "Class"
    public var methods: [Method] = []
    public var aggregateResults: DeviceResults?
    public var pass: Bool {
        guard let results = aggregateResults else {
            return methods.contains(where: { (m) -> Bool in
                return m.pass == true
            })
        }
        
        let hasFailure = results.contains { (key, value) -> Bool in
            return value != 1
        }
        
        return !hasFailure
    }
    
    internal init(name: String, methodResults: MethodResults) {
        self.name = name
        for methodKey in methodResults.keys.sorted() {
            if methodKey == "_xcsAggrDeviceStatus" {
                if let results = methodResults[methodKey] {
                    aggregateResults = results
                }
            } else {
                if let results = methodResults[methodKey] {
                    methods.append(Method(name: methodKey, deviceResults: results))
                }
            }
        }
    }
}

public struct Method {
    public var name: String = "Method"
    public var results: DeviceResults?
    public var pass: Bool {
        guard let results = self.results else {
            return false
        }
        
        let hasFailure = results.contains { (key, value) -> Bool in
            return value != 1
        }
        
        return !hasFailure
    }
    
    internal init(name: String, deviceResults: DeviceResults) {
        self.name = name
        self.results = deviceResults
    }
}

public extension IntegrationDocument {
    var tests: Tests? {
        guard let testHierarchy = self.testHierarchy else {
            return nil
        }
        
        return Tests(testHierarchy: testHierarchy)
    }
}
