import Foundation

struct GitHubReference: Decodable {
    struct Object: Decodable {
        let sha: String
        let type: String

        var isCommit: Bool {
            type == "commit"
        }
    }

    let object: Object
    let ref: String

    var tag: String {
        guard let lastComponent = ref.split(separator: "/").last else { return ref }
        return String(lastComponent)
    }
}
