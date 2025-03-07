import Foundation
import Models

protocol SwiftPackageAnalyzerProtocol {
    func getDependencies(packageUrl: URL) throws -> Set<AnalyzedDependency>
}

struct SwiftPackageAnalyzer {}

extension SwiftPackageAnalyzer: SwiftPackageAnalyzerProtocol {
    func getDependencies(packageUrl: URL) throws -> Set<AnalyzedDependency> {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swift", "package", "show-dependencies", "--format", "json"]
        process.currentDirectoryURL = packageUrl.deletingLastPathComponent()

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let jsonDecoder = JSONDecoder()
        let showDependenciesPayload = try jsonDecoder.decode(ShowDependenciesPayload.self, from: data)

        return Set(
            showDependenciesPayload.dependencies.map {
                AnalyzedDependency(
                    name: $0.name,
                    url: $0.url,
                    pointingTo: $0.version.pointingTo
                )
            }
        )
    }
}

private extension String {
    var pointingTo: PointingTo {
        switch self {
        case "unspecified":
            .nonExact(self)
        default:
            .version(version: self)
        }
    }
}
