import Foundation
import Models

public protocol Repository: Sendable {
    func getCurrentVersionDate() async -> CustomResult<Date, Error>
    func getLatestVersion() async -> CustomResult<LatestVersion, any Error>
}

enum RepositoryError: Error, Equatable, CustomStringConvertible {
    case wrongPayload
    case nonExactVersionType(String)

    var description: String {
        switch self {
        case .wrongPayload:
            "wrong payload"
        case .nonExactVersionType(let string):
            "unhandled type: \(string)"
        }
    }
}
