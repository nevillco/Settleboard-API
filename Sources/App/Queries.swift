import Foundation
import Vapor

public enum Queries {
    
    static let leaderboard: String =
    """
    SELECT

    "User"."displayName" AS "displayName",
    Count(*) AS "gamesPlayed",
    Count("Match_User"."isVictory" or NULL) AS "wins",
    Cast (Count("Match_User"."isVictory" or NULL) as float) / Count(*) AS "winPercentage",
    Avg("Match_User"."value") AS "pointsPerGame",
    SUM("Match_User"."value") AS "points"

    FROM "Match_User"
    FULL JOIN "User" ON "User"."id"="Match_User"."userID"
    GROUP BY "displayName"
    HAVING Count(*) >= 3
    ORDER BY "winPercentage" DESC, "pointsPerGame" DESC;
    """

    static func recentMatches(userID: User.ID) -> String {
        """
        SELECT

        U."displayName" AS "displayName",
        U."id" AS "userID",
        MUS."matchID" AS "matchID",
        M."createdAt" AS "matchDate",
        MUS."value" AS "points"

        FROM "Match_User" AS MU
        INNER JOIN "Match" AS M ON M."id"=MU."matchID"
        INNER JOIN "Match_User" AS MUS ON MUS."matchID"=M."id"
        INNER JOIN "User" AS U ON U."id"=MUS."userID"
        WHERE MU."userID"='aaa0d482-99a5-4842-aff5-907bdc640701'
        ORDER BY "matchDate" DESC, "points" DESC;
        """
    }

}
