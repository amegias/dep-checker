@testable import DependencyChecker
import Foundation
import Testing
import TestUtils

struct BitbucketRepositoryMatcherTests {
    @Test(arguments: [
        "https://bitbucket.org/owner/repo.git",
        "https://bitbucket.org/owner/repo"
    ])
    func bitbucketDependenciesReturnsBitbucketRepository(dependencyUrl: String) throws {
        let sut = BitbucketRepositoryMatcher()

        _ = try sut.match(.any(url: dependencyUrl))
    }

    @Test(arguments: [
        "https://whatever.com/owner/repo.git",
        "https://docs.bitbucket.org/en/rest/git/tags"
    ])
    func unknownDependenciesThrowsNotFound(dependencyUrl: String) throws {
        let sut = BitbucketRepositoryMatcher()

        #expect(throws: RepositoryMatcherError.notMatch.self, performing: {
            try sut.match(.any(url: dependencyUrl))
        })
    }
}
