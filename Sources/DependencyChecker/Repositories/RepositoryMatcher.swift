import Foundation
import Models

public enum RepositoryMatcherError: Error {
    case notMatch
}

public protocol RepositoryMatcher: Sendable {
    func match(_ dependency: AnalyzedDependency) async throws(RepositoryMatcherError) -> any Repository
}
