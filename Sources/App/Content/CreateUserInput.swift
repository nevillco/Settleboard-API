import Vapor

// MARK: - CreateUserInput
final class CreateUserInput {

    let displayName: String
    let password: String

    init(displayName: String, password: String) {
        self.displayName = displayName
        self.password = password
    }

}

// MARK: - Content
extension CreateUserInput: Content { }
