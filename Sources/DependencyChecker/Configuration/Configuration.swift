import Foundation

public actor Configuration {
    public static let shared = Configuration()

    private init() {}

    private(set) var gitHubToken: String?

    public func configure(
        gitHubToken: String?
    ) {
        self.gitHubToken = gitHubToken
    }
}
