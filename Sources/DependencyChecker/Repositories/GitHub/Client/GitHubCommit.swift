import Foundation

struct GitHubCommit: Decodable {
    struct InternalCommit: Decodable {
        struct Author: Decodable {
            let date: Date

            init(date: Date) {
                self.date = date
            }
        }

        let author: Author?
    }

    let commit: InternalCommit
}
