import Foundation

protocol FileFinderProtocol {
    func find(fileExtension: String, in folder: URL) throws -> URL?
    func find(fileName: String, in folder: URL) throws -> URL?
}

struct FileFinder {
    let fileManager: FileManager
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
}

extension FileFinder: FileFinderProtocol {
    func find(fileExtension: String, in folder: URL) throws -> URL? {
        try find(in: folder) {
            $0.pathExtension == fileExtension
        }
    }

    func find(fileName: String, in folder: URL) throws -> URL? {
        try find(in: folder) {
            $0.lastPathComponent == fileName
        }
    }
}

private extension FileFinder {
    func find(in folder: URL, where: (URL) -> Bool) throws -> URL? {
        let files = try fileManager.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil)
        return files.first(where: `where`)
    }
}
