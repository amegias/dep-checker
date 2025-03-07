import Foundation
@testable import Output
import Testing

struct JSONPrinterTests {}

extension JSONPrinterTests {
    @Test
    func printDependencies() throws {
        let expected = """
        [{"currentVersionDate":{"success":"1971-08-02T16:53:20Z"},"latestVersion":{"success":{"date":"1973-03-03T09:46:40Z","tag":"v2.0"}},"name":"1","outdated":{"daysOutdated":578,"isOutdated":true},"pointingTo":{"version":{"version":"1.0.0"}},"url":"https:\\/\\/1.com"},{"currentVersionDate":{"failure":"Error Domain=anyError Code=-1 \\"(null)\\""},"latestVersion":{"success":{"date":"1973-03-03T09:46:40Z","tag":"v2.0"}},"name":"2","pointingTo":{"version":{"version":"1.0.0"}},"url":"https:\\/\\/2.com"},{"currentVersionDate":{"success":"1971-04-08T23:06:40Z"},"latestVersion":{"failure":"Error Domain=anyError Code=-1 \\"(null)\\""},"name":"3","pointingTo":{"commit":{"hash":"abcd"}},"url":"https:\\/\\/3.com"},{"currentVersionDate":{"failure":"Error Domain=anyError Code=-1 \\"(null)\\""},"latestVersion":{"failure":"Error Domain=anyError Code=-1 \\"(null)\\""},"name":"4","pointingTo":{"commit":{"hash":"abcd"}},"url":"https:\\/\\/4.com"},{"currentVersionDate":{"failure":"Error Domain=anyError Code=-1 \\"(null)\\""},"latestVersion":{"failure":"Error Domain=anyError Code=-1 \\"(null)\\""},"name":"5","pointingTo":{"commit":{"hash":"abcd"}},"url":"https:\\/\\/5.com"},{"currentVersionDate":{"success":"1975-01-26T20:26:40Z"},"latestVersion":{"success":{"date":"1973-03-03T09:46:40Z","tag":"v2.0"}},"name":"6","outdated":{"daysOutdated":0,"isOutdated":false},"pointingTo":{"version":{"version":"1.0.0"}},"url":"https:\\/\\/6.com"},{"currentVersionDate":{"success":"1970-04-26T17:46:40Z"},"latestVersion":{"success":{"date":"1973-03-03T09:46:40Z","tag":"v2.0"}},"name":"7","outdated":{"daysOutdated":1041,"isOutdated":false},"pointingTo":{"version":{"version":"1.0.0"}},"url":"https:\\/\\/7.com"}]
        """

        let sut = JSONPrinter(defaultPrinter: {
            #expect($0 == expected)
        })
        let results = OutputPrinter.buildCheckedDependencies()

        try sut.printDependencies(results)
    }
}
