import Foundation
import Models
import OSLog

public struct GitHubRepositoryMatcher {
    private let gitHubToken: String

    public init(gitHubToken: String) {
        self.gitHubToken = gitHubToken
    }
}

extension GitHubRepositoryMatcher: RepositoryMatcher {
    public func match(_ dependency: AnalyzedDependency) async throws(RepositoryMatcherError) -> any Repository {
        if dependency.url.host() == "github.com",
           dependency.url.pathComponents.count == 3
        {
            return
                GitHubRepository(
                    gitHubToken: gitHubToken,
                    owner: dependency.url.pathComponents[1],
                    repository: dependency.url.pathComponents[2].replacing(".git", with: ""),
                    dependency: dependency
                )
        } else {
            throw .notMatch
        }
    }
}
