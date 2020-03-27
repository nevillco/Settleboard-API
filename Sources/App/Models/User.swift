import Vapor
import Foundation
import FluentPostgreSQL

// MARK: - User
final class User {

    var id: UUID?
    var displayName: String
    var password: String

    var wins: Int
    var points: Int
    var gamesPlayed: Int

    var winPercentage: Double { Double(wins) / Double(gamesPlayed) }
    var pointsPerGame: Double { Double(points) / Double(gamesPlayed) }

    init(displayName: String, password: String) {
        self.displayName = displayName
        self.password = password

        (wins, points, gamesPlayed) = (0, 0, 0)
    }
}

// MARK: - Relations
extension User {

    var scores: Children<User, Score> { children(\.userID) }

}

// MARK: - PostgreSQLUUIDModel
extension User: PostgreSQLUUIDModel { }

// MARK: - Migration
extension User: Migration { }

// MARK: - Parameter
extension User: Parameter { }

// MARK: - Content
extension User: Content { }
