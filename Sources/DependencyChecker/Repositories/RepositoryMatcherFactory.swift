import Foundation
import Models

enum RepositoryMatcherFactoryError: Error {
    case notFound
}

protocol RepositoryMatcherFactoryProtocol: Sendable {
    func findRepository(_ dependency: AnalyzedDependency) async throws(RepositoryMatcherFactoryError) -> Repository
}

struct RepositoryMatcherFactory {
    static let defaultMatchers: [RepositoryMatcher] = [
        GitHubRepositoryMatcher(),
        BitbucketRepositoryMatcher()
    ]

    private let matchers: [RepositoryMatcher]

    init(matchers: [RepositoryMatcher]) {
        self.matchers = matchers
    }

    public init() {
        matchers = Self.defaultMatchers
    }
}

extension RepositoryMatcherFactory: RepositoryMatcherFactoryProtocol {
    func findRepository(_ dependency: AnalyzedDependency) async throws(RepositoryMatcherFactoryError)
        -> any Repository
    {
        for repositoryMatcher in matchers {
            do {
                return try await repositoryMatcher.match(dependency)
            } catch {
                // continue
            }
        }

        throw RepositoryMatcherFactoryError.notFound
    }
}
