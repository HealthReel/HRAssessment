import Foundation

struct HealthReport {
    let data: [CategorisedReport]
}
 
extension HealthReport {
    static func fullReport(for report: ReportModel) -> Self {
        .init(data: [
            .overallHealthStatus,
            .bodyCompositionSummary,
            .metabolismAndCaloricIntake(for: report.activityMetabolismNutrition),
            .socialRisks
        ])
    }
}

struct CategorisedReport {
    let title: String
    let dataPoints: [DataPoint]
}

extension CategorisedReport {
    struct DataPoint: Equatable {
        let title: String
        let definition: String
        let valueKey: String
        let trendKey: String?
        let suffix: String
        
        init(title: String, definition: String, valueKey: String, trendKey: String? = nil, suffix: String = "") {
            self.title = title
            self.definition = definition
            self.valueKey = valueKey
            self.trendKey = trendKey
            self.suffix = suffix
        }
    }
    
    struct Trend {
        enum Arrow { case up, neutral, down }
        
        let value: Double
        let growth: Arrow
        let change: Arrow
    }
}

extension CategorisedReport {
    static var overallHealthStatus: Self {
        .init(title: "Overall Health Status",
              dataPoints: [
                .completeHealthScore,
                .depression,
                .anxiety,
                .stress,
                .diabetes,
                .preEclampsia
              ])
    }
    
    static var bodyCompositionSummary: Self {
        .init(title: "Body Composition Summary",
              dataPoints: [
                .correctedBMI,
                .bodyFatPercentage,
                .bodyFatRecommendation,
                .bodyWeight,
                .bodyWeightRecommendation,
                .leanMass,
                .fatMass
              ])
    }

    static func metabolismAndCaloricIntake(
        for activityMetabolismNutrition: ReportModel.ActivityMetabolismNutrition
    ) -> Self {
        let calcCaloricDiff = activityMetabolismNutrition.dailyCaloricIntake - activityMetabolismNutrition.AMR;
        
        let dailyCaloricDataPoint: DataPoint = if (calcCaloricDiff > 0) {
            .dailyCaloricSurplus
        } else if (calcCaloricDiff < 0) {
            .dailyCaloricDeficit
        } else {
            .dailyCaloricChange
        }
        
        return .init(title: "Metabolism And Caloric Intake",
                     dataPoints: [
                        activityMetabolismNutrition.projectedWeeklyFatLoss < 0 ? .projectedWeeklyFatLoss : .projectedWeeklyFatGain,
                        .activeMetabolicRate,
                        .restingMetabolicRate,
                        .dailyCaloricIntakeGoal,
                        dailyCaloricDataPoint,
                        .carbohydrate,
                        .fat,
                        .protein
                     ])
    }
    
    static var socialRisks: Self {
        .init(title: "Social Risks",
              dataPoints: [
                .housing,
                .food,
                .financial,
                .transportation,
                .personalSafety
              ])
    }
}

extension CategorisedReport.DataPoint {
    static var completeHealthScore: Self {
        .init(title: "Complete Health Score",
              definition: "The complete health score is a summary of your current physical fitness, type 2 diabetes risk, readiness and current mental/emotional health. This is a holistic representation of where you are today. The point range is 0-100. A higher score is indicative of a higher level of overall general health.",
              valueKey: "summary.healthScore",
              trendKey: "summary.healthScoreTrend")
    }
    
    static var depression: Self {
        .init(title: "Depression",
              definition: "DASS-21 is a set of three self-report scales designed to measure the emotional states of depression, anxiety and stress. The depression scale assesses dysphoria, hopelessness, devaluation of life, self-deprecation, lack of interest / involvement, anhedonia and inertia.",
              valueKey: "summary.depressionCondition")
    }

    static var anxiety: Self {
        .init(title: "Anxiety",
              definition: "DASS-21 is a set of three self-report scales designed to measure the emotional states of depression, anxiety and stress. The anxiety scale assesses autonomic arousal, skeletal muscle effects, situational anxiety, and subjective experience of anxious affect.",
              valueKey: "summary.anxietyCondition")
    }
    
    static var stress: Self {
        .init(title: "Stress",
              definition: "DASS-21 is a set of three self-report scales designed to measure the emotional states of depression, anxiety and stress. The stress scale is sensitive to levels of chronic non-specific arousal. It assesses difficulty relaxing, nervous arousal, and being easily upset / agitated, irritable / over-reactive and impatient.",
              valueKey: "summary.stressCondition")
    }
    
