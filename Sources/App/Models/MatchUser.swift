import FluentPostgreSQL
import Vapor

// MARK: - MatchUser
final class MatchUser {

    var id: UUID?
    var matchID: UUID
    var userID: UUID

    var value: Int
    var isVictory: Bool

    init(matchID: UUID, userID: UUID, value: Int) {
        self.matchID = matchID
        self.userID = userID
        self.value = value
        self.isVictory = value >= 10
    }

}

// MARK: - PostgreSQLUUIDPivot
extension MatchUser: PostgreSQLUUIDPivot {

    typealias Left = Match
    typealias Right = User

    static let leftIDKey: WritableKeyPath<MatchUser, UUID> = \.matchID
    static let rightIDKey: WritableKeyPath<MatchUser, UUID> = \.userID

}

// MARK: - Content
extension MatchUser: Content { }

// MARK: - Migration
extension MatchUser: Migration { }
