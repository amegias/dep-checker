import Foundation
import Models

public protocol Repository: Sendable {
    func getCurrentVersionDate() async -> CustomResult<Date, Error>
    func getLatestVersion() async -> CustomResult<LatestVersion, any Error>
}

enum RepositoryError: Error, Equatable, LocalizedError {
    case wrongPayload
    case nonExactVersionType(String)

    var errorDescription: String? {
        switch self {
        case .wrongPayload:
            "Unexpected API response"
        case .nonExactVersionType(let string):
            "Non exact version (\(string))"
        }
    }
}
