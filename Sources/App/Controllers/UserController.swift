import Crypto
import Vapor
import Fluent
import FluentPostgreSQL

// MARK: - UserController
final class UserController { }

// MARK: - Actions
extension UserController {

    /// Gets all Users.
    func getAll(_ request: Request) throws -> Future<[User]> {
        return User.query(on: request).all()
    }

    /// Gets a User by their ID.
    func getByID(_ request: Request) throws -> Future<User> {
        return try request.parameters.next(User.self)
    }

    /// Gets all recent Matches for a given User.
    func recentMatches(_ request: Request) throws -> Future<MatchesOutput> {
        return try request.parameters.next(User.self).flatMap { user in
            request.withPooledConnection(to: .psql) { (connection: PostgreSQLConnection) -> EventLoopFuture<MatchesOutput> in
                    return connection.raw(Queries.recentMatches(userID: try user.requireID()))
                        .all(decoding: SQLMatchItemOutput.self)
                        .map(MatchesOutput.init)
            }
        }
    }

    /// Creates a new User.
    func create(_ request: Request, _ input: AuthenticateUserInput) throws -> Future<CredentialOutput> {
        return User.query(on: request)
            .filter(\.displayName == input.displayName)
            .first()
            .flatMap { user in
                switch user {
                case .some:
                    throw Abort(.badRequest, reason: "Display name is already taken.")
                case nil:
                    let digest = try request.make(BCryptDigest.self)
                    let hashedPassword = try digest.hash(input.password)
                    let user = User(displayName: input.displayName, password: hashedPassword)
                    return user.create(on: request).map { user in
                        CredentialOutput(displayName: user.displayName, id: try user.requireID())
                    }
                }
        }
    }

    /// Validates an existing User’s credentials.
    func authenticate(_ request: Request, _ input: AuthenticateUserInput) throws -> Future<CredentialOutput> {
        return User.query(on: request)
            .filter(\.displayName == input.displayName)
            .first()
            .unwrap(or: Abort(.badRequest, reason: "Display name not found."))
            .map { CredentialOutput(displayName: $0.displayName, id: try $0.requireID()) }
    }

    /// Checks whether a given display name is already in use or not.
    func checkDisplayName(_ request: Request) throws -> Future<CheckDisplayNameOutput> {
        let input: String = try request.query.get(at: "displayName")
        return User.query(on: request)
            .filter(\.displayName == input)
            .first()
            .map { user in .init(exists: user != nil) }
    }

    /// Deletes a User.
    func delete(_ request: Request) throws -> Future<HTTPStatus> {
        return try request.parameters.next(User.self).delete(on: request).transform(to: .noContent)
    }

}

// MARK: - RouteCollection
extension UserController: RouteCollection {

    func boot(router: Router) throws {
        let users = router.grouped("users")
        users.get(User.parameter, use: getByID)
        users.post(AuthenticateUserInput.self, at: "authenticate", use: authenticate)
        users.delete(User.parameter, use: delete)

        let recentMatches = router.grouped("users", User.parameter, "recent")
        recentMatches.get(use: self.recentMatches)
    }

    func bootWithoutAuth(router: Router) throws {
        let users = router.grouped("users")
        users.post(AuthenticateUserInput.self, use: create)
        users.get(use: getAll)
        users.get("exists", use: checkDisplayName)
    }
    
}

// MARK: - Private
private extension UserController {

    static let group = "users"

}
