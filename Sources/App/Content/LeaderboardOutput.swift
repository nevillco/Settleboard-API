import Vapor

// MARK: - LeaderboardOutput
final class LeaderboardOutput {

    let displayName: String

    let gamesPlayed: Int
    let wins: Int
    let winPercentage: Double
    let points: Int
    let pointsPerGame: Double

    init(
        displayName: String,
        gamesPlayed: Int,
        wins: Int,
        winPercentage: Double,
        points: Int,
        pointsPerGame: Double) {
        self.displayName = displayName
        self.gamesPlayed = gamesPlayed
        self.wins = wins
        self.winPercentage = winPercentage
        self.points = points
        self.pointsPerGame = pointsPerGame
    }

}

// MARK: - Content
extension LeaderboardOutput: Content { }
