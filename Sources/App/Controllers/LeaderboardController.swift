import Vapor
import Fluent
import FluentPostgreSQL

// MARK: - LeaderboardController
final class LeaderboardController { }

// MARK: - Actions
extension LeaderboardController {

    /// Gets the leaderboard of players, in preferred order, paginated.
    func leaderboard(_ request: Request) throws -> Future<[LeaderboardOutput]> {
        request.withPooledConnection(to: .psql) { (connection: PostgreSQLConnection) -> EventLoopFuture<[LeaderboardOutput]> in
            return connection.raw(Queries.leaderboard)
                .all(decoding: LeaderboardOutput.self)
        }
    }

}

// MARK: - RouteCollection
extension LeaderboardController: RouteCollection {

    func boot(router: Router) throws {
        let matches = router.grouped("leaderboard")
        matches.get(use: leaderboard)
    }

}
