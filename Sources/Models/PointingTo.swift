import Foundation

public enum PointingTo: Encodable, Equatable, Sendable {
    case version(version: String)
    case commit(hash: String)
    case nonExact(String)
}

extension PointingTo: CustomStringConvertible {
    public var description: String {
        switch self {
        case .version(let version):
            version
        case .commit(let hash):
            hash
        case .nonExact(let string):
            string
        }
    }
}
