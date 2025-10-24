import Foundation
import Models

enum RepositoryMatcherFactoryError: Error, LocalizedError {
    case notHandled

    var errorDescription: String? {
        switch self {
        case .notHandled:
            "Unhandled repository. Cannot check this dependency"
        }
    }
}

protocol RepositoryMatcherFactoryProtocol: Sendable {
    func findRepository(_ dependency: AnalyzedDependency) async throws(RepositoryMatcherFactoryError) -> Repository
}

struct RepositoryMatcherFactory {
    let matchers: [RepositoryMatcher]
}

extension RepositoryMatcherFactory: RepositoryMatcherFactoryProtocol {
    func findRepository(_ dependency: AnalyzedDependency) async throws(RepositoryMatcherFactoryError)
        -> any Repository
    {
        for repositoryMatcher in matchers {
            do {
                return try await repositoryMatcher.match(dependency)
            } catch {
                continue
            }
        }

        throw RepositoryMatcherFactoryError.notHandled
    }
}
