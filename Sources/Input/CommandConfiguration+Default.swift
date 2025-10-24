import ArgumentParser
import Foundation

public extension CommandConfiguration {
    static var `default`: Self {
        Self(
            abstract: "Check the outdated dependencies",
            version: .appVersion
        )
    }
}

private extension String {
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
