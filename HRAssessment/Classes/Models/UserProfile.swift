import Foundation

public struct UserProfile {
    let userReferenceID: String = "000"
    let dob: Int
    let gender: Gender
    let height: CGFloat
    var diabetic: Bool
    var race: Race
    var lastHealthScore: CGFloat?
    var lastBodyFatPercentage: CGFloat?
    var lastBodyWeight: CGFloat?
    var lastCBMI: CGFloat?

    var json: [String: Any] {
        var json: [String: Any] = [
            "reportType": "2",
            "userReferenceID": userReferenceID,
            "dob": dob,
            "gender": gender.rawValue,
            "height": height,
            "diabetic": diabetic,
            "race": race
        ]

        if let lastBodyFatPercentage {
            json["lastBodyFatPercentage"] = lastBodyFatPercentage
        }
        if let lastHealthScore {
            json["lastHealthScore"] = lastHealthScore
        }
        if let lastBodyWeight {
            json["lastBodyWeight"] = lastBodyWeight
        }
        if let lastCBMI {
            json["lastCBMI"] = lastCBMI
        }
        
        return json
    }
    
    public init(dob: Int, gender: Gender, height: CGFloat, diabetic: Bool, race: Race, lastHealthScore: CGFloat? = nil, lastBodyFatPercentage: CGFloat? = nil, lastBodyWeight: CGFloat? = nil, lastCBMI: CGFloat? = nil) {
        self.dob = dob
        self.gender = gender
        self.height = height
        self.diabetic = diabetic
        self.race = race
        self.lastHealthScore = lastHealthScore
        self.lastBodyFatPercentage = lastBodyFatPercentage
        self.lastBodyWeight = lastBodyWeight
        self.lastCBMI = lastCBMI
    }
}

public extension UserProfile {
    enum Race: String {
        case asian
    }

    enum Gender: String {
        case male = "male"
        case female = "female"
    }
}
