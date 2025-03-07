import Foundation
import Models
import OSLog

struct GitHubRepositoryMatcher {}

extension GitHubRepositoryMatcher: RepositoryMatcher {
    func match(_ dependency: AnalyzedDependency) async throws(RepositoryMatcherError) -> any Repository {
        if dependency.url.host() == "github.com",
           dependency.url.pathComponents.count == 3
        {
            return
                GitHubRepository(
                    owner: dependency.url.pathComponents[1],
                    repository: dependency.url.pathComponents[2].replacing(".git", with: ""),
                    dependency: dependency
                )
        } else {
            throw .notMatch
        }
    }
}
