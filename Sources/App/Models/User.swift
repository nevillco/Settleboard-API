import Vapor
import Foundation
import FluentPostgreSQL

final class User {

    var displayName: String?
    var password: String

    init(displayName: String, password: String) {
        self.displayName = displayName
        self.password = password
    }
}

extension User: Model {

    typealias Database = PostgreSQLDatabase

    static var idKey: WritableKeyPath<User, String?> { \.displayName }
}

//extension User: PostgreSQLUUIDModel {}
extension User: Migration {}
