import Authentication
import Crypto
import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let unauthenticatedRouter = router
    let router = unauthenticatedRouter.grouped(User.basicAuthMiddleware(using: BCrypt.self), User.guardAuthMiddleware())

    let userController = UserController()
    try userController.boot(router: router)
    try userController.bootWithoutAuth(router: unauthenticatedRouter)

    let authenticatedCollections: [RouteCollection] = [
        MatchController(),
        LeaderboardController(),
    ]
    try authenticatedCollections.forEach { try router.register(collection: $0) }

}
