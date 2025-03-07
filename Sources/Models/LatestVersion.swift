import Foundation

public struct LatestVersion: Encodable, Sendable {
    let tag: String
    let date: Date

    public init(tag: String, date: Date) {
        self.tag = tag
        self.date = date
    }
}

extension LatestVersion: CustomStringConvertible {
    public var description: String {
        "\(tag) (\(date))"
    }
}
