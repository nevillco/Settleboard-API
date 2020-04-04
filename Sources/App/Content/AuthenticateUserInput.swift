import Vapor

// MARK: - AuthenticateUserInput
final class AuthenticateUserInput {

    let displayName: String
    let password: String

    init(displayName: String, password: String) {
        self.displayName = displayName
        self.password = password
    }

}

// MARK: - Content
extension AuthenticateUserInput: Content { }
