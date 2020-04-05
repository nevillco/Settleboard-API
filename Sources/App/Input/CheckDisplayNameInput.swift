import Vapor

// MARK: - CheckDisplayNameInput
final class CheckDisplayNameInput {

    let displayName: String

    init(displayName: String) {
        self.displayName = displayName
    }

}

// MARK: - Content
extension CheckDisplayNameInput: Content { }
