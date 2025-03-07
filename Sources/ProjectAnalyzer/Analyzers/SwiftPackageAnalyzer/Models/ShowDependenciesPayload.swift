import Foundation

struct ShowDependenciesPayload: Decodable {
    let dependencies: [Dependency]

    struct Dependency: Decodable {
        let identity: String
        let name: String
        let url: URL
        let version: String
    }
}
