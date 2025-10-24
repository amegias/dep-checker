import Foundation
import Input
@testable import MCPServerInput
import Testing

struct InputCalculatorTests {}

extension InputCalculatorTests {
    @Test
    func fileDoesNotExist_calculate_returnsEnvInputValues() throws {
        let fileInputReader = FileInputReader(
            fileExists: { _ in false },
            contentsOf: { _ in throw NSError(domain: "", code: 0) }
        )
        let inlineInput: InlineInput = .any()
        let environmentInput = EnvironmentInput(gitHubToken: "any")
        let sut = InputCalculator(fileInputReader: fileInputReader)
        let input = try sut.calculate(inlineInput, environmentInput)
        #expect(environmentInput.gitHubToken == input.gitHubToken)
    }

    @Test
    func fileExists_calculate_returnsFileInputValues() throws {
        let fileInputReader = FileInputReader(
            fileExists: { _ in true },
            contentsOf: { _ in buildWithAllData() }
        )
        let inlineInput: InlineInput = .any()
        let environmentInput = EnvironmentInput(gitHubToken: "any")
        let sut = InputCalculator(fileInputReader: fileInputReader)
        let input = try sut.calculate(inlineInput, environmentInput)
        #expect(environmentInput.gitHubToken == input.gitHubToken)
    }

    @Test
    func fileExistsAndMissingInlineValues_calculate_returnsFileInputValues() throws {
        let fileInputReader = FileInputReader(
            fileExists: { _ in true },
            contentsOf: { _ in buildWithAllData() }
        )
        let inlineInput: InlineInput = .any()
        let environmentInput = EnvironmentInput(gitHubToken: nil)
        let sut = InputCalculator(fileInputReader: fileInputReader)
        let input = try sut.calculate(inlineInput, environmentInput)
        #expect(input.gitHubToken == "ghTokenFromFile")
    }

    @Test
    func fileDoesNotExistAndMissingInlineValues_calculate_returnsNoValues() throws {
        let fileInputReader = FileInputReader(
            fileExists: { _ in true },
            contentsOf: { _ in buildWithEmptyData() }
        )
        let inlineInput: InlineInput = .any()
        let environmentInput = EnvironmentInput(gitHubToken: nil)
        let sut = InputCalculator(fileInputReader: fileInputReader)
        let input = try sut.calculate(inlineInput, environmentInput)
        #expect(input.gitHubToken == nil)
    }
}

private extension InputCalculatorTests {
    func buildWithAllData() -> Data {
        """
        {
            "gitHubToken": "ghTokenFromFile"
        }
        """.data(using: .utf8)!
    }

    func buildWithEmptyData() -> Data {
        "{}".data(using: .utf8)!
    }
}

private extension InlineInput {
    static func any() -> InlineInput {
        InlineInput(
            configFile: URL(filePath: "/path/to/config.json")
        )
    }
}