    static var diabetes: Self {
        .init(title: "Type II Diabetes Risk",
              definition: "The percentage displayed is the adjusted likelihood of you developing Type II Diabetes, on average over the course of your lifetime. Regardless of your disease risk percentages, this does not mean that you have any of these diseases nor will you actually develop any of these diseases. We are merely making a risk projection.",
              valueKey: "summary.diabetes",
              suffix: "%")
    }
    
    static var preEclampsia: Self {
        .init(title: "Preeclampsia Risk Factor",
              definition: "Preeclampsia is a serious medical condition that can occur about midway through pregnancy (after 20 weeks). People with preeclampsia experience high blood pressure, protein in their urine, swelling, headaches and blurred vision. This condition needs to be treated by a healthcare provider. Regardless of risk factor, this does not mean that you have this condition nor will you actually develop this disease. We are merely making a risk projection.",
              valueKey: "summary.preEclampsiaCondition")
    }
}

extension CategorisedReport.DataPoint {
    static var correctedBMI: Self {
        .init(title: "Corrected BMI",
              definition: "Patent protected health algorithm created by NASA. This is an updated version of BMI used to assess your current health status as it relates to body composition. Your current body fat percentage affects the Corrected BMI analysis.",
              valueKey: "summary.CBMI",
              trendKey: "summary.CBMITrend")
    }
    
    static var bodyFatPercentage: Self {
        .init(title: "Body Fat %",
              definition: "Percent of total body weight which is fat mass.",
              valueKey: "summary.bodyFatPercentage",
              trendKey: "summary.bodyFatPercentageTrend",
              suffix: "%")
    }
    
    static var bodyFatRecommendation: Self {
        .init(title: "Body Fat Recommendation",
              definition: "Age and gender sensitive recommendation for maximum healthy body fat percentage.",
              valueKey: "recommendations.idealBodyFatPercentage",
              suffix: "%")
    }
    
    static var bodyWeight: Self {
        .init(title: "Weight",
              definition: "Sum of body fat and lean body mass.",
              valueKey: "summary.weight",
              trendKey: "summary.bodyWeightTrend",
              suffix: " lbs")
    }
    
    static var bodyWeightRecommendation: Self {
        .init(title: "Weight Recommendation",
              definition: "Age and gender sensitive recommendation for maximum healthy body weight.",
              valueKey: "recommendations.idealBodyWeight",
              suffix: " lbs")
    }
    
    static var leanMass: Self {
        .init(title: "Lean Mass",
              definition: "Lean Body Mass includes muscle, bone, organs, all bodily fluids and most importantly water. Specific to weight loss, you could see a reduction in LBM as a result of inflammation reduction and water loss. This does not mean you are losing lean muscle mass.",
              valueKey: "summary.leanMass",
              trendKey: "summary.leanMassTrend",
              suffix: " lbs")
    }
    
    static var fatMass: Self {
        .init(title: "Fat Mass",
              definition: "Total body weight minus lean body mass. Lean body mass includes muscle, bone, organs and fluids. Fat mass is a summary of total body fat which includes essential and stored fat only.",
              valueKey: "summary.fatMass",
              trendKey: "summary.fatMassTrend",
              suffix: " lbs")
    }
}

extension CategorisedReport.DataPoint {
    static var projectedWeeklyFatGain: Self {
        .init(title: "Projected Weekly Fat Gain",
              definition: "Fat loss based on daily deficit converted into pounds. Actual weight gain could be 2x or 3x that amount as a result of excess water expulsion.",
              valueKey: "activityMetabolismNutrition.projectedWeeklyFatLoss",
              suffix: " lbs")
    }
    
    static var projectedWeeklyFatLoss: Self {
        .init(title: "Projected Weekly Fat Loss",
              definition: "Fat loss based on daily deficit converted into pounds. Actual weight loss could be 2x or 3x that amount as a result of excess water expulsion.",
              valueKey: "activityMetabolismNutrition.projectedWeeklyFatLoss",
              suffix: " lbs")
    }

    static var activeMetabolicRate: Self {
        .init(title: "Active Metabolic Rate",
              definition: "The total number of calories burned in a 24 hour period including all activities.",
              valueKey: "activityMetabolismNutrition.AMR",
              suffix: " cals")
    }

    static var restingMetabolicRate: Self {
        .init(title: "Resting Metabolic Rate",
              definition: "Minimum number of required calories on a daily basis. Is also the maximum number of calories burned in a 24 hour period at complete rest. No one should consume calories below RMR without professional guidance.",
              valueKey: "activityMetabolismNutrition.RMR",
              suffix: " cals")
    }

