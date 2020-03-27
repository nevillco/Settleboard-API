import Vapor

// MARK: - RecentMatchOutput
final class RecentMatchOutput {

    let matchID: UUID
    let scores: [Score]

    init(matchID: UUID, scores: [Score]) {
        self.matchID = matchID
        self.scores = scores
    }

}

// MARK: - Content
extension RecentMatchOutput: Content { }
