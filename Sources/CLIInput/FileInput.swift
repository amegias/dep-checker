import Foundation

public struct FileInput: Codable {
    let gitHubToken: String?
    let maxDays: Int?
    let maxDaysPerDependency: [String: Int]?

    public static func anyExample() -> String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.prettyPrinted]
        let example = FileInput(
            gitHubToken: "anyToken",
            maxDays: 30,
            maxDaysPerDependency: ["mistica-ios": 10]
        )
        let data = try! jsonEncoder.encode(example)
        return """
        gitHubToken (optional)
        maxDays (optional)
        maxDaysPerDependency (optional)
        \(String(data: data, encoding: .utf8)!)
        """
    }
}
