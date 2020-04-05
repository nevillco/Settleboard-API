import Vapor
import Fluent

// MARK: - MatchController
final class MatchController { }

// MARK: - Actions
extension MatchController {

    /// Creates a new Match.
    func create(_ request: Request, _ input: CreateMatchInput) throws -> Future<[MatchUser]> {
        return validate(input, on: request)
            .flatMap { self.fetchUserValues(for: $0, on: request) }
            .and(Match().create(on: request).map { try $0.requireID() })
            .flatMap { tuple -> Future<[MatchUser]> in
                let (userValues, matchID) = tuple
                return request.eventLoop.future(userValues)
                    .flatMap { userValues -> Future<[MatchUser]> in
                        return userValues.map { tuple -> Future<MatchUser> in
                            let (userID, value) = tuple
                            return MatchUser(matchID: matchID, userID: userID, value: value).create(on: request)
                        }
                        .flatten(on: request)
                }
        }
    }
//
//    /// Gets the most recent matches, paginated.
//    func getRecent(_ request: Request) throws -> Future<[RecentMatchOutput]> {
//        let offset: Int = try request.query.get(at: "offset")
//        let size: Int = try request.query.get(at: "size")
//        return Match.query(on: request)
//            .sort(\.createdAt)
//            .range(offset..<(offset + size))
//            .all()
//            .flatMap { matches -> Future<[RecentMatchOutput]> in
//                return try matches.map { match -> Future<RecentMatchOutput> in
//                    let matchID = try match.requireID()
//                    return try match.scores.query(on: request).all()
//                        .map { scores in RecentMatchOutput(matchID: matchID, scores: scores) }
//                }
//                .flatten(on: request)
//        }
//    }

}

// MARK: - RouteCollection
extension MatchController: RouteCollection {

    func boot(router: Router) throws {
        let matches = router.grouped("matches")
        matches.post(CreateMatchInput.self, use: create)
//        matches.get("recent", use: getRecent)
    }

}

// MARK: - Private
extension MatchController {

    func validate(_ input: CreateMatchInput, on worker: Worker) -> Future<CreateMatchInput> {
        worker.eventLoop.future(input)
            .validate(
                (3...4).contains(input.scores.count),
                errorReason: "Detected some number of scores other than 3 or 4.")
            .validate(
                input.scores.filter { $0.value >= 10 }.count == 1,
                errorReason: "Exactly 1 specified score must be over 10.")
            .validate(
                input.scores.allSatisfy { $0.value >= 2 },
                errorReason: "All scores should be greater than 2.")
    }

    typealias FetchedValue = (User.ID, Int)
    func fetchUserValues(
        for input: CreateMatchInput,
        on worker: Worker & DatabaseConnectable) -> Future<[FetchedValue]> {
        input.scores.map { tuple -> Future<FetchedValue> in
            let (userIDString, value) = tuple
            return worker.eventLoop.newSucceededFuture(result: userIDString)
                .map(UUID.init(uuidString:))
                .unwrap(or: Abort(.badRequest, reason: "An invalid UUID was passed."))
                .flatMap { User.find($0, on: worker) }
                .unwrap(or: Abort(.badRequest, reason: "No user was found for one of the given IDs."))
                .map { (try $0.requireID(), value) }
        }
        .flatten(on: worker)
    }

}
