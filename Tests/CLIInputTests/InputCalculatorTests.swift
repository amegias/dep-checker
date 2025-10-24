@testable import CLIInput
import Foundation
import Input
import Testing

struct InputCalculatorTests {}

extension InputCalculatorTests {
    @Test
    func fileExistsButCannotBeRead_calculate_throwsError() throws {
        let fileInputReader = FileInputReader(
            fileExists: { _ in true },
            contentsOf: { _ in throw NSError(domain: "", code: 0) }
        )
        let sut = InputCalculator(fileInputReader: fileInputReader)
        #expect(throws: NSError.self, performing: {
            try sut.calculate(.any())
        })
    }

    @Test
    func fileDoesNotExist_calculate_returnsInlineInputValues() throws {
        let fileInputReader = FileInputReader(
            fileExists: { _ in false },
            contentsOf: { _ in throw NSError(domain: "", code: 0) }
        )
        let inlineInput: InlineInput = .any()
        let sut = InputCalculator(fileInputReader: fileInputReader)

        let input = try sut.calculate(inlineInput)

        #expect(inlineInput.gitHubToken == input.gitHubToken)
        #expect(inlineInput.maxDays == input.maxDays)
        #expect(inlineInput.outputFormat == input.outputFormat)
        #expect(inlineInput.projectPath == input.projectPath)
        #expect(Set(inlineInput.includeDependencies) == input.includeDependencies)
        #expect(Set(inlineInput.excludeDependencies) == input.excludeDependencies)
        #expect(inlineInput.includeTransitiveDependencies == input.includeTransitiveDependencies)
    }

    @Test
    func fileExists_calculate_returnsInlineInputValues() throws {
        let fileInputReader = FileInputReader(
            fileExists: { _ in true },
            contentsOf: { _ in buildWithAllData() }
        )
        let inlineInput: InlineInput = .any()
        let sut = InputCalculator(fileInputReader: fileInputReader)

        let input = try sut.calculate(inlineInput)

        #expect(inlineInput.gitHubToken == input.gitHubToken)
        #expect(inlineInput.maxDays == input.maxDays)
        #expect(inlineInput.outputFormat == input.outputFormat)
        #expect(inlineInput.projectPath == input.projectPath)
        #expect(Set(inlineInput.includeDependencies) == input.includeDependencies)
        #expect(Set(inlineInput.excludeDependencies) == input.excludeDependencies)
        #expect(inlineInput.includeTransitiveDependencies == input.includeTransitiveDependencies)
    }

    @Test
    func fileExistsAndMissingInlineValues_calculate_returnsInlineInputValuesPlusFileValues() throws {
        let fileInputReader = FileInputReader(
            fileExists: { _ in true },
            contentsOf: { _ in buildWithAllData() }
        )
        let inlineInput: InlineInput = .any(
            gitHubToken: nil,
            maxDays: nil
        )
        let sut = InputCalculator(fileInputReader: fileInputReader)

        let input = try sut.calculate(inlineInput)

        #expect(input.gitHubToken == "ghTokenFromFile")
        #expect(input.maxDays == 34)
        #expect(inlineInput.outputFormat == input.outputFormat)
        #expect(inlineInput.projectPath == input.projectPath)
        #expect(Set(inlineInput.includeDependencies) == input.includeDependencies)
        #expect(Set(inlineInput.excludeDependencies) == input.excludeDependencies)
        #expect(inlineInput.includeTransitiveDependencies == input.includeTransitiveDependencies)
    }

    @Test
    func fileDoesNotExistAndMissingInlineValues_calculate_returnsInlineInputValues() throws {
        let fileInputReader = FileInputReader(
            fileExists: { _ in true },
            contentsOf: { _ in buildWithEmptyData() }
        )
        let inlineInput: InlineInput = .any(
            gitHubToken: nil,
            maxDays: nil
        )
        let sut = InputCalculator(fileInputReader: fileInputReader)

        let input = try sut.calculate(inlineInput)

        #expect(input.gitHubToken == nil)
        #expect(inlineInput.maxDays == nil)
        #expect(inlineInput.outputFormat == input.outputFormat)
        #expect(inlineInput.projectPath == input.projectPath)
        #expect(Set(inlineInput.includeDependencies) == input.includeDependencies)
        #expect(Set(inlineInput.excludeDependencies) == input.excludeDependencies)
        #expect(inlineInput.includeTransitiveDependencies == input.includeTransitiveDependencies)
    }
}

private extension InputCalculatorTests {
    func buildWithAllData() -> Data {
        """
        {
            "gitHubToken": "ghTokenFromFile",
            "maxDays": 34
        }
        """.data(using: .utf8)!
    }

    func buildWithEmptyData() -> Data {
        "{}".data(using: .utf8)!
    }
}

private extension InlineInput {
    static func any(
        gitHubToken: String? = "anyGitHubToken",
        maxDays: Int? = 10
    ) -> InlineInput {
        InlineInput(
            configFile: URL(filePath: "/path/to/config.json"),
            gitHubToken: gitHubToken,
            maxDays: maxDays,
            outputFormat: .json,
            projectPath: URL(filePath: "/path/to/project"),
            resolvedPackagePath: nil,
            includeDependencies: ["includedDependency"],
            excludeDependencies: ["excludedDependency"],
            includeTransitiveDependencies: true
        )
    }
}
