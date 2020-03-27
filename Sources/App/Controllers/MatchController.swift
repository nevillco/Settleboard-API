import Vapor
import Fluent

// MARK: - MatchController
final class MatchController { }

// MARK: - Actions
extension MatchController {

    /// Creates a new User.
    func create(_ request: Request, _ input: CreateMatchInput) throws -> Future<Match> {
        return Match().save(on: request)
            .thenThrowing { match -> (Match, Match.ID) in
                guard let matchID = match.id else { throw Abort(.internalServerError) }
                return (match, matchID)
        }.flatMap { match, matchID -> Future<Match> in
            return input.scores.map { (userIDString, value) -> Future<Score> in
                // TODO: failure handling
                let userID = UUID(userIDString)!
                return Score(value: value, isVictory: value >= 10, userID: userID, matchID: matchID)
                    .create(on: request)
            }
            .flatten(on: request)
            .map { _ in match }
        }
    }

}

// MARK: - RouteCollection
extension MatchController: RouteCollection {

    func boot(router: Router) throws {
        let matches = router.grouped("matches")
        matches.post(CreateMatchInput.self, use: create)
    }

}
