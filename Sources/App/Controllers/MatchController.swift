import Vapor
import Fluent

// MARK: - MatchController
final class MatchController { }

// MARK: - Actions
extension MatchController {

    /// Creates a new User.
    func create(_ request: Request, _ input: CreateMatchInput) throws -> Future<Match> {
        return Match().save(on: request)
            .flatMap { match -> Future<Match> in
                let matchID = try match.requireID()
                return input.scores.map { (userIDString, value) -> Future<Score> in
                    // TODO: failure handling, better isVictory
                    let userID = UUID(userIDString)!
                    return Score(value: value, isVictory: value >= 10, userID: userID, matchID: matchID)
                        .create(on: request)
                }
                .flatten(on: request)
                .map { _ in match }
            }
    }

    func getRecent(_ request: Request) throws -> Future<[RecentMatchOutput]> {
        let limit = try request.parameters.next(Int.self)
        return Match.query(on: request)
//            .sort(\.fluentCreatedAt)
            .range(..<limit)
            .all()
            .flatMap { matches -> Future<[RecentMatchOutput]> in
                return try matches.map { match -> Future<RecentMatchOutput> in
                    let matchID = try match.requireID()
                    return try match.scores.query(on: request).all()
                        .map { scores in RecentMatchOutput(matchID: matchID, scores: scores) }
                }
                .flatten(on: request)
        }
    }

}

// MARK: - RouteCollection
extension MatchController: RouteCollection {

    func boot(router: Router) throws {
        let matches = router.grouped("matches")
        matches.post(CreateMatchInput.self, use: create)
        matches.get("recent", Int.parameter, use: getRecent)
    }

}
