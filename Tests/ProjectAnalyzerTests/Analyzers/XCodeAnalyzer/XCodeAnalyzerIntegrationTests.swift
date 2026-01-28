import Foundation
import Models
@testable import ProjectAnalyzer
import Testing

struct XCodeAnalyzerIntegrationTests {
    @Test
    func exampleResource() throws {
        let xcodeproj = try #require(Bundle.module.path(
            forResource: "resources/xcodeprojProject/example",
            ofType: "xcodeproj"
        ))
        let xcodeprojUrl = try #require(URL(string: xcodeproj))

        let xCodeAnalyzer = XCodeAnalyzer()

        let dependencies = try xCodeAnalyzer.getDependencies(projectUrl: xcodeprojUrl)

        let expected = try Set([
            AnalyzedDependency(
                name: "ios_sdk",
                url: #require(URL(string: "https://github.com/adjust/ios_sdk")),
                pointingTo: .version(version: "5.0.2")
            ),
            AnalyzedDependency(
                name: "usercentrics-spm-ui",
                url: #require(URL(string: "https://bitbucket.org/usercentricscode/usercentrics-spm-ui")),
                pointingTo: .version(version: "2.18.5")
            ),
            AnalyzedDependency(
                name: "qualtrics-digital-ios-sdk",
                url: #require(URL(string: "https://github.com/qualtrics/qualtrics-digital-ios-sdk")),
                pointingTo: .version(version: "2.25.0")
            ),
            AnalyzedDependency(
                name: "push-ios",
                url: #require(URL(string: "https://github.com/Telefonica/push-ios")),
                pointingTo: .version(version: "1.0.0")
            ),
            AnalyzedDependency(
                name: "swift-snapshot-testing",
                url: #require(URL(string: "https://github.com/pointfreeco/swift-snapshot-testing")),
                pointingTo: .commit(hash: "f5bfff796ee8e3bc9a685b7ffba1bf20663eb370")
            ),
            AnalyzedDependency(
                name: "lottie-ios",
                url: #require(URL(string: "https://github.com/airbnb/lottie-ios")),
                pointingTo: .nonExact("upToNextMajorVersion(\"4.5.1\")")
            ),
            AnalyzedDependency(
                name: "swift-http-server",
                url: #require(URL(string: "https://bitbucket.org/atlassian/swift-http-server.git")),
                pointingTo: .commit(hash: "72211fb4139a84b6eaa71b1e15356604c84d0d94")
            )
        ])
        #expect(dependencies == expected)
    }
}
