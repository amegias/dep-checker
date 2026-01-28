// swift-tools-version:6.2
import PackageDescription

let package = Package(
    name: "DepChecker",
    platforms: [.macOS(.v26)],
    products: [
        .executable(
            name: "dep-checker",
            targets: ["CLI"]
        ),
        .executable(
            name: "dep-checker-mcp",
            targets: ["MCPServer"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/tuist/XcodeProj", exact: "9.7.2"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", exact: "1.7.0"),
        .package(url: "https://github.com/ShawnBaek/Table.git", exact: "2.1.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", exact: "0.59.0"),
        .package(url: "https://github.com/modelcontextprotocol/swift-sdk", exact: "0.10.2"),
    ],
    targets: [
        .executableTarget(
            name: "MCPServer",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "MCP", package: "swift-sdk"),
                "MCPServerInput",
                "DependencyChecker",
                "ProjectAnalyzer",
                "Validation",
            ],
        ),
        .executableTarget(
            name: "CLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Output",
                "CLIInput",
                "DependencyChecker",
                "ProjectAnalyzer",
                "Validation",
            ]
        ),
        .target(
            name: "CLIInput",
            dependencies: [
                "Models",
                "Output",
                "Input",
            ]
        ),
        .target(
            name: "MCPServerInput",
            dependencies: [
                .product(name: "MCP", package: "swift-sdk"),
                "Input",
            ]
        ),
        .target(
            name: "Models",
            dependencies: []
        ),
        .target(
            name: "Input",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Models"
            ],
            resources: [
                .copy("VERSION.txt")
            ]
        ),
        .target(
            name: "Output",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Table", package: "Table"),
                "Models",
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
            name: "CLIInputTests",
            dependencies: [
                "CLIInput"
            ]
        ),
        .testTarget(
            name: "MCPServerInputTests",
            dependencies: [
                "MCPServerInput"
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
