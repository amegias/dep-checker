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

private extension [CheckedDependency] {
    func json() throws -> String? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8)
    }
}
