import Foundation
import Models

public struct Input {
    public let gitHubToken: String?
    public let maxDays: Int?
    public let outputFormat: OutputFormat
    public let projectPath: URL
    public let resolvedPackagePath: URL?
    public let includeDependencies: Set<String>
    public let excludeDependencies: Set<String>
    public let includeTransitiveDependencies: Bool
    public let maxDaysPerDependency: [String: Int]
}
