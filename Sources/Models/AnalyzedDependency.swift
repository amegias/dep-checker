import Foundation

public struct AnalyzedDependency: Encodable, Equatable, Sendable, Hashable {
    public let name: String
    public let url: URL
    public let pointingTo: PointingTo

    public init(name: String, url: URL, pointingTo: PointingTo) {
        self.name = name
        self.url = url
        self.pointingTo = pointingTo
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.url == rhs.url
    }
}
