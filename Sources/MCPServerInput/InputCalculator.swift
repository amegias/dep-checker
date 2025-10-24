import Foundation
import Input

public struct InputCalculator {
    private let fileInputReader: FileInputReader
    public init() {
        fileInputReader = FileInputReader()
    }

    init(fileInputReader: FileInputReader) {
        self.fileInputReader = fileInputReader
    }
}

public extension InputCalculator {
    func calculate(_ inlineInput: InlineInput, _ environmentInput: EnvironmentInput) throws -> Input {
        let fileInput = try fileInputReader.read(fileURL: inlineInput.configFile, type: FileInput.self)

        return Input(gitHubToken: environmentInput.gitHubToken ?? fileInput?.gitHubToken)
    }
}
