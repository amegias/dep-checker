import ArgumentParser
import Foundation
import MCP
import MCPServerInput

@main
struct MCPServer: AsyncParsableCommand {
    static let configuration = CommandConfiguration.default

    @Option(name: .shortAndLong, help: ArgumentHelp(discussion: FileInput.anyExample()))
    var configurationFile: URL?

    @Flag(name: [.long])
    var includeTransitiveDependencies = false

    mutating func run() async throws {
        let server = Server(
            name: "dep-checker-mcp",
            version: Self.configuration.version,
            capabilities: .init(tools: .init(listChanged: false))
        )

        await server.withMethodHandler(ListTools.self, handler: listToolsHandler)
        await server.withMethodHandler(CallTool.self, handler: callToolHandler)

        let transport = StdioTransport()
        try await server.start(transport: transport)

        await server.waitUntilCompleted()
    }
}

private extension MCPServer {
    func listToolsHandler(_: ListTools.Parameters) -> ListTools.Result {
        .init(tools: ToolType.allCases.map(\.tool).map(\.mcpTool))
    }

    func callToolHandler(_ params: CallTool.Parameters) async -> CallTool.Result {
        guard let type = ToolType(rawValue: params.name) else {
            return .init(content: [.text("Unknown tool")], isError: true)
        }
        do {
            let input = try InputCalculator().calculate(
                InlineInput(
                    configFile: configurationFile
                ),
                EnvironmentInput(
                    gitHubToken: ProcessInfo.processInfo.environment["GH_TOKEN"]
                )
            )

            return try await type.tool.handler(args: params.arguments, input: input)
        } catch {
            return .init(content: [.text(error.localizedDescription)], isError: true)
        }
    }
}
