import Foundation
import Models
import Testing
import TestUtils
@testable import Validation

struct MaxDaysCheckedDependencyValidatorTests {}

extension MaxDaysCheckedDependencyValidatorTests {
    @Test
    func test() throws {
        let sut = MaxDaysCheckedDependencyValidator()
        let results = buildResults(maxDays: nil)

        try sut.validate(results)
    }

    @Test(arguments: [10, 11, nil])
    func maxDaysDoNotExceedOutdatedIntervalDoNotThrow(maxDays: Int?) async throws {
        let sut = MaxDaysCheckedDependencyValidator()
        let results = buildResults(maxDays: maxDays)
        try sut.validate(results)
    }

    @Test
    func maxDaysExceedOutdatedInterval() throws {
        let sut = MaxDaysCheckedDependencyValidator()
        let results = buildResults(maxDays: 9)
        do {
            try sut.validate(results)
            #expect(Bool(false))
        } catch {
            guard let error = error as? MaxDaysCheckedDependencyValidator.ValidationError,
                  case .exceedsMaxDays(let dependency) = error
            else {
                #expect(Bool(false))
                return
            }

            #expect(dependency == "outdatedInDays10")
        }
    }
}

private extension MaxDaysCheckedDependencyValidatorTests {
    func buildResults(maxDays: Int?) -> [CheckedDependency] {
        [0, 2, 10, 4].map { outdatedInDays in
            CheckedDependency.any(
                from: .any(name: "outdatedInDays\(outdatedInDays)"),
                currentDate: Date(timeIntervalSince1970: 0),
                latestVersionDate: Date(timeIntervalSince1970: TimeInterval(outdatedInDays * 86_400)),
                maxDays: maxDays
            )
        }
    }
}
