import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let collections: [RouteCollection] = [
        UserController(),
        MatchController(),
        ScoreController(),
    ]
    try collections.forEach { try router.register(collection: $0) }

}
