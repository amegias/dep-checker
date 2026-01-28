import Foundation
import Models
@testable import ProjectAnalyzer
import Testing

struct SwiftPackageAnalyzerTests {
    @Test
    func exampleResource() throws {
        let swiftPackage = try #require(Bundle.module.path(
            forResource: "resources/spmProject/Package",
            ofType: "swift"
        ))
        let swiftPackageUrl = URL(fileURLWithPath: swiftPackage)

        let swiftPackageAnalyzer = SwiftPackageAnalyzer()

        let dependencies = try swiftPackageAnalyzer.getDependencies(packageUrl: swiftPackageUrl)

        let expected = try Set([
            AnalyzedDependency(
                name: "AdjustSdk",
                url: #require(URL(string: "https://github.com/adjust/ios_sdk")),
                pointingTo: .version(version: "5.0.2")
            ),
            AnalyzedDependency(
                name: "Lottie",
                url: #require(URL(string: "https://github.com/airbnb/lottie-ios")),
                pointingTo: .version(version: "4.5.1")
            ),
            AnalyzedDependency(
                name: "qualtrics-digital-ios-sdk",
                url: #require(URL(string: "https://github.com/qualtrics/qualtrics-digital-ios-sdk")),
                pointingTo: .version(version: "2.25.0")
            ),
            AnalyzedDependency(
                name: "swift-snapshot-testing",
                url: #require(URL(string: "https://github.com/pointfreeco/swift-snapshot-testing")),
                pointingTo: .nonExact("unspecified")
            ),
            AnalyzedDependency(
                name: "UsercentricsUI",
                url: #require(URL(string: "https://bitbucket.org/usercentricscode/usercentrics-spm-ui")),
                pointingTo: .version(version: "2.18.5")
            )
        ])
        #expect(dependencies == expected)
    }

    @Test
    func wrongResource() throws {
        let swiftPackage = try #require(Bundle.module.path(
            forResource: "resources/wrongSPMProject/Package",
            ofType: "swift"
        ))
        let swiftPackageUrl = URL(fileURLWithPath: swiftPackage)

        let swiftPackageAnalyzer = SwiftPackageAnalyzer()

        #expect(throws: DecodingError.self, performing: {
            try swiftPackageAnalyzer.getDependencies(packageUrl: swiftPackageUrl)
        })
    }
}
