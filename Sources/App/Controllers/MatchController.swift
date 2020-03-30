import Vapor
import Fluent

// MARK: - MatchController
final class MatchController { }

// MARK: - Actions
extension MatchController {

    // TODO: validate ALL UUIDs and get Users before any mutations
    // TODO: better error handling, 3-4p validation, win condition validation

    /// Creates a new Match.
    func create(_ request: Request, _ input: CreateMatchInput) throws -> Future<[Score]> {
        return Match().create(on: request)
            .map { try $0.requireID() }
            .flatMap { matchID -> Future<[(User, Score)]> in
                input.scores.map { (arg) -> Future<(User, Score)> in
                    let (userIDString, value) = arg
                    return request.eventLoop.newSucceededFuture(result: userIDString)
                        .map(UUID.init(uuidString:))
                        .unwrap(or: Abort(.badRequest))
                        .flatMap { User.find($0, on: request) }
                        .unwrap(or: Abort(.badRequest))
                        .flatMap { (user: User) -> Future<(User, Score)> in
                            let isVictory = value >= 10
                            user.wins += (isVictory ? 1 : 0)
                            user.gamesPlayed += 1
                            user.points += value
                            let score = Score(
                                value: value,
                                isVictory: isVictory,
                                userID: try user.requireID(),
                                matchID: matchID)
                            return user.update(on: request)
                                .and(score.create(on: request))
                    }
                }
                .flatten(on: request)
        }
        .map { $0.map { $0.1 } }
    }

    func createMatch(_ request: Request, _ input: CreateMatchInput) throws -> Future<[(User, Score)]> {
        return validate(input)
            .flatMap { self.fetchUserValues(for: $0) }
            .and(Match().create(on: request).map { try $0.requireID() })
            .flatMap { (tuple1: ([FetchedValue], Match.ID)) -> Future<[(User, Score)]> in
                let (userValues, matchID) = tuple1
                return request.eventLoop.future(userValues)
                    .flatMap { userValues -> Future<[(User, Score)]> in
                        return userValues.map { tuple -> Future<(User, Score)> in
                            let (user, userID, value) = tuple
                            let isVictory = value >= 10
                            user.wins += (isVictory ? 1 : 0)
                            user.gamesPlayed += 1
                            user.points += value
                            let score = Score(
                                value: value,
                                isVictory: isVictory,
                                userID: userID,
                                matchID: matchID)
                            return user.update(on: request)
                                .and(score.create(on: request))
                        }
                        .flatten(on: request)
                }
        }
    }
    /// Gets the N most recent matches, where N is part of the parameterized request path.
    func getRecent(_ request: Request) throws -> Future<[RecentMatchOutput]> {
        let limit = try request.parameters.next(Int.self)
        return Match.query(on: request)
            .sort(\.createdAt)
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

// MARK: - Private
extension MatchController {

    // TODO: implement and use

    func validate(_ input: CreateMatchInput) -> Future<CreateMatchInput> {
        fatalError()
    }

    typealias FetchedValue = (User, User.ID, Int)
    func fetchUserValues(for input: CreateMatchInput) -> Future<[FetchedValue]> {
        fatalError()
    }

}
