import Foundation
import MCP
import MCPServerInput

enum ToolType: String, CaseIterable {
    case depChecker = "dep-checker"

    var tool: Tool {
        switch self {
        case .depChecker:
            DepCheckerTool()
        }
    }
}

protocol Tool {
    var mcpTool: MCP.Tool { get }
    func handler(args: [String: Value]?, input: Input) async throws -> CallTool.Result
}
