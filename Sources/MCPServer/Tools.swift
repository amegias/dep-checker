import DependencyChecker
import Foundation
import Input
import MCP
import Models
import ProjectAnalyzer
import Validation

enum Tools: String, CaseIterable {
    case depChecker = "dep-checker"

    var tool: Tool {
        switch self {
        case .depChecker:
            Tool(
                name: rawValue,
                description: "Retrieves the dependencies of a Swift Package Manager or Xcode project and checks whether they are outdated, including how long they have been outdated.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "gitHubToken": .object([
                            "type": .string("string"),
                            "description": .string(
                                "GitHub token for retrieving data related to GitHub dependencies (optional)"
                            )
                        ]),
                        "projectPath": .object([
                            "type": .string("string"),
                            "description": .string(
                                "Path to the project. It should point to the xcodeproj or Package.swift folder (required)"
                            )
                        ]),
                        "resolvedPackagePath": .object([
                            "type": .string("string"),
                            "description": .string(
                                "Path to the Package.resolved folder. It will help to get the exact version of the resolved dependencies (optional)"
                            )
                        ]),
                        "includeDependencies": .object([
                            "type": .string("string"),
                            "description": .string("List of dependencies to include in the analysis (optional)")
                        ]),
                        "excludeDependencies": .object([
                            "type": .string("string"),
                            "description": .string("List of dependencies to exclude from the analysis (optional)")
                        ]),
                        "includeTransitiveDependencies": .object([
                            "type": .string("string"),
                            "description": .string(
                                "Gets also the transitive dependencies found in resolved package files."
                            )
                        ])
                    ]),
                    "required": ["projectPath"]
                ])
            )
        }
    }

    func callTool(args: [String: Value]?) async -> CallTool.Result {
        switch self {
        case .depChecker:
            // MARK: - Inputs

            guard let projectPathString = args?["projectPath"]?.stringValue,
                  let projectPath = URL(string: projectPathString)
            else {
                return .init(content: [.text("projectPath is not valid")], isError: true)
            }

            let gitHubToken = args?["gitHubToken"]?.stringValue

            let resolvedPackagePath: URL? = if let resolvedPackagePathString = args?["resolvedPackagePath"]?
                .stringValue
            {
                URL(string: resolvedPackagePathString)
            } else {
                nil
            }

            let includeDependencies: [String] = if let includeDependenciesString = args?["includeDependencies"]?
                .stringValue
            {
                includeDependenciesString.split(separator: " ").map(String.init)
            } else {
                []
            }
            let excludeDependencies: [String] = if let excludeDependenciesString = args?["excludeDependencies"]?
                .stringValue
            {
                excludeDependenciesString.split(separator: " ").map(String.init)
            } else {
                []
            }
            let includeTransitiveDependencies = if let includeTransitiveDependenciesString =
                args?["includeTransitiveDependencies"]?.stringValue
            {
                includeTransitiveDependenciesString == "true"
            } else {
                false
            }

            do {
                let input = try InputCalculator().calculate(
                    InlineInput(
                        configFile: nil,
                        gitHubToken: gitHubToken,
                        maxDays: nil,
                        outputFormat: .json,
                        projectPath: projectPath,
                        resolvedPackagePath: resolvedPackagePath,
                        includeDependencies: includeDependencies,
                        excludeDependencies: excludeDependencies,
                        includeTransitiveDependencies: includeTransitiveDependencies
                    )
                )

                await Configuration.shared.configure(
                    gitHubToken: input.gitHubToken
                )

                // MARK: - Analyze the project

                let dependencies = try ProjectAnalyzer().getDependencies(
                    projectPath: input.projectPath,
                    resolvedPackagePath: input.resolvedPackagePath,
                    includeDependencies: input.includeDependencies,
                    excludeDependencies: input.excludeDependencies,
                    includeTransitiveDependencies: input.includeTransitiveDependencies
                )

                // MARK: - Dependency checks

                let results = await DependencyChecker().check(
                    dependencies,
                    maxDays: input.maxDays,
                    maxDaysPerDependency: input.maxDaysPerDependency
                )

                // MARK: - Result

                return try .init(
                    content: [.text(results.json()!)],
                    isError: false
                )
            } catch {
                return .init(
                    content: [.text("Error \(error.localizedDescription)")],
                    isError: true
                )
            }
        }
    }
}
