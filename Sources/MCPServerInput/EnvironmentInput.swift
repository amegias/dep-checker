import Foundation

public struct EnvironmentInput {
    let gitHubToken: String?

    public init(
        gitHubToken: String?
    ) {
        if let sanitized = gitHubToken?.trimmingCharacters(in: .whitespacesAndNewlines),
           !sanitized.isEmpty
        {
            self.gitHubToken = sanitized
        } else {
            self.gitHubToken = nil
        }
    }
}
