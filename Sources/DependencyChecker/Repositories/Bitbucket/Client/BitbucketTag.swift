import Foundation

struct BitbucketTag: Decodable {
    struct Target: Decodable {
        let date: Date
    }

    let name: String
    let target: Target
}
