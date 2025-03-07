import Foundation
import Models
@testable import Output
import TestUtils

extension OutputPrinter {
    static func buildCheckedDependencies() -> [CheckedDependency] {
        [
            CheckedDependency(
                from: .any(name: "1", pointingTo: .version(version: "1.0.0")),
                currentVersionDate: .success(Date(timeIntervalSince1970: 50_000_000)),
                latestVersion: .success(LatestVersion(
                    tag: "v2.0",
                    date: Date(timeIntervalSince1970: 100_000_000)
                )),
                maxDays: 577
            ),
            CheckedDependency(
                from: .any(name: "2", pointingTo: .version(version: "1.0.0")),
                currentVersionDate: .failure(NSError.any()),
                latestVersion: .success(LatestVersion(
                    tag: "v2.0",
                    date: Date(timeIntervalSince1970: 100_000_000)
                )),
                maxDays: nil
            ),
            CheckedDependency(
                from: .any(name: "3"),
                currentVersionDate: .success(Date(timeIntervalSince1970: 40_000_000)),
                latestVersion: .failure(NSError.any()),
                maxDays: nil
            ),

            CheckedDependency(
                from: .any(name: "4"),
                currentVersionDate: .failure(NSError.any()),
                latestVersion: .failure(NSError.any()),
                maxDays: nil
            ),

            CheckedDependency(
                from: .any(name: "5"),
                currentVersionDate: .failure(NSError.any()),
                latestVersion: .failure(NSError.any()),
                maxDays: nil
            ),
            CheckedDependency(
                from: .any(name: "6", pointingTo: .version(version: "1.0.0")),
                currentVersionDate: .success(Date(timeIntervalSince1970: 160_000_000)),
                latestVersion: .success(LatestVersion(
                    tag: "v2.0",
                    date: Date(timeIntervalSince1970: 100_000_000)
                )),
                maxDays: nil
            ),
            CheckedDependency(
                from: .any(name: "7", pointingTo: .version(version: "1.0.0")),
                currentVersionDate: .success(Date(timeIntervalSince1970: 10_000_000)),
                latestVersion: .success(LatestVersion(
                    tag: "v2.0",
                    date: Date(timeIntervalSince1970: 100_000_000)
                )),
                maxDays: nil
            )
        ]
    }
}
