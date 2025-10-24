import Foundation

public struct CheckedDependency: Encodable, Sendable {
    public let name: String
    public let url: URL
    public let pointingTo: PointingTo
    public let currentVersionDate: CustomResult<Date, Error>
    public let latestVersion: CustomResult<LatestVersion, Error>
    public let outdated: Outdated?

    public init(
        from dependency: AnalyzedDependency,
        currentVersionDate: CustomResult<Date, Error>,
        latestVersion: CustomResult<LatestVersion, Error>,
        maxDays: Int?
    ) {
        name = dependency.name
        url = dependency.url
        pointingTo = dependency.pointingTo
        self.currentVersionDate = currentVersionDate
        self.latestVersion = latestVersion
        outdated = CheckedDependency.getOutdated(
            currentVersionDate: currentVersionDate,
            latestVersion: latestVersion,
            maxDays: maxDays
        )
    }
}

extension CheckedDependency: Comparable {
    public static func < (lhs: CheckedDependency, rhs: CheckedDependency) -> Bool {
        switch (lhs.outdated, rhs.outdated) {
        case (.none, .none): false
        case (.none, .some): true
        case (.some, .none): false
        case let (.some(lhs), .some(rhs)): lhs < rhs
        }
    }

    public static func == (lhs: CheckedDependency, rhs: CheckedDependency) -> Bool {
        lhs.outdated == rhs.outdated
    }
}

private extension CheckedDependency {
    static func getOutdated(
        currentVersionDate: CustomResult<Date, Error>,
        latestVersion: CustomResult<LatestVersion, Error>,
        maxDays: Int?
    ) -> Outdated? {
        guard case .success(let currentDate) = currentVersionDate,
              case .success(let latestVersion) = latestVersion,
              let outdated = Calendar.current.dateComponents([.day], from: currentDate, to: latestVersion.date).day
        else {
            return nil
        }

        let daysOutdated = max(0, outdated)
        let exceedsMaxDays: Bool? = if let maxDays {
            maxDays < daysOutdated
        } else {
            nil
        }
        return Outdated(
            daysOutdated: daysOutdated,
            exceedsMaxDays: exceedsMaxDays
        )
    }
}
