import OSLog

extension Logger {
    private static let subsystem = "DependencyChecker"

    static let gitHubClient = Logger(subsystem: subsystem, category: "GitHubClient")
    static let gitHubRepository = Logger(subsystem: subsystem, category: "GitHubRepository")

    static let bitbucketClient = Logger(subsystem: subsystem, category: "BitbucketClient")
    static let bitbucketRepository = Logger(subsystem: subsystem, category: "BitbucketRepository")
}
