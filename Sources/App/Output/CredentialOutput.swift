import Vapor

final class CredentialOutput: Content {

    let displayName: String
    let id: User.ID

    init(displayName: String, id: User.ID) {
        self.displayName = displayName
        self.id = id
    }

}
