import Foundation

struct FileInputReader {
    private let fileExists: (_ atPath: String) -> Bool
    private let contentsOf: (_ fileURL: URL) throws -> Data

    init(
        fileExists: @escaping (_: String) -> Bool = { FileManager.default.fileExists(atPath: $0) },
        contentsOf: @escaping (_: URL) throws -> Data = { try Data(contentsOf: $0) }
    ) {
        self.fileExists = fileExists
        self.contentsOf = contentsOf
    }
}

extension FileInputReader {
    func read(fileURL: URL?) throws -> FileInput? {
        guard let fileURL,
              fileExists(fileURL.path()) else { return nil }
        let data = try contentsOf(fileURL)
        return try JSONDecoder().decode(FileInput.self, from: data)
    }
}
