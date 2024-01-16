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
            SelfHealthReadinessQuestion("1", "Are you ready and committed to adopt a routine that will improve your long-term health?"),
            SelfHealthReadinessQuestion("2", "How knowledgeable are you in regard to caloric intake, caloric deicit, and macronutrient information?"),
            SelfHealthReadinessQuestion("3", "Do you understand exercise requirement when it comes to long-term health benefits. Specifically exercise frequency, duration and intensity?"),
            SelfHealthReadinessQuestion("4", "How knowledgeable are you when it comes to sleep and recovery?"),
            SelfHealthReadinessQuestion("5", "The most important variable in our long-term health is support. Do you feel mentally, emotionally and physically supported?"),
        ]
    }
}
