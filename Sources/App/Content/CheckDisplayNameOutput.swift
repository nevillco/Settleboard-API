import Vapor

// MARK: - CheckDisplayNameOutput
final class CheckDisplayNameOutput {

    let exists: Bool

    init(exists: Bool) {
        self.exists = exists
    }

}

// MARK: - Content
extension CheckDisplayNameOutput: Content { }
