import Foundation

struct GitHubRelease: Decodable {
    let created_at: Date
    let published_at: Date?
    let tag_name: String

    var date: Date {
        published_at ?? created_at
    }

    enum CodingKeys: CodingKey {
        case created_at
        case published_at
        case tag_name
    }

    init(created_at: Date, published_at: Date?, tag_name: String) {
        self.created_at = created_at
        self.published_at = published_at
        self.tag_name = tag_name
    }

    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<GitHubRelease.CodingKeys> = try decoder
            .container(keyedBy: GitHubRelease.CodingKeys.self)
        tag_name = try container.decode(String.self, forKey: GitHubRelease.CodingKeys.tag_name)
        let createdAt = try container.decode(String.self, forKey: GitHubRelease.CodingKeys.created_at)
        created_at = ISO8601DateFormatter().date(from: createdAt)!
        if let publishedAt = try container.decodeIfPresent(String.self, forKey: GitHubRelease.CodingKeys.published_at) {
            published_at = ISO8601DateFormatter().date(from: publishedAt)!
        } else {
            published_at = nil
        }
    }
}
