import Vapor
import Fluent

// MARK: - ScoreController
final class ScoreController { }

// MARK: - Actions
extension ScoreController {

    /// Gets all Scores for a given User.
    func getAll(_ request: Request) throws -> Future<[Score]> {
        return try request.parameters.next(User.self).flatMap { user in
            try user.scores.query(on: request).all()
        }
    }

}

// MARK: - RouteCollection
extension ScoreController: RouteCollection {

    func boot(router: Router) throws {
        let scoresForUser = router.grouped("users", User.parameter, "scores")
        scoresForUser.get(use: getAll)
    }

}
