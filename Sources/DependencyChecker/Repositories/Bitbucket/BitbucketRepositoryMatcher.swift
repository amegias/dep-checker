import Foundation
import Models
import OSLog

struct BitbucketRepositoryMatcher {}

extension BitbucketRepositoryMatcher: RepositoryMatcher {
    func match(_ dependency: AnalyzedDependency) throws(RepositoryMatcherError) -> any Repository {
        if dependency.url.host() == "bitbucket.org",
           dependency.url.pathComponents.count == 3
        {
            return
                BitbucketRepository(
                    owner: dependency.url.pathComponents[1],
                    repository: dependency.url.pathComponents[2].replacing(".git", with: ""),
                    dependency: dependency
                )
        } else {
            throw .notMatch
        }
    }
}
