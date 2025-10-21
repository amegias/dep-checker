import Foundation
import Models

struct JSONPrinter {
    var defaultPrinter: @Sendable (String) -> Void = { print($0) }
}

extension JSONPrinter: Printer {
    func printDependencies(_ dependencies: [CheckedDependency]) throws {
        let json = try dependencies.json()
        defaultPrinter(json!)
    }
}
