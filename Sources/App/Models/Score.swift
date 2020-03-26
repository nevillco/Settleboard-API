import Fluent
import Vapor
import FluentPostgreSQL

// MARK: - Score
final class Score {

    var id: UUID?
    let value: Int
    let isVictory: Bool
    let userID: User.ID

    init(
        value: Int,
        isVictory: Bool,
        userID: UUID) {
        self.value = value
        self.isVictory = isVictory
        self.userID = userID
    }

}

// MARK: - Migration
extension Score: Migration { }

// MARK: - PostgreSQLUUIDModel
extension Score: PostgreSQLUUIDModel { }

// MARK: - Content
extension Score: Content { }
