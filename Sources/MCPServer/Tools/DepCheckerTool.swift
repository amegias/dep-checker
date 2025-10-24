import DependencyChecker
import Foundation
import MCP
import MCPServerInput
import ProjectAnalyzer

struct DepCheckerTool: Tool {
    var mcpTool: MCP.Tool {
        MCP.Tool(
            name: "dep-checker",
            description: "Retrieves the dependencies of a Swift Package Manager or Xcode project and checks whether they are outdated, including how long they have been outdated.",
            inputSchema: RuntimeInput.schema
        )
    }

    func handler(args: [String: Value]?, input: Input) async throws -> CallTool.Result {
        // MARK: - Inputs

        let runtimeInput = try RuntimeInput(from: args)

        // MARK: - Analyze the project

        let dependencies = try ProjectAnalyzer().getDependencies(
            projectPath: runtimeInput.projectPath,
            resolvedPackagePath: runtimeInput.resolvedPackagePath,
            includeDependencies: [],
            excludeDependencies: [],
            includeTransitiveDependencies: runtimeInput.includeTransitiveDependencies ?? false
        )

        // MARK: - Dependency checks

        var matchers: [RepositoryMatcher] = [
            BitbucketRepositoryMatcher()
        ]
        if let gitHubToken = input.gitHubToken {
            matchers.append(GitHubRepositoryMatcher(gitHubToken: gitHubToken))
        }
        let results = await DependencyChecker(matchers: matchers)
            .check(dependencies)

        // MARK: - Result

        let jsonString = try results.json()
        return .init(
            content: [.text(jsonString ?? "")],
            isError: false
        )
    }
}
