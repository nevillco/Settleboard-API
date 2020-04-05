import Vapor

// MARK: - SQLMatchItemOutput
final class SQLMatchItemOutput: Content {

    let userID: String
    let displayName: String
    let matchID: String
    let matchDate: Date
    let points: Int

}
