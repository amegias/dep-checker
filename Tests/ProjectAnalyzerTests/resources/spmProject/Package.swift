// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Example",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/adjust/ios_sdk", exact: "5.0.2"),
        .package(url: "https://github.com/airbnb/lottie-ios", from: "4.5.1"),
        .package(url: "https://github.com/qualtrics/qualtrics-digital-ios-sdk", exact: "2.25.0"),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            revision: "f5bfff796ee8e3bc9a685b7ffba1bf20663eb370"
        ),
        .package(url: "https://bitbucket.org/usercentricscode/usercentrics-spm-ui", exact: "2.18.5")
    ],
    targets: [
        .executableTarget(
            name: "Example",
            dependencies: []
        )
    ]
)
