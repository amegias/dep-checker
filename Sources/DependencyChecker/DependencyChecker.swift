import Foundation
import Models

public struct DependencyChecker {
    private let repositoryMatcherFactory: RepositoryMatcherFactoryProtocol

    public init(matchers: [RepositoryMatcher]) {
        repositoryMatcherFactory = RepositoryMatcherFactory(matchers: matchers)
    }

    init(repositoryMatcherFactory: RepositoryMatcherFactoryProtocol) {
        self.repositoryMatcherFactory = repositoryMatcherFactory
    }
}

public extension DependencyChecker {
    func check(
        _ dependencies: Set<AnalyzedDependency>,
        maxDays: Int? = nil,
        maxDaysPerDependency: [String: Int] = [:]
    ) async -> [CheckedDependency] {
        await withTaskGroup(of: CheckedDependency.self) { group in
            for dependency in dependencies {
                let repositoryMatcherFactory = repositoryMatcherFactory
                let normalizedMaxDays = maxDaysPerDependency[dependency.name] ?? maxDays
                group.addTask {
                    do {
                        let repository = try await repositoryMatcherFactory.findRepository(dependency)
                        async let currentVersionDateTask = repository.getCurrentVersionDate()
                        async let latestVersionTask = repository.getLatestVersion()

                        let currentVersionDate = await currentVersionDateTask
                        let latestVersion = await latestVersionTask

                        return CheckedDependency(
                            from: dependency,
                            currentVersionDate: currentVersionDate,
                            latestVersion: latestVersion,
                            maxDays: normalizedMaxDays
                        )
                    } catch {
                        return CheckedDependency(
                            from: dependency,
                            currentVersionDate: .failure(error),
                            latestVersion: .failure(error),
                            maxDays: normalizedMaxDays
                        )
                    }
                }
            }

            var result: [CheckedDependency] = []
            for await value in group {
                result.append(value)
            }
            return result
        }
    }
}
