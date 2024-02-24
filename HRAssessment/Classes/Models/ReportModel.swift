import Foundation

public struct ReportModel: Codable {
    let summary: Summary
    let recommendations: Recommendations
    let activityMetabolismNutrition: ActivityMetabolismNutrition
    let socialRisk: SocialRisk
    let createdAt: String
}

public extension ReportModel {
    struct Summary: Codable {
        let healthScore: Double
        let healthScoreTrend: Trend
        let depressionCondition: String
        let anxietyCondition: String
        let stressCondition: String
        let bodyFatPercentage: Double
        let bodyFatPercentageTrend: Trend
        let CBMI: Double
        let CBMITrend: Trend
        let weight: Double
        let bodyWeightTrend: Trend
        let leanMass: Double
        let leanMassTrend: Trend
        let fatMass: Double
        let fatMassTrend: Trend
        let diabetes: Double
        let preEclampsiaCondition: String
    }
    
    struct Trend: Codable {
        let value: Double
        let growth: Int
        let change: Int
    }
}

public extension ReportModel {
    struct Recommendations: Codable {
        let idealBodyFatPercentage: Double
        let idealBodyWeight: Double
    }
}

public extension ReportModel {
    struct ActivityMetabolismNutrition: Codable {
        let AMR: Double
        let dailyCaloricIntake: Double
        let RMR: Double
        let idealCaloricIntake: Double
        let dailyCaloricDifference: Double
        let projectedWeeklyFatLoss: Double
        let carbsPercentage: Double
        let carbsInGrams: Double
        let fatPercentage: Double
        let fatInGrams: Double
        let proteinPercentage: Double
        let proteinInGrams: Double
    }
}

public extension ReportModel {
    struct SocialRisk: Codable {
        let housingInstability: String
        let foodInsecurity: String
        let financialStress: String
        let transportationBarriers: String
        let personalSafety: String
    }
}

public extension ReportModel.Trend {
    var hasIncreased: Bool { growth == 1 }
    var isPositive: Bool { change == 1 }
}

public extension ReportModel {
    enum Value {
        case number(Double)
        case text(String)
    }
    
    func valueFor(_ key: String) -> Value? {
        switch key {
        case "summary.healthScore": Value.number(summary.healthScore)
        case "summary.depressionCondition": Value.text(summary.depressionCondition)
        case "summary.anxietyCondition": Value.text(summary.anxietyCondition)
        case "summary.stressCondition": Value.text(summary.stressCondition)
        case "summary.bodyFatPercentage": Value.number(summary.bodyFatPercentage)
        case "summary.CBMI": Value.number(summary.CBMI)
        case "summary.weight": Value.number(summary.weight)
        case "summary.leanMass": Value.number(summary.leanMass)
        case "summary.fatMass": Value.number(summary.fatMass)
        case "summary.diabetes": Value.number(summary.diabetes)
        case "summary.preEclampsiaCondition": Value.text(summary.preEclampsiaCondition)

        case "recommendations.idealBodyFatPercentage": Value.number(recommendations.idealBodyFatPercentage)
        case "recommendations.idealBodyWeight": Value.number(recommendations.idealBodyWeight)

        case "activityMetabolismNutrition.projectedWeeklyFatLoss": Value.number(activityMetabolismNutrition.projectedWeeklyFatLoss)
        case "activityMetabolismNutrition.dailyCaloricDifference":
            Value.number(activityMetabolismNutrition.dailyCaloricDifference)
        case "activityMetabolismNutrition.AMR": Value.number(activityMetabolismNutrition.AMR)
        case "activityMetabolismNutrition.RMR": Value.number(activityMetabolismNutrition.RMR)
        case "activityMetabolismNutrition.idealCaloricIntake": Value.number(activityMetabolismNutrition.idealCaloricIntake)
        case "activityMetabolismNutrition.carbsInGrams": Value.number(activityMetabolismNutrition.carbsInGrams)
        case "activityMetabolismNutrition.fatInGrams": Value.number(activityMetabolismNutrition.fatInGrams)
        case "activityMetabolismNutrition.proteinInGrams": Value.number(activityMetabolismNutrition.proteinInGrams)

        case "socialRisk.housingInstability": Value.text(socialRisk.housingInstability)
        case "socialRisk.foodInsecurity": Value.text(socialRisk.foodInsecurity)
        case "socialRisk.financialStress": Value.text(socialRisk.financialStress)
        case "socialRisk.transportationBarriers": Value.text(socialRisk.transportationBarriers)
        case "socialRisk.personalSafety": Value.text(socialRisk.personalSafety)

        default: nil
        }
    }
    
    func trendFor(_ key: String) -> Trend? {
        switch key {
        case "summary.healthScoreTrend": summary.healthScoreTrend
        case "summary.bodyFatPercentageTrend": summary.bodyFatPercentageTrend
        case "summary.CBMITrend": summary.CBMITrend
        case "summary.bodyWeightTrend": summary.bodyWeightTrend
        case "summary.leanMassTrend": summary.leanMassTrend
        case "summary.fatMassTrend": summary.fatMassTrend
            
        default: nil
        }
    }
}
