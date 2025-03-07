import Foundation
import Models

protocol Printer {
    func printDependencies(_ dependencies: [CheckedDependency]) throws
}
