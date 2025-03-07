import Foundation

public struct FileInput: Codable {
    let gitHubToken: String?
    let maxDays: Int?
    let maxDaysPerDependency: [String: Int]?

    public init(
        gitHubToken: String?,
        maxDays: Int?,
        maxDaysPerDependency: [String: Int]?
    ) {
        self.gitHubToken = gitHubToken
        self.maxDays = maxDays
        self.maxDaysPerDependency = maxDaysPerDependency
    }
}
