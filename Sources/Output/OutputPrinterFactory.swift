import Foundation
import Models

struct OutputPrinterFactory {}

extension OutputPrinterFactory {
    func getPrinter(_ format: OutputFormat) -> Printer {
        switch format {
        case .json:
            JSONPrinter()
        case .table:
            TablePrinter()
        }
    }
}
