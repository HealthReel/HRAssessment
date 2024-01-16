import Foundation


typealias DASSResponse = DASSQuestion.Option
typealias DASSResponses = [DASSQuestion: DASSResponse]
typealias DASSScore = (depression: Int, anxiety: Int, stress: Int)

struct DASSQuestion: Hashable {
    enum Option: Int {
        case zero, one, two, three
    }

    enum QuestionType {
        case stress, anxiety, depression
    }

    let title: String
    let type: QuestionType
}

extension DASSResponses {
    var dassScore: DASSScore? {
        if isEmpty {
            return nil
        }
        
        let depressionScore = self
            .filter({ $0.key.type == .depression })
            .map { _ , dassResponse in
                dassResponse.rawValue
        }.reduce(0, +) * 2

        let stressScore = self
            .filter({ $0.key.type == .stress })
            .map { _ , dassResponse in
                dassResponse.rawValue
        }.reduce(0, +) * 2

        let anxientyScore = self
            .filter({ $0.key.type == .anxiety })
            .map { _ , dassResponse in
                dassResponse.rawValue
        }.reduce(0, +) * 2

        return (depressionScore, stressScore, anxientyScore)
    }
}

extension DASSQuestion {
    static var `default`: [DASSQuestion] {
        return [
            DASSQuestion(title: String(localizedKey: "dass.q1"), type: .stress),
            DASSQuestion(title: String(localizedKey: "dass.q2"), type: .anxiety),
            DASSQuestion(title: String(localizedKey: "dass.q3"), type: .depression),
            DASSQuestion(title: String(localizedKey: "dass.q4"), type: .anxiety),
            DASSQuestion(title: String(localizedKey: "dass.q5"), type: .depression),
            DASSQuestion(title: String(localizedKey: "dass.q6"), type: .stress),
            DASSQuestion(title: String(localizedKey: "dass.q7"), type: .anxiety),
            DASSQuestion(title: String(localizedKey: "dass.q8"), type: .stress),
            DASSQuestion(title: String(localizedKey: "dass.q9"), type: .anxiety),
            DASSQuestion(title: String(localizedKey: "dass.q10"), type: .depression),
            DASSQuestion(title: String(localizedKey: "dass.q11"), type: .stress),
            DASSQuestion(title: String(localizedKey: "dass.q12"), type: .stress),
            DASSQuestion(title: String(localizedKey: "dass.q13"), type: .depression),
            DASSQuestion(title: String(localizedKey: "dass.q14"), type: .stress),
            DASSQuestion(title: String(localizedKey: "dass.q15"), type: .anxiety),
            DASSQuestion(title: String(localizedKey: "dass.q16"), type: .depression),
            DASSQuestion(title: String(localizedKey: "dass.q17"), type: .depression),
            DASSQuestion(title: String(localizedKey: "dass.q18"), type: .stress),
            DASSQuestion(title: String(localizedKey: "dass.q19"), type: .anxiety),
            DASSQuestion(title: String(localizedKey: "dass.q20"), type: .anxiety),
            DASSQuestion(title: String(localizedKey: "dass.q21"), type: .depression),
        ]
    }
}
