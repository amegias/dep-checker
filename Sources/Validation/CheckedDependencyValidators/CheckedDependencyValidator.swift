import Foundation
import Models

public protocol CheckedDependencyValidator: Sendable {
    func validate(_ checkedDependencies: [CheckedDependency]) throws
}
