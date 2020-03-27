import Fluent
import Vapor
import FluentPostgreSQL

// MARK: - Match
final class Match {

    var id: UUID?

    init() { }

}

// MARK: - Relations
extension Match {

    var scores: Children<Match, Score> { children(\.matchID) }

}

// MARK: - Migration
extension Match: Migration { }

// MARK: - PostgreSQLUUIDModel
extension Match: PostgreSQLUUIDModel { }

// MARK: - Content
extension Match: Content { }
