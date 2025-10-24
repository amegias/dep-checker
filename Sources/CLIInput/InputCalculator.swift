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
    func calculate(_ inlineInput: InlineInput) throws -> Input {
        let fileInput = try fileInputReader.read(fileURL: inlineInput.configFile, type: FileInput.self)

        return Input(
            gitHubToken: inlineInput.gitHubToken ?? fileInput?.gitHubToken,
            maxDays: inlineInput.maxDays ?? fileInput?.maxDays,
            outputFormat: inlineInput.outputFormat,
            projectPath: inlineInput.projectPath,
            resolvedPackagePath: inlineInput.resolvedPackagePath,
            includeDependencies: Set(inlineInput.includeDependencies),
            excludeDependencies: Set(inlineInput.excludeDependencies),
            includeTransitiveDependencies: inlineInput.includeTransitiveDependencies,
            maxDaysPerDependency: fileInput?.maxDaysPerDependency ?? [:]
        )
    }
}
