import Foundation
import OSLog

protocol BitbucketClientProtocol: Sendable {
    func getTag(_ tag: String, _ owner: String, _ repo: String) async throws -> BitbucketTag
    func getCommit(_ ref: String, _ owner: String, _ repo: String) async throws -> BitbucketCommit
    func getLatestTag(_ owner: String, _ repo: String) async throws -> BitbucketTag
}

struct BitbucketClient: BitbucketClientProtocol {
    func getTag(_ tag: String, _ owner: String, _ repo: String) async throws -> BitbucketTag {
        try await get(reposPath: "\(owner)/\(repo)/refs/tags/\(tag)")
    }

    func getCommit(_ ref: String, _ owner: String, _ repo: String) async throws -> BitbucketCommit {
        try await get(reposPath: "\(owner)/\(repo)/commit/\(ref)")
    }

    func getLatestTag(_ owner: String, _ repo: String) async throws -> BitbucketTag {
        let tags: BitbucketTags = try await get(reposPath: "\(owner)/\(repo)/refs/tags?sort=-name")
        guard let first = tags.values.first else {
            throw APIError.notFound
        }
        return first
    }
}

extension BitbucketClient {
    enum APIError: Error, LocalizedError {
        case notFound

        var errorDescription: String? {
            switch self {
            case .notFound:
                "BitBucket resource not found"
            }
        }
    }
}

private extension BitbucketClient {
    func get<T: Decodable>(reposPath: String) async throws -> T {
        let url = "https://api.bitbucket.org/2.0/repositories/\(reposPath)"
        Logger.bitbucketClient.debug("Getting \(url)...")
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as? HTTPURLResponse
        if httpResponse?.statusCode == 404 {
            Logger.bitbucketClient.debug("Not found!")
            throw APIError.notFound
        } else {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        }
    }
}
