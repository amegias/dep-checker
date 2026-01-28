@testable import DependencyChecker
import Foundation
import Models
import Testing

struct RepositoryMatcherFactoryTests {
    @Test
    func matchesOnlyWithFirstMatcher() async throws {
        let repositoryMatchers: [RepositoryMatcher] = [
            NotMatchedRepositoryMatcherMock(),
            MatchedRepositoryMatcherMock(repository: RepositoryMock(id: "2")),
            NotMatchedRepositoryMatcherMock(),
            MatchedRepositoryMatcherMock(repository: RepositoryMock(id: "4"))
        ]

        let sut = RepositoryMatcherFactory(matchers: repositoryMatchers)

        let repository = try await sut.findRepository(.any(name: "any"))

        #expect((repository as? RepositoryMock)?.id == "2")
    }

    @Test
    func matchesWithNothing() async {
        let repositoryMatchers: [RepositoryMatcher] = [
            NotMatchedRepositoryMatcherMock(),
            NotMatchedRepositoryMatcherMock()
        ]
        let sut = RepositoryMatcherFactory(matchers: repositoryMatchers)

        await #expect(throws: RepositoryMatcherFactoryError.notHandled.self, performing: {
            try await sut.findRepository(.any(name: "any"))
        })
    }
}

private struct MatchedRepositoryMatcherMock: RepositoryMatcher {
    let repository: Repository
    func match(_: AnalyzedDependency) throws(RepositoryMatcherError) -> Repository {
        repository
    }
}

private struct NotMatchedRepositoryMatcherMock: RepositoryMatcher {
    func match(_: AnalyzedDependency) throws(RepositoryMatcherError) -> Repository {
        throw .notMatch
    }
}

private struct RepositoryMock: Repository {
    let id: String

    func getCurrentVersionDate() async -> CustomResult<Date, Error> {
        .success(Date())
    }

    func getLatestVersion() async -> CustomResult<LatestVersion, any Error> {
        .success(LatestVersion(tag: "tag", date: Date()))
    }
}
