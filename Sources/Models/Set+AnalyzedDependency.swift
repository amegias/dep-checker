import Foundation

public extension Set<AnalyzedDependency> {
    func filter(
        includeDependencies: Set<String>,
        excludeDependencies: Set<String>
    ) -> Self {
        let lowerCaseIncludeDependencies = includeDependencies.map { $0.lowercased() }
        let lowerCaseExcludeDependencies = excludeDependencies.map { $0.lowercased() }

        return filter {
            (includeDependencies.isEmpty || lowerCaseIncludeDependencies.contains($0.name.lowercased()))
                && !lowerCaseExcludeDependencies.contains($0.name.lowercased())
        }
    }

    func merge(
        previousDependencies: Set<AnalyzedDependency>,
        includeTransitiveDependencies: Bool
    ) -> Self {
        if includeTransitiveDependencies {
            return union(previousDependencies)
        } else {
            let previousDependenciesUpdated = intersection(previousDependencies)
            var previousWithUpdates = previousDependencies
            previousDependenciesUpdated.forEach { previousWithUpdates.update(with: $0) }
            return previousWithUpdates
        }
    }
}
