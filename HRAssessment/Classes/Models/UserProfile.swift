import Foundation

public struct UserProfile {
    let userReferenceID: String
    var dob: Int
    var gender: Gender
    var height: CGFloat
    var diabetic: Bool
    var race: Race
    
    public init(userReferenceID: String,
                dob: Int = .zero,
                gender: Gender = .female,
                height: CGFloat = .nan,
                diabetic: Bool = false,
                race: Race = .Other) {
        self.userReferenceID = userReferenceID
        self.dob = dob
        self.gender = gender
        self.height = height
        self.diabetic = diabetic
        self.race = race
    }
}

public extension UserProfile {
    enum Race: Int, CaseIterable {
      case White = 1
      case Black
      case Hispanic
      case Asian
      case Multiracial
      case Other
        
        var stringValue: String {
            switch self {
            case .White: "White"
            case .Black: "Black"
            case .Hispanic: "Hispanic"
            case .Asian: "Asian"
            case .Multiracial: "Multiracial"
            case .Other: "Other"
            }
        }
        
        public init(stringValue: String) {
            self = switch stringValue {
            case "White": .White
            case "Black": .Black
            case "Hispanic": .Hispanic
            case "Asian": .Asian
            case "Multiracial": .Multiracial
            default: .Other
            }
        }
    }

    enum Gender: String, CaseIterable {
        case male = "male"
        case female = "female"
        
        public static var allCases: [Self] {
            [.male, .female]
        }
    }
}
