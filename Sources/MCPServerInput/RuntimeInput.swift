import Foundation
import MCP

public struct RuntimeInput {
    public let projectPath: URL
    public let resolvedPackagePath: URL?
    public let includeTransitiveDependencies: Bool?
}

public extension RuntimeInput {
    static var schema: Value {
        .object([
            "type": .string("object"),
            "properties": .object([
                Keys.projectPath: .object([
                    "type": .string("string"),
                    "description": .string(
                        "Path to the project. It should point to the xcodeproj or Package.swift folder (required)"
                    )
                ]),
                Keys.resolvedPackagePath: .object([
                    "type": .string("string"),
                    "description": .string(
                        "Path to the Package.resolved folder. It will help to get the exact version of the resolved dependencies (optional)"
                    )
                ]),
                Keys.includeTransitiveDependencies: .object([
                    "type": .string("boolean"),
                    "description": .string(
                        "Gets also the transitive dependencies found in resolved package files (optional, false by default)"
                    )
                ])
            ]),
            "required": [.string(Keys.projectPath)]
        ])
    }
}

public extension RuntimeInput {
    init(from args: [String: Value]?) throws(RuntimeInputError) {
        guard let args else { throw .noArgs }
        guard let projectPathString = args[Keys.projectPath]?.stringValue else { throw .noProjectPath }
        guard let projectPath = URL(string: projectPathString) else { throw .projectPathInvalid }

        let resolvedPackagePath: URL? = if let resolvedPackagePathString = args[Keys.resolvedPackagePath]?
            .stringValue
        {
            URL(string: resolvedPackagePathString)
        } else {
            nil
        }

        self.projectPath = projectPath
        self.resolvedPackagePath = resolvedPackagePath
        includeTransitiveDependencies = args[Keys.includeTransitiveDependencies]?
            .boolValue
    }
}

// periphery:ignore
public enum RuntimeInputError: Error, LocalizedError {
    case noArgs
    case noProjectPath
    case projectPathInvalid

    public var errorDescription: String? {
        switch self {
        case .noArgs:
            "Missing arguments"
        case .noProjectPath:
            "No project path found in the arguments"
        case .projectPathInvalid:
            "The project path found is not a URL valid"
        }
    }
}

private enum Keys {
    static let projectPath = "projectPath"
    static let resolvedPackagePath = "resolvedPackagePath"
    static let includeTransitiveDependencies = "includeTransitiveDependencies"
}
