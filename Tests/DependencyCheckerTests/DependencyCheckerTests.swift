@testable import DependencyChecker
import Foundation
@testable import Models
import Testing

struct DependencyCheckerTests {}

extension DependencyCheckerTests {
    @Test
    func gotInfoInParallel_check_returnsDataWhenAllCompleted() async throws {
        let dependencyA: AnalyzedDependency = .any(name: "A")
        let expectedDependencyA = CheckedDependency(
            from: dependencyA,
            currentVersionDate: .success(Date(timeIntervalSince1970: 600_000_000)),
            latestVersion: .failure(RepositoryMatcherFactoryError.notFound),
            maxDays: nil
        )
        let repositoryMockA = RepositoryMock(
            currentVersionDate: expectedDependencyA.currentVersionDate,
            currentVersionDateDelay: 0.070,
            latestVersion: expectedDependencyA.latestVersion,
            latestVersionDelay: 0.030
        )

        let dependencyB: AnalyzedDependency = .any(name: "B")
        let expectedDependencyB = CheckedDependency(
            from: dependencyB,
            currentVersionDate: .failure(RepositoryMatcherFactoryError.notFound),
            latestVersion: .failure(RepositoryMatcherFactoryError.notFound),
            maxDays: nil
        )
        // No repository related

        let dependencyC: AnalyzedDependency = .any(name: "C")
        let expectedDependencyC = CheckedDependency(
            from: dependencyC,
            currentVersionDate: .failure(NSError.any()),
            latestVersion: .success(.any(date: Date(timeIntervalSince1970: 50_000_000))),
            maxDays: nil
        )
        let repositoryMockC = RepositoryMock(
            currentVersionDate: expectedDependencyC.currentVersionDate,
            currentVersionDateDelay: 0.040,
            latestVersion: expectedDependencyC.latestVersion,
            latestVersionDelay: 0.010
        )

        let dependencyD: AnalyzedDependency = .any(name: "D")
        let expectedDependencyD = CheckedDependency(
            from: dependencyD,
            currentVersionDate: .success(Date(timeIntervalSince1970: 700_000_000)),
            latestVersion: .success(.any(date: Date(timeIntervalSince1970: 50_000_000))),
            maxDays: nil
        )
        let repositoryMockD = RepositoryMock(
            currentVersionDate: expectedDependencyD.currentVersionDate,
            currentVersionDateDelay: 0.050,
            latestVersion: expectedDependencyD.latestVersion,
            latestVersionDelay: 0.010
        )

        let repositoryMatcherFactory = RepositoryMatcherFactoryMock(repositoryByDependency: [
            dependencyA.name: repositoryMockA,
            dependencyC.name: repositoryMockC,
            dependencyD.name: repositoryMockD
        ])
        let sut = DependencyChecker(repositoryMatcherFactory: repositoryMatcherFactory)

        let checkedDependencies = await sut.check(
            [
                dependencyA,
                dependencyB,
                dependencyC,
                dependencyD
            ],
            maxDays: 30,
            maxDaysPerDependency: [dependencyD.name: 10]
        )

        #expect(checkedDependencies.count == 4)
        expect(checkedDependencies[0], equalTo: expectedDependencyB)
        expect(checkedDependencies[1], equalTo: expectedDependencyC)
        expect(checkedDependencies[2], equalTo: expectedDependencyD)
        expect(checkedDependencies[3], equalTo: expectedDependencyA)
    }
}

private extension DependencyCheckerTests {
    func expect(_ checkedDependency: CheckedDependency, equalTo expected: CheckedDependency) {
        #expect(checkedDependency.name == expected.name)
        #expect(checkedDependency.outdated == expected.outdated)

        switch (checkedDependency.currentVersionDate, expected.currentVersionDate) {
        case (.failure, .failure):
            break
        case (.success(let date), .success(let expectedDate)):
            #expect(date == expectedDate)
        default:
            #expect(Bool(false))
        }

        switch (checkedDependency.latestVersion, expected.latestVersion) {
        case (.failure, .failure):
            break
        case (.success(let latestVersion), .success(let expectedLatestVersion)):
            #expect(latestVersion.tag == expectedLatestVersion.tag)
            #expect(latestVersion.date == expectedLatestVersion.date)
        default:
            #expect(Bool(false))
        }
    }
}

private struct RepositoryMatcherFactoryMock: RepositoryMatcherFactoryProtocol {
    let repositoryByDependency: [String: Repository]
    func findRepository(_ dependency: AnalyzedDependency) throws(RepositoryMatcherFactoryError) -> any Repository {
        guard let repository = repositoryByDependency[dependency.name] else { throw .notFound }
        return repository
    }
}

private struct RepositoryMock: Repository {
    let currentVersionDate: CustomResult<Date, any Error>
    let currentVersionDateDelay: TimeInterval
    func getCurrentVersionDate() async -> CustomResult<Date, any Error> {
        try! await Task.sleep(for: .seconds(currentVersionDateDelay))
        return currentVersionDate
    }

    let latestVersion: CustomResult<LatestVersion, any Error>
    let latestVersionDelay: TimeInterval
    func getLatestVersion() async -> CustomResult<LatestVersion, any Error> {
        try! await Task.sleep(for: .seconds(latestVersionDelay))
        return latestVersion
    }
}
