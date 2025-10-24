import Foundation

struct ShowDependenciesPayload: Decodable {
    let dependencies: [Dependency]

    struct Dependency: Decodable {
        let name: String
        let url: URL
        let version: String
    }
}
