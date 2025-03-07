import Foundation
import Models

public struct OutputPrinter {
    private let outputPrinterFactory = OutputPrinterFactory()
    public init() {}
}

public extension OutputPrinter {
    func printOutput(_ dependencies: [CheckedDependency], format: OutputFormat) throws {
        try outputPrinterFactory
            .getPrinter(format)
            .printDependencies(dependencies)
    }
}
