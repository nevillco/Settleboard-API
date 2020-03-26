import Fluent
import Vapor
import FluentPostgreSQL

// MARK: - Score
final class Score {

    var id: UUID?
    var userDisplayName: String

    init(userDisplayName: String) {
        self.userDisplayName = userDisplayName
    }

}

// MARK: - PostgreSQLUUIDModel
extension Score: PostgreSQLUUIDModel { }
