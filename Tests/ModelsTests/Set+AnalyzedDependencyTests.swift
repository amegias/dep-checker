import Foundation
@testable import Models
import Testing
import TestUtils

struct Set_AnalyzedDependencyTests {}

// MARK: - filter

extension Set_AnalyzedDependencyTests {
    @Test
    func noFilters_filter_returnsAllValues() {
        let dependencies: Set<AnalyzedDependency> = [
            .any(name: "name1"),
            .any(name: "name2")
        ]
        let filtered = dependencies.filter(
            includeDependencies: [],
            excludeDependencies: []
        )

        #expect(filtered == dependencies)
    }

    @Test
    func includedFiltersNotMatch_filter_returnsNothing() {
        let dependencies: Set<AnalyzedDependency> = [
            .any(name: "name1"),
            .any(name: "name2")
        ]
        let filtered = dependencies.filter(
            includeDependencies: ["name"],
            excludeDependencies: []
        )

        #expect(filtered == [])
    }

    @Test
    func includedFiltersMatch_filter_returnsMatchedOne() {
        let dependencies: Set<AnalyzedDependency> = [
            .any(name: "name1"),
            .any(name: "name2")
        ]
        let filtered = dependencies.filter(
            includeDependencies: ["Name1"],
            excludeDependencies: []
        )

        #expect(filtered == [.any(name: "name1")])
    }

    @Test
    func excludedFiltersNotMatch_filter_returnsAllValues() {
        let dependencies: Set<AnalyzedDependency> = [
            .any(name: "name1"),
            .any(name: "name2")
        ]
        let filtered = dependencies.filter(
            includeDependencies: [],
            excludeDependencies: ["Other"]
        )

        #expect(filtered == dependencies)
    }

    @Test
    func excludedFiltersMatch_filter_returnsNotMatched() {
        let dependencies: Set<AnalyzedDependency> = [
            .any(name: "name1"),
            .any(name: "name2")
        ]
        let filtered = dependencies.filter(
            includeDependencies: [],
            excludeDependencies: ["Name1"]
        )

        #expect(filtered == [.any(name: "name2")])
    }
}

// MARK: - merge

extension Set_AnalyzedDependencyTests {
    @Test
    func noTransitiveDependencies_merge_returnsPreviousDependenciesUpdatedWithCurrentOnes() {
        let previousDependencies: Set<AnalyzedDependency> = [
            .any(name: "name1", pointingTo: .commit(hash: "123")),
            .any(name: "name2", pointingTo: .version(version: "2.0")),
            .any(name: "name3", pointingTo: .nonExact("upperV3")),
            .any(name: "name4", pointingTo: .version(version: "4.0"))
        ]
        let dependencies: Set<AnalyzedDependency> = [
            .any(name: "name1", pointingTo: .version(version: "1.0")),
            .any(name: "name2.5", pointingTo: .version(version: "2.5")),
            .any(name: "name3", pointingTo: .version(version: "3.0"))
        ]
        let filtered = dependencies.merge(
            previousDependencies: previousDependencies,
            includeTransitiveDependencies: false
        )

        #expect(filtered == [
            .any(name: "name1", pointingTo: .version(version: "1.0")),
            .any(name: "name2", pointingTo: .version(version: "2.0")),
            .any(name: "name3", pointingTo: .version(version: "3.0")),
            .any(name: "name4", pointingTo: .version(version: "4.0"))
        ])
    }

    @Test
    func transitiveDependencies_merge_returnsPreviousDependenciesUpdatedWithCurrentOnes() {
        let previousDependencies: Set<AnalyzedDependency> = [
            .any(name: "name1", pointingTo: .commit(hash: "123")),
            .any(name: "name2", pointingTo: .version(version: "2.0")),
            .any(name: "name3", pointingTo: .nonExact("upperV3")),
            .any(name: "name4", pointingTo: .version(version: "4.0"))
        ]
        let dependencies: Set<AnalyzedDependency> = [
            .any(name: "name1", pointingTo: .version(version: "1.0")),
            .any(name: "name2.5", pointingTo: .version(version: "2.5")),
            .any(name: "name3", pointingTo: .version(version: "3.0"))
        ]
        let filtered = dependencies.merge(
            previousDependencies: previousDependencies,
            includeTransitiveDependencies: true
        )

        #expect(filtered == [
            .any(name: "name1", pointingTo: .version(version: "1.0")),
            .any(name: "name2", pointingTo: .version(version: "2.0")),
            .any(name: "name2.5", pointingTo: .version(version: "2.5")),
            .any(name: "name3", pointingTo: .version(version: "3.0")),
            .any(name: "name4", pointingTo: .version(version: "4.0"))
        ])
    }
}
