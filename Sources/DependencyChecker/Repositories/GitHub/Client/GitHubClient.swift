import Foundation
import OSLog

protocol GitHubClientProtocol: Sendable {
    func getLatestRelease(_ owner: String, _ repo: String) async throws -> GitHubRelease
    func getLatestTag(_ owner: String, _ repo: String) async throws -> (tag: String, commit: GitHubCommit)
    func getRelease(_ tag: String, _ owner: String, _ repo: String) async throws -> GitHubRelease
    func getCommitByRef(_ ref: String, _ owner: String, _ repo: String) async throws -> GitHubCommit
    func getCommitByTag(_ tag: String, _ owner: String, _ repo: String) async throws -> GitHubCommit
}

struct GitHubClient: GitHubClientProtocol {
    enum APIError: Error, CustomStringConvertible {
        case notFound
        case genericError
        case missingToken

        var description: String {
            switch self {
            case .notFound:
                "not found"
            case .genericError:
                "generic"
            case .missingToken:
                "missing access token"
            }
        }
    }

    func getLatestRelease(_ owner: String, _ repo: String) async throws -> GitHubRelease {
        try await get(reposPath: "\(owner)/\(repo)/releases/latest")
    }

    func getLatestTag(_ owner: String, _ repo: String) async throws -> (tag: String, commit: GitHubCommit) {
        let references: [GitHubReference] = try await get(reposPath: "\(owner)/\(repo)/git/matching-refs/tags")
        let last = references.last { $0.object.isCommit }
        guard let last else { throw APIError.notFound }
        let commit: GitHubCommit = try await get(reposPath: "\(owner)/\(repo)/commits/\(last.object.sha)")
        return (last.tag, commit)
    }

    func getRelease(_ tag: String, _ owner: String, _ repo: String) async throws -> GitHubRelease {
        try await get(reposPath: "\(owner)/\(repo)/releases/tags/\(tag)")
    }

    func getCommitByRef(_ ref: String, _ owner: String, _ repo: String) async throws -> GitHubCommit {
        try await get(reposPath: "\(owner)/\(repo)/commits/\(ref)")
    }

    func getCommitByTag(_ tag: String, _ owner: String, _ repo: String) async throws -> GitHubCommit {
        try await get(reposPath: "\(owner)/\(repo)/commits/refs/tags/\(tag)")
    }
}

private extension GitHubClient {
    func get<T: Decodable>(reposPath: String) async throws -> T {
        guard let token = await Configuration.shared.gitHubToken else { throw APIError.missingToken }

        let url = "https://api.github.com/repos/\(reposPath)"
        Logger.gitHubClient.debug("Getting \(url)...")
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.addValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as? HTTPURLResponse
        if httpResponse?.statusCode == 404 {
            throw APIError.notFound
        } else if httpResponse?.statusCode == 401 {
            Logger.gitHubClient.error("Bad credentials!")
            throw APIError.notFound
        } else if httpResponse?.statusCode == 200 {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } else {
            Logger.gitHubClient.error("Error! \(String(data: data, encoding: .utf8) ?? "No data")")
            throw APIError.genericError
        }
    }
}
