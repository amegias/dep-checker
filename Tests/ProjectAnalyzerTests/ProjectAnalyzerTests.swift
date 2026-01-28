import Foundation
import Models
@testable import ProjectAnalyzer
import Testing
import TestUtils

struct ProjectAnalyzerTests {}

extension ProjectAnalyzerTests {
    @Test
    func packageFileFound_getDependencies_returnsDependencies() throws {
        // given
        let fileFinderMock = FileFinderMock(
            resolvedPackageUrl: nil
        )
        let swiftPackageAnalyzerMock = SwiftPackageAnalyzerMock()
        let xCodeAnalyzerMock = XCodeAnalyzerMock()
        let resolvedPackageAnalyzerMock = ResolvedPackageAnalyzerMock()
        let analyzedDependencyMergerMock = AnalyzedDependencyMergerMock()
        let sut = ProjectAnalyzer(
            fileFinder: fileFinderMock,
            swiftPackageAnalyzer: swiftPackageAnalyzerMock,
            xCodeAnalyzer: xCodeAnalyzerMock,
            resolvedPackageAnalyzer: resolvedPackageAnalyzerMock,
            analyzedDependencyMerger: analyzedDependencyMergerMock
        )

        // when
        _ = try sut.getDependencies(
            projectPath: URL(fileURLWithPath: "/path/to/project"),
            resolvedPackagePath: nil,
            includeDependencies: ["included"],
            excludeDependencies: ["excluded"],
            includeTransitiveDependencies: true
        )

        // then
        #expect(analyzedDependencyMergerMock.dependencies == [
            .any(
                name: "dep1",
                pointingTo: .nonExact("upperToV1")
            ),
            .any(
                name: "dep2",
                pointingTo: .version(version: "2.0")
            ),
            .any(
                name: "dep3",
                pointingTo: .version(version: "3.0")
            )
        ])
        #expect(analyzedDependencyMergerMock.resolvedDependencies == [])
        #expect(analyzedDependencyMergerMock.includeDependencies == ["included"])
        #expect(analyzedDependencyMergerMock.excludeDependencies == ["excluded"])
        #expect(analyzedDependencyMergerMock.includeTransitiveDependencies == true)
    }

    @Test
    func packageFileFoundWithResolvedFile_getDependencies_returnsAllDependencies() throws {
        // given
        let fileFinderMock = FileFinderMock()
        let swiftPackageAnalyzerMock = SwiftPackageAnalyzerMock()
        let xCodeAnalyzerMock = XCodeAnalyzerMock()
        let resolvedPackageAnalyzerMock = ResolvedPackageAnalyzerMock()
        let analyzedDependencyMergerMock = AnalyzedDependencyMergerMock()
        let sut = ProjectAnalyzer(
            fileFinder: fileFinderMock,
            swiftPackageAnalyzer: swiftPackageAnalyzerMock,
            xCodeAnalyzer: xCodeAnalyzerMock,
            resolvedPackageAnalyzer: resolvedPackageAnalyzerMock,
            analyzedDependencyMerger: analyzedDependencyMergerMock
        )

        // when
        _ = try sut.getDependencies(
            projectPath: URL(fileURLWithPath: "/path/to/project"),
            resolvedPackagePath: URL(fileURLWithPath: "/path/to/resolved.swift"),
            includeDependencies: ["included"],
            excludeDependencies: ["excluded"],
            includeTransitiveDependencies: true
        )

        // then
        #expect(analyzedDependencyMergerMock.dependencies == [
            .any(
                name: "dep1",
                pointingTo: .nonExact("upperToV1")
            ),
            .any(
                name: "dep2",
                pointingTo: .version(version: "2.0")
            ),
            .any(
                name: "dep3",
                pointingTo: .version(version: "3.0")
            )
        ])
        #expect(analyzedDependencyMergerMock.resolvedDependencies == [
            .any(
                name: "dep111",
                pointingTo: .version(version: "1.1")
            ),
            .any(
                name: "dep222",
                pointingTo: .version(version: "2.0")
            ),
            .any(
                name: "dep333",
                pointingTo: .version(version: "3.0")
            )
        ])
        #expect(analyzedDependencyMergerMock.includeDependencies == ["included"])
        #expect(analyzedDependencyMergerMock.excludeDependencies == ["excluded"])
        #expect(analyzedDependencyMergerMock.includeTransitiveDependencies == true)
    }

    @Test
    func xcodeprojFileFound_getDependencies_returnsDependencies() throws {
        // given
        let fileFinderMock = FileFinderMock(
            packageSwiftUrl: nil
        )
        let swiftPackageAnalyzerMock = SwiftPackageAnalyzerMock()
        let xCodeAnalyzerMock = XCodeAnalyzerMock()
        let resolvedPackageAnalyzerMock = ResolvedPackageAnalyzerMock()
        let analyzedDependencyMergerMock = AnalyzedDependencyMergerMock()
        let sut = ProjectAnalyzer(
            fileFinder: fileFinderMock,
            swiftPackageAnalyzer: swiftPackageAnalyzerMock,
            xCodeAnalyzer: xCodeAnalyzerMock,
            resolvedPackageAnalyzer: resolvedPackageAnalyzerMock,
            analyzedDependencyMerger: analyzedDependencyMergerMock
        )

        // when
        _ = try sut.getDependencies(
            projectPath: URL(fileURLWithPath: "/path/to/project"),
            resolvedPackagePath: nil,
            includeDependencies: ["included"],
            excludeDependencies: ["excluded"],
            includeTransitiveDependencies: true
        )

        // then
        #expect(analyzedDependencyMergerMock.dependencies == [
            .any(
                name: "dep11",
                pointingTo: .nonExact("upperToV1")
            ),
            .any(
                name: "dep22",
                pointingTo: .version(version: "2.0")
            ),
            .any(
                name: "dep33",
                pointingTo: .version(version: "3.0")
            )
        ])
        #expect(analyzedDependencyMergerMock.resolvedDependencies == [])
        #expect(analyzedDependencyMergerMock.includeDependencies == ["included"])
        #expect(analyzedDependencyMergerMock.excludeDependencies == ["excluded"])
        #expect(analyzedDependencyMergerMock.includeTransitiveDependencies == true)
    }

    @Test
    func xcodeprojFileFoundWithResolvedFile_getDependencies_returnsAllDependencies() throws {
        // given
        let fileFinderMock = FileFinderMock(
            packageSwiftUrl: nil
        )
        let swiftPackageAnalyzerMock = SwiftPackageAnalyzerMock()
        let xCodeAnalyzerMock = XCodeAnalyzerMock()
        let resolvedPackageAnalyzerMock = ResolvedPackageAnalyzerMock()
        let analyzedDependencyMergerMock = AnalyzedDependencyMergerMock()
        let sut = ProjectAnalyzer(
            fileFinder: fileFinderMock,
            swiftPackageAnalyzer: swiftPackageAnalyzerMock,
            xCodeAnalyzer: xCodeAnalyzerMock,
            resolvedPackageAnalyzer: resolvedPackageAnalyzerMock,
            analyzedDependencyMerger: analyzedDependencyMergerMock
        )

        // when
        _ = try sut.getDependencies(
            projectPath: URL(fileURLWithPath: "/path/to/project"),
            resolvedPackagePath: URL(fileURLWithPath: "/path/to/resolved.swift"),
            includeDependencies: ["included"],
            excludeDependencies: ["excluded"],
            includeTransitiveDependencies: true
        )

        // then
        #expect(analyzedDependencyMergerMock.dependencies == [
            .any(
                name: "dep11",
                pointingTo: .nonExact("upperToV1")
            ),
            .any(
                name: "dep22",
                pointingTo: .version(version: "2.0")
            ),
            .any(
                name: "dep33",
                pointingTo: .version(version: "3.0")
            )
        ])
        #expect(analyzedDependencyMergerMock.resolvedDependencies == [
            .any(
                name: "dep111",
                pointingTo: .version(version: "1.1")
            ),
            .any(
                name: "dep222",
                pointingTo: .version(version: "2.0")
            ),
            .any(
                name: "dep333",
                pointingTo: .version(version: "3.0")
            )
        ])
        #expect(analyzedDependencyMergerMock.includeDependencies == ["included"])
        #expect(analyzedDependencyMergerMock.excludeDependencies == ["excluded"])
        #expect(analyzedDependencyMergerMock.includeTransitiveDependencies == true)
    }

    @Test
    func xcodeprojFileAndPackageFileNotFound_getDependencies_throwsError() {
        // given
        let fileFinderMock = FileFinderMock(
            xcodeProjUrl: nil,
            packageSwiftUrl: nil
        )
        let swiftPackageAnalyzerMock = SwiftPackageAnalyzerMock()
        let xCodeAnalyzerMock = XCodeAnalyzerMock()
        let resolvedPackageAnalyzerMock = ResolvedPackageAnalyzerMock()
        let analyzedDependencyMergerMock = AnalyzedDependencyMergerMock()
        let sut = ProjectAnalyzer(
            fileFinder: fileFinderMock,
            swiftPackageAnalyzer: swiftPackageAnalyzerMock,
            xCodeAnalyzer: xCodeAnalyzerMock,
            resolvedPackageAnalyzer: resolvedPackageAnalyzerMock,
            analyzedDependencyMerger: analyzedDependencyMergerMock
        )

        // when / then
        #expect(throws: ProjectAnalyzerError.projectNotFound, performing: {
            try sut.getDependencies(
                projectPath: URL(fileURLWithPath: "/path/to/project"),
                resolvedPackagePath: nil,
                includeDependencies: [],
                excludeDependencies: [],
                includeTransitiveDependencies: true
            )
        })
    }
}

