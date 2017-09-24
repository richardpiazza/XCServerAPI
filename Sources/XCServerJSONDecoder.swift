import Foundation

public class XCServerJSONDecoder: JSONDecoder {
    
    public static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }
    
    public static var `default` = XCServerJSONDecoder()
    
    public override init() {
        super.init()
        self.dateDecodingStrategy = .formatted(type(of: self).dateFormatter)
    }
}
