import Fluent
import Vapor
import FluentPostgreSQL

// MARK: - Score
final class Score {

    var id: UUID?
    let value: Int
    let isVictory: Bool

    let userID: User.ID
    let matchID: Match.ID

    init(
        value: Int,
        isVictory: Bool,
        userID: User.ID,
        matchID: Match.ID) {
        self.value = value
        self.isVictory = isVictory
        self.userID = userID
        self.matchID = matchID
    }

}

// MARK: - Migration
extension Score: Migration { }

// MARK: - PostgreSQLUUIDModel
extension Score: PostgreSQLUUIDModel { }

// MARK: - Content
extension Score: Content { }