// MARK: - Mocks

private struct FileFinderMock: FileFinderProtocol {
    let xcodeProjUrl: URL?
    let packageSwiftUrl: URL?
    let resolvedPackageUrl: URL?

    init(
        xcodeProjUrl: URL? = URL(fileURLWithPath: "/path/to/project.xcodeproj"),
        packageSwiftUrl: URL? = URL(fileURLWithPath: "/path/to/package.swift"),
        resolvedPackageUrl: URL? = URL(fileURLWithPath: "/path/to/resolved.swift")
    ) {
        self.xcodeProjUrl = xcodeProjUrl
        self.packageSwiftUrl = packageSwiftUrl
        self.resolvedPackageUrl = resolvedPackageUrl
    }

    func find(fileExtension: String, in folder: URL) throws -> URL? {
        ["xcodeproj": xcodeProjUrl].compactMapValues { $0 }[fileExtension]
    }

    func find(fileName: String, in folder: URL) throws -> URL? {
        [
            "Package.swift": packageSwiftUrl,
            "Package.resolved": resolvedPackageUrl
        ].compactMapValues { $0 }[fileName]
    }
}

private struct SwiftPackageAnalyzerMock: SwiftPackageAnalyzerProtocol {
    func getDependencies(packageUrl: URL) throws -> Set<AnalyzedDependency> {
        [
            .any(
                name: "dep1",
                pointingTo: .nonExact("upperToV1")
            ),
            .any(
                name: "dep2",
                pointingTo: .version(version: "2.0")
            ),
            .any(
                name: "dep3",
                pointingTo: .version(version: "3.0")
            )
        ]
    }
}

