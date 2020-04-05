import Fluent
import Vapor
import FluentPostgreSQL

// MARK: - Match
final class Match {

    var id: UUID?
    var createdAt: Date?

    init() { }

}

// MARK: - Relations
extension Match {

    var users: Siblings<Match, User, MatchUser> { siblings() }

}

// MARK: - Migration
extension Match: Migration { }

// MARK: - PostgreSQLUUIDModel
extension Match: PostgreSQLUUIDModel {

    static var createdAtKey: WritableKeyPath<Match, Date?>? { \.createdAt }

}

// MARK: - Content
extension Match: Content { }
