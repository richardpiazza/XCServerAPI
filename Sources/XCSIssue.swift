import Foundation

public struct XCSIssue: Codable {
    public var _id: String
    public var _rev: String
    public var message: String?
    public var type: String?
    public var fixItType: String?
    public var issueType: String?
    public var commits: [XCSRepositoryCommit]?
    public var integrationID: String?
    public var age: Int?
    public var status: Int?
    public var issueAuthors: [XCSIssueAuthor]?
}
