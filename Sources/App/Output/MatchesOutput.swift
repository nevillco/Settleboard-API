import Vapor

// MARK: - MatchesOutput
final class MatchesOutput: Content {

    let items: [Item]

    init(matches: [SQLMatchItemOutput]) {
        items = matches.reduce(into: [], { (result, output) in
            if let index = result.index(where: { $0.matchID == output.matchID }) {
                result[index].entries.append(.init(
                    userID: output.userID,
                    displayName: output.displayName,
                    points: output.points))
            } else {
                result.append(.init(
                    matchID: output.matchID,
                    matchDate: output.matchDate,
                    entry: .init(
                        userID: output.userID,
                        displayName: output.displayName,
                        points: output.points)))
            }
        })
    }

}

// MARK: - MatchesOutput.Item
extension MatchesOutput {

    final class Item: Content {

        let matchID: String
        let matchDate: Date
        var entries: [Entry]

        init(matchID: String, matchDate: Date, entry: Entry) {
            self.matchID = matchID
            self.matchDate = matchDate
            self.entries = [entry]
        }

    }

}

// MARK: - MatchesOutput.Item.Entry
extension MatchesOutput.Item {

    final class Entry: Content {

        let userID: String
        let displayName: String
        let points: Int

        init(userID: String, displayName: String, points: Int) {
            self.userID = userID
            self.displayName = displayName
            self.points = points
        }

    }

}
