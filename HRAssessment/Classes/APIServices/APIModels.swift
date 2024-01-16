import Foundation

typealias AccessToken = String
typealias JSONDictionary = [String:Any]
typealias JSONArray = [JSONDictionary]

struct AccessTokenResponse: Decodable {
    let message: String
    let data: [String: AccessToken]
}

struct HRReportRequest {
    var dobTimestamp: Int
    var height: Double
    var gender: String
    var diabetic: Bool
    var race: String

    var sdoh: JSONArray?
    var anxietyScore: Int?
    var depressionScore: Int?
    var stressScore: Int?

    var preEclampsia: JSONDictionary?

    var selfHealthReadiness: JSONArray
    var activityLevel: Int
    var weight: Double
    
    init(user: UserProfile, 
         sdoh: JSONArray? = nil,
         anxietyScore: Int? = nil,
         depressionScore: Int? = nil,
         stressScore: Int? = nil,
         preEclampsia: JSONDictionary? = nil,
         selfHealthReadiness: JSONArray,
         activityLevel: Int,
         weight: Double) {
        self.dobTimestamp = user.dob
        self.height = user.height
        self.gender = user.gender.rawValue
        self.diabetic = user.diabetic
        self.race = user.race.rawValue
        self.sdoh = sdoh
        self.anxietyScore = anxietyScore
        self.depressionScore = depressionScore
        self.stressScore = stressScore
        self.preEclampsia = preEclampsia
        self.selfHealthReadiness = selfHealthReadiness
        self.activityLevel = activityLevel
        self.weight = weight
    }
}
