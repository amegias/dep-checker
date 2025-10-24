import Foundation

public enum CustomResult<T: Encodable & Sendable, E: Error>: Sendable {
    case success(T)
    case failure(E)
}

extension CustomResult: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .success(let value):
            try container.encode(value, forKey: .value)
        case .failure(let error):
            try container.encode(String(describing: error), forKey: .error)
            try container.encode(error.localizedDescription, forKey: .errorDescription)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case value
        case error
        case errorDescription
    }
}

extension CustomResult: CustomStringConvertible {
    public var description: String {
        switch self {
        case .success(let t):
            "\(t)"
        case .failure(let e):
            "Error: \(e.localizedDescription)"
        }
    }
}
