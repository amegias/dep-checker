import Foundation
import MCP
import Models

@main
struct MCPServer {
    static func main() async throws {
        let server = Server(
            name: "dep-checker-mcp",
            version: .appVersion,
            capabilities: .init(tools: .init(listChanged: true))
        )

        await server.withMethodHandler(ListTools.self, handler: listToolsHandler)
        await server.withMethodHandler(CallTool.self, handler: callToolHandler)

        let transport = StdioTransport()
        try await server.start(transport: transport)

        await server.waitUntilCompleted()
    }
}

private extension MCPServer {
    static func listToolsHandler(_ params: ListTools.Parameters) -> ListTools.Result {
        .init(tools: Tools.allCases.map(\.tool))
    }

    static func callToolHandler(_ params: CallTool.Parameters) async -> CallTool.Result {
        guard let tools = Tools(rawValue: params.name) else {
            return .init(content: [.text("Unknown tool")], isError: true)
        }
        return await tools.callTool(args: params.arguments)
    }
}
