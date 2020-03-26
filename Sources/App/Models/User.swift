import Vapor
import Foundation
import FluentPostgreSQL

// MARK: - User
final class User {

    var displayName: String
    var password: String

    init(displayName: String, password: String) {
        self.displayName = displayName
        self.password = password
    }
}

// MARK: - Model
extension User: Model {

    typealias Database = PostgreSQLDatabase

    private var optionalDisplayName: String? {
        get { displayName }
        set {
            switch newValue {
            case let newValue?: displayName = newValue
            case nil: return
            }
        }
    }
    static var idKey: WritableKeyPath<User, String?> { \.optionalDisplayName }

}

// MARK: - Migration
extension User: Migration {}
