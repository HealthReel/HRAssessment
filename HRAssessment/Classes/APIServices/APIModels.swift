import Foundation

typealias AccessToken = String
typealias JSONDictionary = [String:Any]
typealias JSONArray = [JSONDictionary]

public struct HRCredentials {
    let apiKey: String
    let businessUniqueId: String
    let appUniqueId: String
    let callbackUrl: String
    
    public init(apiKey: String, businessUniqueId: String, appUniqueId: String, callbackUrl: String) {
        self.apiKey = apiKey
        self.businessUniqueId = businessUniqueId
        self.appUniqueId = appUniqueId
        self.callbackUrl = callbackUrl
    }
}

public struct PreviousReportDetails {
    let healthScore: Double
    let bodyFatPercentage: Double
    let bodyWeight: Double
    let cBMI: Double
    
    public init(healthScore: Double, bodyFatPercentage: Double, bodyWeight: Double, cBMI: Double) {
        self.healthScore = healthScore
        self.bodyFatPercentage = bodyFatPercentage
        self.bodyWeight = bodyWeight
        self.cBMI = cBMI
    }
}

struct AccessTokenResponse: Decodable {
    let message: String
    let data: [String: AccessToken]
}

struct HRReportRequest {
    var userReferenceID: String
    var dobTimestamp: Int
    var height: Double
    var gender: String
    var diabetic: Bool
    var race: Int

    var sdoh: JSONArray?
    var anxietyScore: Int?
    var depressionScore: Int?
    var stressScore: Int?

    var preEclampsia: JSONDictionary?

    var selfHealthReadiness: JSONArray
    var activityLevel: Int
    var weight: Double
    var lastReport: PreviousReportDetails?
    
    init(user: UserProfile, 
         sdoh: JSONArray? = nil,
         anxietyScore: Int? = nil,
         depressionScore: Int? = nil,
         stressScore: Int? = nil,
         preEclampsia: JSONDictionary? = nil,
         selfHealthReadiness: JSONArray,
         activityLevel: Int,
         weight: Double,
         lastReport: PreviousReportDetails? = nil) {
        self.userReferenceID = user.userReferenceID
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
        self.lastReport = lastReport
    }
}
