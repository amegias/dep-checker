import Foundation
import Models
import Table

struct TablePrinter {
    var tablePrinter: @Sendable (_ table: [[String]], _ header: [String]) -> Void = { print(table: $0, header: $1) }
}

extension TablePrinter: Printer {
    func printDependencies(_ dependencies: [CheckedDependency]) throws {
        let header = ["Name", "URL", "Current version", "Latest version", "Days outdated"]
        let table = dependencies
            .sorted()
            .reversed()
            .map {
                let current = "\($0.pointingTo) (\($0.currentVersionDate))"
                let latest = "\($0.latestVersion)"
                return [
                    $0.name,
                    $0.url.absoluteString,
                    current,
                    latest,
                    $0.outdated != nil ? "\($0.outdated!)" : ""
                ]
            }
        tablePrinter(table, header)
    }
}
