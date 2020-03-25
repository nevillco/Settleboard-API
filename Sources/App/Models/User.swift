import Vapor
import Foundation
import FluentPostgreSQL

final class User: Content {
    var id: UUID?

    var displayName: String
    var password: String

    init(displayName: String, password: String) {
        self.displayName = displayName
        self.password = password
    }
}

extension User: PostgreSQLUUIDModel {}
extension User: Migration {}
