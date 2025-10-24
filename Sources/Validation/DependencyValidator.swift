import Foundation
import Models

public struct DependencyValidator {
    private let validators: [CheckedDependencyValidator]

    public init(validators: [CheckedDependencyValidator]) {
        self.validators = validators
    }
}

public extension DependencyValidator {
    func validate(_ checkedDependencies: [CheckedDependency]) throws {
        for validators in validators {
            try validators.validate(checkedDependencies)
        }
    }
}
