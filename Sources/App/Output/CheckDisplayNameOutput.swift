import Vapor

// MARK: - CheckDisplayNameOutput
final class CheckDisplayNameOutput: Content {

    let exists: Bool

    init(exists: Bool) {
        self.exists = exists
    }

}
