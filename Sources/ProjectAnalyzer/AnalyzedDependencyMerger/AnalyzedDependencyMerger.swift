import Foundation
import Models

protocol AnalyzedDependencyMergerProtocol {
    func merge(
        dependencies: Set<AnalyzedDependency>,
        resolvedDependencies: Set<AnalyzedDependency>,
        includeDependencies: Set<String>,
        excludeDependencies: Set<String>,
        includeTransitiveDependencies: Bool
    ) -> Set<AnalyzedDependency>
}

struct AnalyzedDependencyMerger {}

extension AnalyzedDependencyMerger: AnalyzedDependencyMergerProtocol {
    func merge(
        dependencies: Set<AnalyzedDependency>,
        resolvedDependencies: Set<AnalyzedDependency>,
        includeDependencies: Set<String>,
        excludeDependencies: Set<String>,
        includeTransitiveDependencies: Bool
    ) -> Set<AnalyzedDependency> {
        resolvedDependencies
            .merge(
                previousDependencies: dependencies,
                includeTransitiveDependencies: includeTransitiveDependencies
            )
            .filter(
                includeDependencies: includeDependencies,
                excludeDependencies: excludeDependencies
            )
    }
}
