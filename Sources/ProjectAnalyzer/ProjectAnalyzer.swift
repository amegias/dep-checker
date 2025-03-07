import Foundation
import Models
import OSLog

public enum ProjectAnalyzerError: Error {
    case projectNotFound
}

public struct ProjectAnalyzer {
    private let fileFinder: FileFinderProtocol
    private let swiftPackageAnalyzer: SwiftPackageAnalyzerProtocol
    private let xCodeAnalyzer: XCodeAnalyzerProtocol
    private let resolvedPackageAnalyzer: ResolvedPackageAnalyzerProtocol
    private let analyzedDependencyMerger: AnalyzedDependencyMergerProtocol

    init(
        fileFinder: FileFinderProtocol,
        swiftPackageAnalyzer: SwiftPackageAnalyzerProtocol,
        xCodeAnalyzer: XCodeAnalyzerProtocol,
        resolvedPackageAnalyzer: ResolvedPackageAnalyzerProtocol,
        analyzedDependencyMerger: AnalyzedDependencyMergerProtocol
    ) {
        self.fileFinder = fileFinder
        self.swiftPackageAnalyzer = swiftPackageAnalyzer
        self.xCodeAnalyzer = xCodeAnalyzer
        self.resolvedPackageAnalyzer = resolvedPackageAnalyzer
        self.analyzedDependencyMerger = analyzedDependencyMerger
    }

    public init() {
        fileFinder = FileFinder()
        swiftPackageAnalyzer = SwiftPackageAnalyzer()
        xCodeAnalyzer = XCodeAnalyzer()
        resolvedPackageAnalyzer = ResolvedPackageAnalyzer()
        analyzedDependencyMerger = AnalyzedDependencyMerger()
    }
}

public extension ProjectAnalyzer {
    func getDependencies(
        projectPath: URL,
        resolvedPackagePath: URL?,
        includeDependencies: Set<String>,
        excludeDependencies: Set<String>,
        includeTransitiveDependencies: Bool
    ) throws -> Set<AnalyzedDependency> {
        let dependencies: Set<AnalyzedDependency>
        if let package = try fileFinder.find(fileName: "Package.swift", in: projectPath) {
            Logger.projectAnalyzer.debug("Package.swift found: \(package)")
            dependencies = try swiftPackageAnalyzer
                .getDependencies(packageUrl: package)
        } else if let xcodeproj = try fileFinder.find(fileExtension: "xcodeproj", in: projectPath) {
            Logger.projectAnalyzer.debug(".xcodeproj found: \(xcodeproj)")
            dependencies = try xCodeAnalyzer
                .getDependencies(projectUrl: xcodeproj)
        } else {
            Logger.projectAnalyzer.debug("any project found...")
            throw ProjectAnalyzerError.projectNotFound
        }

        let resolvedDependencies = try getResolvedDependencies(in: resolvedPackagePath)

        return analyzedDependencyMerger.merge(
            dependencies: dependencies,
            resolvedDependencies: resolvedDependencies,
            includeDependencies: includeDependencies,
            excludeDependencies: excludeDependencies,
            includeTransitiveDependencies: includeTransitiveDependencies
        )
    }
}

private extension ProjectAnalyzer {
    func getResolvedDependencies(in resolvedPackagePath: URL?) throws -> Set<AnalyzedDependency> {
        guard let resolvedPackagePath,
              let file = try fileFinder.find(fileName: "Package.resolved", in: resolvedPackagePath) else { return [] }

        Logger.projectAnalyzer.debug("Package.resolved found: \(file)")
        return try resolvedPackageAnalyzer
            .getDependencies(resolvedFileUrl: file)
    }
}
