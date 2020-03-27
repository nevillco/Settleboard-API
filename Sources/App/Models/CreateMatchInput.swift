import Vapor

// MARK: - CreateMatchInput
final class CreateMatchInput {

    let scores: [String: Int]

    init(scores: [String: Int]) {
        self.scores = scores
    }

}

// MARK: - Content
extension CreateMatchInput: Content { }
