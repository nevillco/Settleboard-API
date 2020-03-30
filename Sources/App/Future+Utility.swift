import Vapor

extension Future {

    func validate(_ condition: Bool, errorReason: String) -> Future<T> {
        return self.thenThrowing { (value: T) -> T in
            guard condition else { throw Abort(.badRequest, reason: errorReason) }
            return value
        }
    }

}
