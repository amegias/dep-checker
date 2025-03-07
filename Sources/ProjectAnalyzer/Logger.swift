import OSLog

extension Logger {
    private static let subsystem = "ProjectAnalyzer"

    static let xCodeAnalyzer = Logger(subsystem: subsystem, category: "XCodeAnalyzer")
    static let projectAnalyzer = Logger(subsystem: subsystem, category: "ProjectAnalyzer")
}
