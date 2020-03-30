import Vapor
import Fluent

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

    /// Creates a new User.
    func create(_ request: Request, _ input: CreateUserInput) throws -> Future<User> {
        let user = User(displayName: input.displayName, password: input.password)
        return user.create(on: request)
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
        users.post(CreateUserInput.self, use: create)
        users.get(use: getAll)
        users.get(User.parameter, use: getByID)
        users.delete(User.parameter, use: delete)
    }
    
}

// MARK: - Private
private extension UserController {

    static let group = "users"

}
