import Foundation

struct ResolvedPackagePayload: Decodable {
    let pins: [Pin]

    struct Pin: Decodable {
        let identity: String
        let kind: String
        let location: URL
        let state: State

        var isRemoteSourceControl: Bool {
            kind == "remoteSourceControl"
        }
    }

    struct State: Decodable {
        let version: String?
    }
}
