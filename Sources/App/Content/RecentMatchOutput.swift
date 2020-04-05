import Vapor

final class RecentMatchOutput: Content {

    let userID: String
    let displayName: String
    let matchID: String
    let matchDate: Date
    let points: Int

}

// TODO: ensure clients have access to current user ID and display name on sign in or sign up.

final class StructuredMatchOutput: Content {

    final class Item: Content {

        let matchID: String
        let matchDate: Date
        var entries: [Entry]

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

        init(matchID: String, matchDate: Date, entry: Entry) {
            self.matchID = matchID
            self.matchDate = matchDate
            self.entries = [entry]
        }

    }

    let items: [Item]

    init(matches: [RecentMatchOutput]) {
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
