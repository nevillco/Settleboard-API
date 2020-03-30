import Vapor
import Fluent

// MARK: - LeaderboardController
final class LeaderboardController { }

// MARK: - Actions
extension LeaderboardController {

    /// Gets the leaderboard of players, in preferred order, paginated.
    func leaderboard(_ request: Request) throws -> Future<[User]> {
        let offset: Int = try request.query.get(at: "offset")
        let size: Int = try request.query.get(at: "size")
        return User.query(on: request)
            .filter(\.gamesPlayed >= 3)
            .sort(\.winPercentage, .descending)
            .sort(\.pointsPerGame, .descending)
            .range(offset..<(offset + size))
            .all()
    }

}

// MARK: - RouteCollection
extension LeaderboardController: RouteCollection {

    func boot(router: Router) throws {
        let matches = router.grouped("leaderboard")
        matches.get(use: leaderboard)
    }

}
