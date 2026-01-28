import Foundation
import Models
import Testing
import TestUtils
@testable import Validation

struct DependencyValidatorTests {}

extension DependencyValidatorTests {
    @Test
    func validationOk_validate_throwsNothing() throws {
        let checkedDependencyValidators: [CheckedDependencyValidator] = [
            SucceedValidator(),
            SucceedValidator(),
            SucceedValidator()
        ]
        let sut = DependencyValidator(validators: checkedDependencyValidators)

        try sut.validate([.any()])
    }

    @Test
    func validationKo_validate_throwsFirstError() {
        let checkedDependencyValidators: [CheckedDependencyValidator] = [
            SucceedValidator(),
            FailedValidator(error: "first"),
            SucceedValidator(),
            FailedValidator(error: "second")
        ]
        let sut = DependencyValidator(validators: checkedDependencyValidators)

        #expect(performing: {
            try sut.validate([.any()])
        }, throws: {
            ($0 as NSError).domain == "first"
        })
    }
}

private struct FailedValidator: CheckedDependencyValidator {
    let error: String
    func validate(_ checkedDependencies: [CheckedDependency]) throws {
        throw NSError(domain: error, code: 1)
    }
}

private struct SucceedValidator: CheckedDependencyValidator {
    func validate(_ checkedDependencies: [CheckedDependency]) throws {
        // simulate succeed
    }
}
