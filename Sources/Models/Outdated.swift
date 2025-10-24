import Foundation

public struct Outdated: Encodable, Sendable {
    let daysOutdated: Int

    /// Returns true if the value exceeds the considered `maxDays`, false otherwise. Nil if no `maxDays` has been
    /// considered.
    ///
    /// - true: Exceeds the `maxDays`
    /// - false: Does not exceed the `maxDays`
    /// - nil: No `maxDays` has been considered
    public let exceedsMaxDays: Bool?
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
        if exceedsMaxDays == true {
            return "🚨 \(result)"
        }

        return result
    }
}
