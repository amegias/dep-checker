import ArgumentParser
import DependencyChecker
import Foundation
import Input
import Models
import Output
import ProjectAnalyzer
import Validation

@main
struct CLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Check the outdated dependencies",
        version: .appVersion
    )

    // MARK: - Args

    @Option(
        name: .shortAndLong,
        help: ArgumentHelp(stringLiteral: OutputFormat.allCases.map(\.rawValue).joined(separator: " | "))
    )
    var outputFormat: OutputFormat = .table

    @Option(name: .shortAndLong, help: ArgumentHelp(discussion: FileInput.anyExample()))
    var configurationFile: URL?

    @Option(name: .long)
    var gitHubToken: String?

    @Option(name: .long, help: "Path to the Package.swift or .pbxproj file")
    var projectPath: URL

    @Option(name: .long, help: "Path to the Package.resolved file")
    var resolvedPackagePath: URL?

    @Option(name: [.long])
    var maxDays: Int?

    @Option(name: [.long], parsing: .upToNextOption)
    var excludeDependencies: [String] = []

    @Option(name: [.long], parsing: .upToNextOption)
    var includeDependencies: [String] = []

    @Flag(name: [.long])
    var includeTransitiveDependencies = false

    // MARK: - Run

    mutating func run() async throws {
        // MARK: - Inputs & Configurations

        let input = try InputCalculator().calculate(
            InlineInput(
                configFile: configurationFile,
                gitHubToken: gitHubToken,
                maxDays: maxDays,
                outputFormat: outputFormat,
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

        // MARK: - Get the output

        try OutputPrinter().printOutput(results, format: input.outputFormat)

        // MARK: - Exit based on validations

        try DependencyValidator().validate(results)
    }
}

private extension FileInput {
    static func anyExample() -> String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.prettyPrinted]
        let example = FileInput(
            gitHubToken: "anyToken",
            maxDays: 30,
            maxDaysPerDependency: ["mistica-ios": 10]
        )
        let data = try! jsonEncoder.encode(example)
        return """
        gitHubToken (optional)
        maxDays (optional)
        maxDaysPerDependency (optional)
        \(String(data: data, encoding: .utf8)!)
        """
    }
}
