import Foundation

public struct FileInput: Codable {
    let gitHubToken: String?

    public static func anyExample() -> String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.prettyPrinted]
        let example = FileInput(
            gitHubToken: "anyToken"
        )
        let data = try! jsonEncoder.encode(example)
        return """
        gitHubToken (optional)
        \(String(data: data, encoding: .utf8)!)
        """
    }
}
