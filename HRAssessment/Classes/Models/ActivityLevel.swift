import Foundation

enum ActivityLevel: Int, CaseIterable {
    case sedentary = 1
    case lightlyActive = 2
    case moderatelyActive = 3
    case veryActive = 4
    case extremelyActive = 5
}

extension ActivityLevel {
    var text: (title: String, subtitle: String) {
        switch self {
        case .sedentary: return
            ("Sedentary",
             "Little or no exrecise, desk job"
            )
        case .lightlyActive: return
            ("Lightly Active",
             "Exercise 30 minutes or less 1 to 3 times a week"
            )
        case .moderatelyActive: return
            ("Moderately Active",
             "Exercise 30 minutes or less 3-5 times a week"
            )
        case .veryActive: return
            ("Very Active",
             "Exercising 60 minutes or less 3-5 days a week"
            )
        case .extremelyActive: return
            ("Extremely Active",
             "Professional athelete or individuals doing 2 workouts a day or workouts 90 min+ 6 days a week"
            )
        }
    }

    var value: Int {
        rawValue
    }
}
