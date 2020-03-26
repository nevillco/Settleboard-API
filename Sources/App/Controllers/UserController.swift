import Vapor
import Fluent

// MARK: - UserCollection
final class UserController { }

// MARK: - Internal API
extension UserController {

    func index(_ request: Request) throws -> Future<[User]> {
        return User.query(on: request).all()
    }

    func show(_ request: Request) throws -> Future<User> {
        return try request.parameters.next(User.self)
    }
    
    func create(_ request: Request, _ user: User)throws -> Future<User> {
        return user.create(on: request)
    }

    func delete(_ request: Request) throws -> Future<HTTPStatus> {
        return try request.parameters.next(User.self).delete(on: request).transform(to: .noContent)
    }

}

// MARK: - RouteCollection
extension UserController: RouteCollection {

    func boot(router: Router) throws {
        let users = router.grouped(Self.group)
        users.post(User.self, use: create)
        users.get(use: index)
        users.get(User.parameter, use: show)
        users.delete(User.parameter, use: delete)
    }
    
}

// MARK: - Private
private extension UserController {

    static let group = "users"

}
