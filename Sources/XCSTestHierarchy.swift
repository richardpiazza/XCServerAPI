import Foundation

public typealias XCSTestModuleName = String
public typealias XCSTestClassName = String
public typealias XCSTestMethodName = String
public typealias XCSDeviceIdentifier = String
public typealias XCSDeviceResults = [XCSDeviceIdentifier : Int]
public typealias XCSMethodResults = [XCSTestMethodName : XCSDeviceResults]
public typealias XCSClassHierarchy = [XCSTestClassName : XCSTestResults]
public typealias XCSTestHierarchy = [XCSTestModuleName : XCSClassHierarchy]

public enum XCSTestResults: Codable {
    case method(methodResults: XCSMethodResults)
    case device(deviceResults: XCSDeviceResults)
    
    enum Errors: Error {
        case mismatchType
    }
    
    var methodResults: XCSMethodResults? {
        switch self {
        case .method(let methodResults):
            return methodResults
        default:
            return nil
        }
    }
    
    var deviceResults: XCSDeviceResults? {
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
            let data = try container.decode(XCSMethodResults.self)
            self = XCSTestResults.method(methodResults: data)
            return
        } catch {
        }
        
        do {
            let container = try decoder.singleValueContainer()
            let data = try container.decode(XCSDeviceResults.self)
            self = XCSTestResults.device(deviceResults: data)
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

public struct XCSTests {
    public var modules: [XCSTestModule] = []
    public var pass: Bool {
        return modules.contains { (m) -> Bool in
            return m.pass == true
        }
    }
    
    internal init(testHierarchy: XCSTestHierarchy) {
        for moduleKey in testHierarchy.keys.sorted() {
            if let m = testHierarchy[moduleKey] {
                modules.append(XCSTestModule(name: moduleKey, classHierarchy: m))
            }
        }
    }
}

public struct XCSTestModule {
    public var name: String = "Module"
    public var classes: [XCSTestClass] = []
    public var aggregateResults: XCSDeviceResults?
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
    
    internal init(name: String, classHierarchy: XCSClassHierarchy) {
        self.name = name
        for classKey in classHierarchy.keys.sorted() {
            if classKey == "_xcsAggrDeviceStatus" {
                if let results = classHierarchy[classKey]?.deviceResults {
                    aggregateResults = results
                }
            } else {
                if let results = classHierarchy[classKey]?.methodResults {
                    classes.append(XCSTestClass(name: classKey, methodResults: results))
                }
            }
        }
    }
}

public struct XCSTestClass {
    public var name: String = "Class"
    public var methods: [XCSTestMethod] = []
    public var aggregateResults: XCSDeviceResults?
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
    
    internal init(name: String, methodResults: XCSMethodResults) {
        self.name = name
        for methodKey in methodResults.keys.sorted() {
            if methodKey == "_xcsAggrDeviceStatus" {
                if let results = methodResults[methodKey] {
                    aggregateResults = results
                }
            } else {
                if let results = methodResults[methodKey] {
                    methods.append(XCSTestMethod(name: methodKey, deviceResults: results))
                }
            }
        }
    }
}

public struct XCSTestMethod {
    public var name: String = "Method"
    public var results: XCSDeviceResults?
    public var pass: Bool {
        guard let results = self.results else {
            return false
        }
        
        let hasFailure = results.contains { (key, value) -> Bool in
            return value != 1
        }
        
        return !hasFailure
    }
    
    internal init(name: String, deviceResults: XCSDeviceResults) {
        self.name = name
        self.results = deviceResults
    }
}

public extension XCSIntegration {
    var tests: XCSTests? {
        guard let testHierarchy = self.testHierarchy else {
            return nil
        }
        
        return XCSTests(testHierarchy: testHierarchy)
    }
}
