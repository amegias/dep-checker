// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "DepChecker",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/tuist/XcodeProj", exact: "9.5.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.6.1"),
        .package(url: "https://github.com/ShawnBaek/Table.git", exact: "2.0.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.57.2")
    ],
    targets: [
        .executableTarget(
            name: "DepChecker",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Models",
                "Output",
                "Input",
                "DependencyChecker",
                "ProjectAnalyzer",
                "Validation"
            ],
            path: "Sources/CLI",
            resources: [
                .copy("VERSION.txt")
            ]
        ),
        .target(
            name: "Models",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .target(
            name: "Input",
            dependencies: ["Models"]
        ),
        .target(
            name: "Output",
            dependencies: [
                "Models",
                .product(name: "Table", package: "Table")
            ]
        ),
        .target(
            name: "DependencyChecker",
            dependencies: ["Models"]
        ),
        .target(
            name: "ProjectAnalyzer",
            dependencies: [
                "Models",
                "XcodeProj"
            ]
        ),
        .target(
            name: "Validation",
            dependencies: ["Models"]
        ),
        .target(
            name: "TestUtils",
            dependencies: ["Models"],
            path: "Tests/TestUtils"
        ),
        .testTarget(
            name: "OutputTests",
            dependencies: [
                "TestUtils",
                "Output"
            ]
        ),
        .testTarget(
            name: "InputTests",
            dependencies: [
                "Input"
            ]
        ),
        .testTarget(
            name: "ModelsTests",
            dependencies: [
                "Models",
                "TestUtils"
            ]
        ),
        .testTarget(
            name: "ValidationTests",
            dependencies: [
                "Validation",
                "TestUtils"
            ]
        ),
        .testTarget(
            name: "DependencyCheckerTests",
            dependencies: [
                "DependencyChecker",
                "TestUtils"
            ]
        ),
        .testTarget(
            name: "ProjectAnalyzerTests",
            dependencies: [
                "ProjectAnalyzer",
                "TestUtils"
            ],
            resources: [
                .copy("resources")
            ]
        )
    ]
)
