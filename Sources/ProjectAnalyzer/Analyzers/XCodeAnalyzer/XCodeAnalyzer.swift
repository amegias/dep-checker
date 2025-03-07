import Foundation
import Models
import OSLog
import PathKit
import XcodeProj

protocol XCodeAnalyzerProtocol {
    func getDependencies(projectUrl: URL) throws -> Set<AnalyzedDependency>
}

class XCodeAnalyzer {}

extension XCodeAnalyzer: XCodeAnalyzerProtocol {
    func getDependencies(projectUrl: URL) throws -> Set<AnalyzedDependency> {
        let proj = try XcodeProj(path: Path(projectUrl.path()))
        let remotePackages = proj.pbxproj.projects
            .flatMap(\.remotePackages)
            .compactMap { remotePackage -> AnalyzedDependency? in
                guard let name = remotePackage.name,
                      let repositoryURLString = remotePackage.repositoryURL,
                      let repositoryURL = URL(string: repositoryURLString),
                      let versionRequirement = remotePackage.versionRequirement,
                      let pointingTo = versionRequirement.resolved
                else {
                    Logger.xCodeAnalyzer.error(
                        "Cannot parse remote package: \(remotePackage.name ?? "unnamed")"
                    )
                    return nil
                }

                return AnalyzedDependency(
                    name: name,
                    url: repositoryURL,
                    pointingTo: pointingTo
                )
            }

        return Set(remotePackages)
    }
}

private extension XCRemoteSwiftPackageReference.VersionRequirement {
    var resolved: PointingTo? {
        switch self {
        case let .exact(string):
            .version(version: string)

        case let .revision(string):
            .commit(hash: string)

        case .upToNextMajorVersion,
             .upToNextMinorVersion,
             .range,
             .branch:
            .nonExact(String(describing: self))
        }
    }
}