    static var dailyCaloricIntakeGoal: Self {
        .init(title: "Daily Caloric Intake Goal",
              definition: "Caloric intake advice is predicated on you continuing at your current activity level. Fat or weight loss is a result of a caloric deficit or burning more calories than you eat. Weight gain is predicated on a caloric surplus or burning less calories than you eat. For those that want to be more aggressive about their weight loss take in calories toward the lower end of the range closer to RMR. For those trying to gain weight at a quicker rate consume calories above AMR toward the higher end of the recommendation range. RMR and AMR are defined  in the body composition report.",
              valueKey: "activityMetabolismNutrition.idealCaloricIntake",
              suffix: " cals")
    }

    static var dailyCaloricDeficit: Self {
        .init(title: "Daily Caloric Deficit",
              definition: "A key component to fat loss is caloric deficit. In short, eating less calories than you burn. That is a caloric deficit state.",
              valueKey: "activityMetabolismNutrition.dailyCaloricDifference",
              suffix: " cals")
    }

    static var dailyCaloricSurplus: Self {
        .init(title: "Daily Caloric Surplus",
              definition: "A key component to weight gain is a caloric surplus state. In short, eating more calories than you burn. This is important for those that are deemed under weight by our algorithms.",
              valueKey: "activityMetabolismNutrition.dailyCaloricDifference",
              suffix: " cals")
    }

    static var dailyCaloricChange: Self {
        .init(title: "Daily Caloric Change",
              definition: "This is calculated by subtracting your daily caloric intake from your AMR creating a negative or positive number. A negative number represents a potential weightloss state. A positive number represents weight gain.",
              valueKey: "activityMetabolismNutrition.dailyCaloricDifference",
              suffix: " cals")
    }
    
    // trendKey is used for percentage value with exception for Carbs, Fat, Protein
    static var carbohydrate: Self {
        .init(title: "Carbohydrate Daily (40%)",
              definition: "Carbohydrates are your energy source and fuel all activities. They also prevent the degradation of skeletal muscle and organ tissue. It is recommended that carbohydrates supply 40%–65% of our total daily caloric intake.",
              valueKey: "activityMetabolismNutrition.carbsInGrams",
              trendKey: "activityMetabolismNutrition.carbsPercentage",
              suffix: " gms")
    }
    
    static var fat: Self {
        .init(title: "Fat Daily (30%)",
              definition: "Fats are an essential part of a balanced diet. Fat is important for brain function, organ health and a myriad of other things. Some of the best sources of healthy fats are avocados, olive oil, nuts and seeds. It is recommended that healthy fats supply 20%-30% of your daily caloric intake.",
              valueKey: "activityMetabolismNutrition.fatInGrams",
              trendKey: "activityMetabolismNutrition.fatPercentage",
              suffix: " gms")
    }
    
    static var protein: Self {
        .init(title: "Protein Daily (30%)",
              definition: "Proteins are the building blocks of life. Protein is essential to maintenance growth, and or repair of all body tissues including muscle, organs and hormone production. It is recommended that proteins account for 20%-30% of your daily caloric intake.",
              valueKey: "activityMetabolismNutrition.proteinInGrams",
              trendKey: "activityMetabolismNutrition.proteinPercentage",
              suffix: " gms")
    }
}

extension CategorisedReport.DataPoint {
    static var housing: Self {
        .init(title: "Housing Instability",
              definition: "Housing Instability is a social risk that refers to conditions such as Homelessness, unsafe or unhealthy housing conditions, inability to pay mortgage/ rent, frequent housing disruptions, eviction",
              valueKey: "socialRisk.housingInstability")
    }

    static var food: Self {
        .init(title: "Food Insecurity",
              definition: "Food Insecurity is a social risk that refers to conditions such as limited or uncertain access to adequate food",
              valueKey: "socialRisk.foodInsecurity")
    }
    
    static var financial: Self {
        .init(title: "Financial Stress",
              definition: "Financial Stress is a social risk that refers to conditions such as inability to afford essential needs, financial literacy, medication under-use due to cost, benefits denial",
              valueKey: "socialRisk.financialStress")
    }
    
    static var transportation: Self {
        .init(title: "Transportation Barriers",
              definition: "Transportation Barriers is a social risk that refers to conditions such as difficulty in accessing or affording transportation (medical or public)",
              valueKey: "socialRisk.transportationBarriers")
    }
    
    static var personalSafety: Self {
        .init(title: "Personal Safety",
              definition: "Personal Safety is a social risk that refers to conditions such as intimate partner violence, elder abuse, community violence",
              valueKey: "socialRisk.personalSafety")
    }
}
