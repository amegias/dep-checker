import Foundation
import Models

protocol CheckedDependencyValidator: Sendable {
    func validate(_ checkedDependencies: [CheckedDependency]) throws
}
