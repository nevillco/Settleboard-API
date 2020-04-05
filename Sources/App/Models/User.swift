import Authentication
import Vapor
import Foundation
import FluentPostgreSQL

// MARK: - User
final class User {

    var id: UUID?
    var displayName: String
    var password: String

    init(displayName: String, password: String) {
        self.displayName = displayName
        self.password = password
    }

}

// MARK: - Relations
extension User {

    var matches: Siblings<User, Match, MatchUser> { siblings() }

}

// MARK: - PostgreSQLUUIDModel
extension User: PostgreSQLUUIDModel { }

// MARK: - Migration
extension User: Migration { }

// MARK: - Parameter
extension User: Parameter { }

// MARK: - Content
extension User: Content { }

// MARK: - BasicAuthenticatable
extension User: BasicAuthenticatable {

    static var usernameKey: WritableKeyPath<User, String> { \.displayName }
    static var passwordKey: WritableKeyPath<User, String> { \.password }

}
