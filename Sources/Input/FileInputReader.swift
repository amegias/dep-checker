import Foundation

public struct FileInputReader {
    private let fileExists: (_ atPath: String) -> Bool
    private let contentsOf: (_ fileURL: URL) throws -> Data

    public init(
        fileExists: @escaping (_: String) -> Bool = { FileManager.default.fileExists(atPath: $0) },
        contentsOf: @escaping (_: URL) throws -> Data = { try Data(contentsOf: $0) }
    ) {
        self.fileExists = fileExists
        self.contentsOf = contentsOf
    }
}

public extension FileInputReader {
    func read<T: Decodable>(fileURL: URL?, type: T.Type) throws -> T? {
        guard let fileURL,
              fileExists(fileURL.path()) else { return nil }
        let data = try contentsOf(fileURL)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
