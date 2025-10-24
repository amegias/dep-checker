import Foundation
import Output

public struct InlineInput {
    let configFile: URL?
    let gitHubToken: String?
    let maxDays: Int?
    let outputFormat: OutputFormat
    let projectPath: URL
    let resolvedPackagePath: URL?
    let includeDependencies: [String]
    let excludeDependencies: [String]
    let includeTransitiveDependencies: Bool

    public init(
        configFile: URL?,
        gitHubToken: String?,
        maxDays: Int?,
        outputFormat: OutputFormat,
        projectPath: URL,
        resolvedPackagePath: URL?,
        includeDependencies: [String],
        excludeDependencies: [String],
        includeTransitiveDependencies: Bool
    ) {
        self.configFile = configFile
        self.gitHubToken = gitHubToken
        self.maxDays = maxDays
        self.outputFormat = outputFormat
        self.projectPath = projectPath
        self.resolvedPackagePath = resolvedPackagePath
        self.includeDependencies = includeDependencies
        self.excludeDependencies = excludeDependencies
        self.includeTransitiveDependencies = includeTransitiveDependencies
    }
}
