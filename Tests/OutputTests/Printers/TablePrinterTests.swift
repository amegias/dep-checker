import Foundation
@testable import Output
import Testing

struct TablePrinterTests {}

extension TablePrinterTests {
    @Test
    func printDependencies() throws {
        let expected = [
            [
                "7",
                "https://7.com",
                "1.0.0 (1970-04-26 17:46:40 +0000)",
                "v2.0 (1973-03-03 09:46:40 +0000)",
                "1041 days outdated"
            ],
            [
                "1",
                "https://1.com",
                "1.0.0 (1971-08-02 16:53:20 +0000)",
                "v2.0 (1973-03-03 09:46:40 +0000)",
                "🚨 578 days outdated"
            ],
            [
                "6",
                "https://6.com",
                "1.0.0 (1975-01-26 20:26:40 +0000)",
                "v2.0 (1973-03-03 09:46:40 +0000)",
                "up to date"
            ],
            [
                "5",
                "https://5.com",
                "abcd (Error: Error Domain=anyError Code=-1 \"(null)\")",
                "Error: Error Domain=anyError Code=-1 \"(null)\"",
                ""
            ],
            [
                "4",
                "https://4.com",
                "abcd (Error: Error Domain=anyError Code=-1 \"(null)\")",
                "Error: Error Domain=anyError Code=-1 \"(null)\"",
                ""
            ],
            [
                "3",
                "https://3.com",
                "abcd (1971-04-08 23:06:40 +0000)",
                "Error: Error Domain=anyError Code=-1 \"(null)\"",
                ""
            ],
            [
                "2",
                "https://2.com",
                "1.0.0 (Error: Error Domain=anyError Code=-1 \"(null)\")",
                "v2.0 (1973-03-03 09:46:40 +0000)",
                ""
            ]
        ]
        let sut = TablePrinter(tablePrinter: {
            #expect($0 == expected)
            #expect($1 == ["Name", "URL", "Current version", "Latest version", "Days outdated"])
        })
        let results = OutputPrinter.buildCheckedDependencies()

        try sut.printDependencies(results)
    }
}
