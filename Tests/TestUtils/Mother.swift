import Foundation
import Models

public extension AnalyzedDependency {
    static func any(
        name: String,
        pointingTo: PointingTo = .commit(hash: "abcd")
    ) -> Self {
        AnalyzedDependency(name: name, url: URL(string: "https://\(name).com")!, pointingTo: pointingTo)
    }

    static func any(
        url: String,
        pointingTo: PointingTo = .commit(hash: "abcd")
    ) -> Self {
        AnalyzedDependency(name: url, url: URL(string: url)!, pointingTo: pointingTo)
    }
}

public extension CheckedDependency {
    static func any(
        from dependency: AnalyzedDependency = .any(name: "any"),
        currentDate: Date = Date(timeIntervalSince1970: 10_000_000),
        latestVersionDate: Date = Date(timeIntervalSince1970: 40_000_000),
        maxDays: Int? = nil
    ) -> Self {
        CheckedDependency(
            from: dependency,
            currentVersionDate: .success(currentDate),
            latestVersion: .success(.any(date: latestVersionDate)),
            maxDays: maxDays
        )
    }
}

public extension LatestVersion {
    static func any(date: Date = Date(timeIntervalSince1970: 86_400 * 5)) -> LatestVersion {
        LatestVersion(tag: "anyTag", date: date)
    }
}

public extension NSError {
    static func any() -> NSError {
        NSError(domain: "anyError", code: -1)
    }
}
