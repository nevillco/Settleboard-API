import Authentication
import Vapor
import Foundation
import FluentPostgreSQL

// TODO: duplicate displayName validation
// MARK: - User
final class User {

    var id: UUID?
    var displayName: String
    var password: String

    var wins: Int { didSet { recalculateStatistics() } }
    var points: Int { didSet { recalculateStatistics() } }
    var gamesPlayed: Int { didSet { recalculateStatistics() } }

    var winPercentage: Double
    var pointsPerGame: Double

    init(displayName: String, password: String) {
        self.displayName = displayName
        self.password = password

        (wins, points, gamesPlayed) = (0, 0, 0)
        (winPercentage, pointsPerGame) = (0, 0)
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

// MARK: - BasicAuthenticatable
extension User: BasicAuthenticatable {

    static var usernameKey: WritableKeyPath<User, String> { \.displayName }
    static var passwordKey: WritableKeyPath<User, String> { \.password }

}

// MARK: - Private
private extension User {

    func recalculateStatistics() {
        winPercentage = Double(wins) / Double(gamesPlayed)
        pointsPerGame = Double(points) / Double(gamesPlayed)
    }

}
