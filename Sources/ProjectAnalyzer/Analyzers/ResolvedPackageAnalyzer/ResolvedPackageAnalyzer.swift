import Foundation
import Models

protocol ResolvedPackageAnalyzerProtocol {
    func getDependencies(resolvedFileUrl: URL) throws -> Set<AnalyzedDependency>
}

struct ResolvedPackageAnalyzer {}

extension ResolvedPackageAnalyzer: ResolvedPackageAnalyzerProtocol {
    func getDependencies(resolvedFileUrl: URL) throws -> Set<AnalyzedDependency> {
        let data = try Data(contentsOf: resolvedFileUrl)
        let decoder = JSONDecoder()
        let resolvedPackage = try decoder.decode(ResolvedPackagePayload.self, from: data)
        return Set(
            resolvedPackage.pins
                .filter(\.isRemoteSourceControl)
                .compactMap { pin in
                    guard let version = pin.state.version else { return nil }
                    return AnalyzedDependency(
                        name: pin.identity,
                        url: pin.location,
                        pointingTo: .version(version: version)
                    )
                }
        )
    }
}
