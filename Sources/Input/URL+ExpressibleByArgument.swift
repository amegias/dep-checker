import ArgumentParser
import Foundation

extension URL: @retroactive ExpressibleByArgument {
    public init?(argument: String) {
        let urlAllowingTilde = (argument as NSString).expandingTildeInPath
        self = URL(fileURLWithPath: urlAllowingTilde)
    }
}
