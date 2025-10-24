import Foundation
@testable import Output
import Testing

struct JSONPrinterTests {}

extension JSONPrinterTests {
    @Test
    func printDependencies() throws {
        let expected = """
        [{"currentVersionDate":{"value":"1971-08-02T16:53:20Z"},"latestVersion":{"value":{"date":"1973-03-03T09:46:40Z","tag":"v2.0"}},"name":"1","outdated":{"daysOutdated":578,"exceedsMaxDays":true},"pointingTo":{"version":{"version":"1.0.0"}},"url":"https:\\/\\/1.com"},{"currentVersionDate":{"error":"Error Domain=anyError Code=-1 \\"(null)\\"","errorDescription":"The operation couldn’t be completed. (anyError error -1.)"},"latestVersion":{"value":{"date":"1973-03-03T09:46:40Z","tag":"v2.0"}},"name":"2","pointingTo":{"version":{"version":"1.0.0"}},"url":"https:\\/\\/2.com"},{"currentVersionDate":{"value":"1971-04-08T23:06:40Z"},"latestVersion":{"error":"Error Domain=anyError Code=-1 \\"(null)\\"","errorDescription":"The operation couldn’t be completed. (anyError error -1.)"},"name":"3","pointingTo":{"commit":{"hash":"abcd"}},"url":"https:\\/\\/3.com"},{"currentVersionDate":{"error":"Error Domain=anyError Code=-1 \\"(null)\\"","errorDescription":"The operation couldn’t be completed. (anyError error -1.)"},"latestVersion":{"error":"Error Domain=anyError Code=-1 \\"(null)\\"","errorDescription":"The operation couldn’t be completed. (anyError error -1.)"},"name":"4","pointingTo":{"commit":{"hash":"abcd"}},"url":"https:\\/\\/4.com"},{"currentVersionDate":{"error":"Error Domain=anyError Code=-1 \\"(null)\\"","errorDescription":"The operation couldn’t be completed. (anyError error -1.)"},"latestVersion":{"error":"Error Domain=anyError Code=-1 \\"(null)\\"","errorDescription":"The operation couldn’t be completed. (anyError error -1.)"},"name":"5","pointingTo":{"commit":{"hash":"abcd"}},"url":"https:\\/\\/5.com"},{"currentVersionDate":{"value":"1975-01-26T20:26:40Z"},"latestVersion":{"value":{"date":"1973-03-03T09:46:40Z","tag":"v2.0"}},"name":"6","outdated":{"daysOutdated":0},"pointingTo":{"version":{"version":"1.0.0"}},"url":"https:\\/\\/6.com"},{"currentVersionDate":{"value":"1970-04-26T17:46:40Z"},"latestVersion":{"value":{"date":"1973-03-03T09:46:40Z","tag":"v2.0"}},"name":"7","outdated":{"daysOutdated":1041},"pointingTo":{"version":{"version":"1.0.0"}},"url":"https:\\/\\/7.com"}]
        """

        let sut = JSONPrinter(defaultPrinter: {
            print($0)
            #expect($0 == expected)
        })
        let results = OutputPrinter.buildCheckedDependencies()

        try sut.printDependencies(results)
    }
}
