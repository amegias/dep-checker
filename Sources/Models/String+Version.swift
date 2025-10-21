import Foundation

public extension String {
    static var appVersion: Self {
        try! String(
            contentsOf: Bundle.module.url(
                forResource: "VERSION",
                withExtension: "txt"
            )!,
            encoding: .utf8
        )
    }
}
