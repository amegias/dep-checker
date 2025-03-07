import Foundation

public struct Outdated: Encodable, Sendable {
    let daysOutdated: Int
    public let isOutdated: Bool
}

extension Outdated: Comparable {
    public static func < (lhs: Outdated, rhs: Outdated) -> Bool {
        lhs.daysOutdated < rhs.daysOutdated
    }

    public static func == (lhs: Outdated, rhs: Outdated) -> Bool {
        lhs.daysOutdated == rhs.daysOutdated
    }
}

extension Outdated: CustomStringConvertible {
    public var description: String {
        guard daysOutdated > 0 else { return "up to date" }

        let result = "\(daysOutdated) days outdated"
        if isOutdated {
            return "🚨 \(result)"
        }

        return result
    }
}
