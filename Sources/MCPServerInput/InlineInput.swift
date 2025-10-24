import Foundation

public struct InlineInput {
    let configFile: URL?

    public init(
        configFile: URL?
    ) {
        self.configFile = configFile
    }
}
