@testable import DependencyChecker
import Foundation
import Testing

struct GitHubRepositoryMatcherTests {
    @Test("GitHub dependencies", arguments: [
        "https://github.com/owner/repo.git",
        "https://github.com/owner/repo"
    ])
    func gitHubDependenciesReturnsGitHubRepository(dependencyUrl: String) async throws {
        let sut = GitHubRepositoryMatcher(gitHubToken: "any")

        _ = try await sut.match(.any(url: dependencyUrl))
    }

    @Test("Unknown dependencies", arguments: [
        "https://whatever.com/owner/repo.git",
        "https://docs.github.com/en/rest/git/tags"
    ])
    func unknownDependenciesThrowsNotFound(dependencyUrl: String) async {
        let sut = GitHubRepositoryMatcher(gitHubToken: "any")

        await #expect(throws: RepositoryMatcherError.notMatch.self, performing: {
            try await sut.match(.any(url: dependencyUrl))
        })
    }
}