private struct XCodeAnalyzerMock: XCodeAnalyzerProtocol {
    func getDependencies(projectUrl: URL) throws -> Set<Models.AnalyzedDependency> {
        [
            .any(
                name: "dep11",
                pointingTo: .nonExact("upperToV1")
            ),
            .any(
                name: "dep22",
                pointingTo: .version(version: "2.0")
            ),
            .any(
                name: "dep33",
                pointingTo: .version(version: "3.0")
            )
        ]
    }
}

private struct ResolvedPackageAnalyzerMock: ResolvedPackageAnalyzerProtocol {
    func getDependencies(resolvedFileUrl: URL) throws -> Set<AnalyzedDependency> {
        [
            .any(
                name: "dep111",
                pointingTo: .version(version: "1.1")
            ),
            .any(
                name: "dep222",
                pointingTo: .version(version: "2.0")
            ),
            .any(
                name: "dep333",
                pointingTo: .version(version: "3.0")
            )
        ]
    }
}

private class AnalyzedDependencyMergerMock: AnalyzedDependencyMergerProtocol {
    var dependencies: Set<AnalyzedDependency>?
    var resolvedDependencies: Set<AnalyzedDependency>?
    var includeDependencies: Set<String>?
    var excludeDependencies: Set<String>?
    var includeTransitiveDependencies: Bool?

    func merge(
        dependencies: Set<AnalyzedDependency>,
        resolvedDependencies: Set<AnalyzedDependency>,
        includeDependencies: Set<String>,
        excludeDependencies: Set<String>,
        includeTransitiveDependencies: Bool
    ) -> Set<AnalyzedDependency> {
        self.dependencies = dependencies
        self.resolvedDependencies = resolvedDependencies
        self.includeDependencies = includeDependencies
        self.excludeDependencies = excludeDependencies
        self.includeTransitiveDependencies = includeTransitiveDependencies

        return []
    }
}
