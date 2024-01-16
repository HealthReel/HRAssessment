import Foundation

typealias SocialNeedsResponse = SocialNeedsQuestion.Option
typealias SocialNeedsResponses = [SocialNeedsQuestion: SocialNeedsResponse]

struct SocialNeedsQuestion: Hashable {
    enum Option: String.LocalizationValue {
    case yes = "socialneeds.option.yes"
    case no = "socialneeds.option.no"
    case neverTrue = "socialneeds.option.neverTrue"
    case sometimesTrue = "socialneeds.option.sometimesTrue"
    case oftenTrue = "socialneeds.option.oftenTrue"
    case alreadyShutOff = "socialneeds.option.alreadyShutOff"
    case never = "socialneeds.option.never"
    case rarely = "socialneeds.option.rarely"
    case sometimes = "socialneeds.option.sometimes"
    case often = "socialneeds.option.often"
    case always = "socialneeds.option.always"
    }

    let category: String
    let question: String
    let subtext: String?
    let options: [Option]

    init(category: String,
         question: String,
         subtext: String? = nil,
         options: [Option]) {
        self.category = category
        self.question = question
        self.subtext = subtext
        self.options = options
    }
}

extension SocialNeedsResponses {
    var json: [[String: Any]] {
        var questionDict: [[String: Any]] = []
        forEach { socialNeed, selectedOption in
            var dict: [String: Any] = [:]
            dict["question"] = socialNeed.question
            dict["answer"] = String(localizedKey: selectedOption.rawValue)
            dict["options"] = socialNeed.options.map { String(localizedKey: $0.rawValue) }

            questionDict.append(dict)
        }
        return questionDict
    }
}

extension SocialNeedsQuestion {
    static var `default`: [SocialNeedsQuestion] {
        return [
            SocialNeedsQuestion(category: String(localizedKey: "socialneeds.housing.title"),
                            question: String(localizedKey: "socialneeds.housing.q1"),
                            options: [.yes, .no]),
            SocialNeedsQuestion(category: String(localizedKey: "socialneeds.housing.title"),
                            question: String(localizedKey: "socialneeds.housing.q2"),
                            subtext: String(localizedKey: "socialneeds.housing.q2.subtext"),
                            options: [.yes, .no]),
            SocialNeedsQuestion(category: String(localizedKey: "socialneeds.food.title"),
                            question: String(localizedKey: "socialneeds.food.q1"),
                            options: [.neverTrue, .sometimesTrue, .oftenTrue]),
            SocialNeedsQuestion(category: String(localizedKey: "socialneeds.food.title"),
                            question: String(localizedKey: "socialneeds.food.q2"),
                            options: [.neverTrue, .sometimesTrue, .oftenTrue]),
            SocialNeedsQuestion(category: String(localizedKey: "socialneeds.transportation.title"),
                            question: String(localizedKey: "socialneeds.transportation.q1"),
                            options: [.yes, .no]),
            SocialNeedsQuestion(category: String(localizedKey: "socialneeds.utilities.title"),
                            question: String(localizedKey: "socialneeds.utilities.q1"),
                            options: [.yes, .no, .alreadyShutOff]),
            SocialNeedsQuestion(category: String(localizedKey: "socialneeds.childCare.title"),
                            question: String(localizedKey: "socialneeds.childCare.Q1"),
                            options: [.yes, .no]),
            SocialNeedsQuestion(category: String(localizedKey: "socialneeds.employment.title"),
                            question: String(localizedKey: "socialneeds.employment.q1"),
                            options: [.yes, .no]),
            SocialNeedsQuestion(category: String(localizedKey: "socialneeds.education.title"),
                            question: String(localizedKey: "socialneeds.education.q1"),
                            options: [.yes, .no]),
            SocialNeedsQuestion(category: String(localizedKey: "socialneeds.finances.title"),
                            question: String(localizedKey: "socialneeds.finances.q1"),
                            options: [.never, .rarely, .sometimes, .often, .always]),
            SocialNeedsQuestion(category: String(localizedKey: "socialneeds.personalSafety.title"),
                            question: String(localizedKey: "socialneeds.personalSafety.q1"),
                            options: [.never, .rarely, .sometimes, .often, .always]),
            SocialNeedsQuestion(category: String(localizedKey: "socialneeds.personalSafety.title"),
                            question: String(localizedKey: "socialneeds.personalSafety.q2"),
                            options: [.never, .rarely, .sometimes, .often, .always]),
            SocialNeedsQuestion(category: String(localizedKey: "socialneeds.personalSafety.title"),
                            question: String(localizedKey: "socialneeds.personalSafety.q3"),
                            options: [.never, .rarely, .sometimes, .often, .always]),
            SocialNeedsQuestion(category: String(localizedKey: "socialneeds.personalSafety.title"),
                            question: String(localizedKey: "socialneeds.personalSafety.q4"),
                            options: [.never, .rarely, .sometimes, .often, .always]),
            SocialNeedsQuestion(category: String(localizedKey: "socialneeds.assisstance.title"),
                            question: String(localizedKey: "socialneeds.assisstance.q1"),
                            options: [.yes, .no])
        ]
    }
}
