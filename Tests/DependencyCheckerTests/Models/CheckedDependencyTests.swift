@testable import DependencyChecker
import Foundation
@testable import Models
import Testing

struct CheckedDependencyTests {}

// MARK: - Outdated property

extension CheckedDependencyTests {
    typealias DaysOutdatedScenario = (CustomResult<Date, Error>, CustomResult<LatestVersion, Error>, Int?, Bool?)
    @Test(arguments: [
        (
            .success(Date(timeIntervalSince1970: 86_400)),
            .success(.any(date: Date(timeIntervalSince1970: 86_400 * 5))),
            4,
            true
        ),
        (
            .success(Date(timeIntervalSince1970: 86_400)),
            .success(.any(date: Date(timeIntervalSince1970: 86_400 * 4))),
            3,
            false
        ),
        (
            .success(Date(timeIntervalSince1970: 86_400)),
            .success(.any(date: Date(timeIntervalSince1970: 86_400 * 3))),
            2,
            false
        ),
        (.success(Date(timeIntervalSince1970: 86_400)), .success(.any(date: Date(timeIntervalSince1970: 0))), 0, false),
        (.failure(NSError.any()), .success(.any(date: Date(timeIntervalSince1970: 86_400 * 5))), nil, nil),
        (.success(Date(timeIntervalSince1970: 86_400)), .failure(NSError.any()), nil, nil)
    ] as [DaysOutdatedScenario])
    func daysOutdatedWithMaxDefined(scenario: DaysOutdatedScenario) {
        let (currentVersionDate, latestVersion, expectedDays, expectedOutdated) = scenario
        let sut = CheckedDependency(
            from: .any(name: "any"),
            currentVersionDate: currentVersionDate,
            latestVersion: latestVersion,
            maxDays: 3
        )

        #expect(sut.outdated?.daysOutdated == expectedDays)
        #expect(sut.outdated?.isOutdated == expectedOutdated)
    }

    @Test
    func daysOutdatedWithNoMaxDefined() {
        let sut = CheckedDependency(
            from: .any(name: "any"),
            currentVersionDate: .success(Date(timeIntervalSince1970: 86_400)),
            latestVersion: .success(.any(date: Date(timeIntervalSince1970: 86_400 * 5))),
            maxDays: nil
        )

        #expect(sut.outdated?.daysOutdated == 4)
        #expect(sut.outdated?.isOutdated == false)
    }
}

// MARK: - Comparable

extension CheckedDependencyTests {
    @Test
    func sort() async throws {
        let dependencies: [CheckedDependency] = [
            CheckedDependency(
                from: .any(name: "1"),
                currentVersionDate: .success(Date(timeIntervalSince1970: 1_000)),
                latestVersion: .success(.any(date: Date(timeIntervalSince1970: 2_000))),
                maxDays: nil
            ),
            CheckedDependency(
                from: .any(name: "2"),
                currentVersionDate: .success(Date(timeIntervalSince1970: 500)),
                latestVersion: .failure(NSError()),
                maxDays: nil
            ),
            CheckedDependency(
                from: .any(name: "3"),
                currentVersionDate: .success(Date(timeIntervalSince1970: 500)),
                latestVersion: .success(.any(date: Date(timeIntervalSince1970: 3_000))),
                maxDays: nil
            ),
            CheckedDependency(
                from: .any(name: "4"),
                currentVersionDate: .failure(NSError()),
                latestVersion: .success(.any(date: Date(timeIntervalSince1970: 2_000))),
                maxDays: nil
            )
        ]

        #expect(dependencies.sorted().map(\.name) == ["2", "4", "1", "3"])
    }
}
