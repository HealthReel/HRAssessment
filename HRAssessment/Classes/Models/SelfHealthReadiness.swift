import Foundation

typealias SelfHealthReadinessResponse = Int
typealias SelfHealthReadinessResponses = [SelfHealthReadinessQuestion: SelfHealthReadinessResponse]

struct SelfHealthReadinessQuestion: Hashable {
    let number: String
    let question: String

    init(_ number: String, _ question: String) {
        self.number = number
        self.question = question
    }
}

extension SelfHealthReadinessResponses {
    var json: [[String: Any]] {
        var questionDict: [[String: Any]] = []
        forEach { selfHealthQuestion, response in
            var dict: [String: Any] = [:]
            dict["question"] = selfHealthQuestion.question
            dict["answer"] = response
            dict["options"] = (1...10).map({ $0.description })
            questionDict.append(dict)
        }

        return questionDict
    }
}

extension SelfHealthReadinessQuestion {
    static var `default`: [SelfHealthReadinessQuestion] {
        return [
            SelfHealthReadinessQuestion(
                "1",
                String(localizedKey: "self_health_readiness.q1")
            ),
            SelfHealthReadinessQuestion(
                "2",
                String(localizedKey: "self_health_readiness.q2")
            ),
            SelfHealthReadinessQuestion(
                "3",
                String(localizedKey: "self_health_readiness.q3")
            ),
            SelfHealthReadinessQuestion(
                "4",
                String(localizedKey: "self_health_readiness.q4")
            ),
            SelfHealthReadinessQuestion(
                "5",
                String(localizedKey: "self_health_readiness.q5")
            ),
        ]
    }
}
