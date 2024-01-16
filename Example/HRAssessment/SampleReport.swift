//
//  SampleReport.swift
//  HRAssessment_Example
//
//  Created by HealthReel on 12/01/2023.
//  Copyright (c) 2023 HealthReel. All rights reserved.
//

import Foundation

let rawReport = """
        {
            "summary": {
                "preEclampsiaCondition": "High-Risk",
                "healthScore": 41.29011039690418,
                "healthScoreTrend": {
                    "value": -3.709889603095817,
                    "growth": -1,
                    "change": -1
                },
                "bodyCompositionScore": 61,
                "dassScore": 17.22527599226045,
                "depressionScore": 30,
                "depressionCondition": "Extremely Severe",
                "anxietyScore": 30,
                "anxietyCondition": "Extremely Severe",
                "stressScore": 30,
                "stressCondition": "Severe",
                "bodyFatPercentage": 30,
                "bodyFatPercentageTrend": {
                    "value": -10,
                    "growth": 1,
                    "change": -1
                },
                "CBMI": 28,
                "CBMITrend": {
                    "value": -10,
                    "growth": 1,
                    "change": -1
                },
                "weight": 88,
                "bodyWeightTrend": {
                    "value": -1,
                    "growth": 1,
                    "change": -1
                },
                "leanMass": 61.6,
                "leanMassTrend": {
                    "value": 8.200000000000003,
                    "growth": 1,
                    "change": 1
                },
                "fatMass": 26.4,
                "fatMassTrend": {
                    "value": -9.200000000000003,
                    "growth": 1,
                    "change": -1
                },
                "cancer": 10.31,
                "heart": 22.6,
                "stroke": 24.98,
                "diabetes": -1.05,
                "respiratory": -18.68
            },
            "recommendations": {
                "idealBodyFatPercentage": 21.1,
                "idealBodyWeight": 78.1,
                "goalBodyFatPercentage": 20,
                "goalBodyWeight": 70,
                "minIdealCBMI": 18.5,
                "maxIdealCBMI": 25,
                "timeToGoalInWeeks": 0
            },
            "activityMetabolismNutrition": {
                "AMR": 1852.3328,
                "dailyCaloricIntake": 2200,
                "RMR": 974.912,
                "idealCaloricIntake": 1413.6224,
                "dailyCaloricDifference": 347.6672000000001,
                "projectedWeeklyFatLoss": 0.7,
                "carbsPercentage": 40,
                "carbsInGrams": 220,
                "fatPercentage": 30,
                "fatInGrams": 73.33333333333333,
                "proteinPercentage": 30,
                "proteinInGrams": 165
            },
            "socialRisk": {
                "housingInstability": "Positive",
                "foodInsecurity": "Positive",
                "financialStress": "Positive",
                "transportationBarriers": "Positive",
                "personalSafety": "Positive"
            },
            "lastReportDetails": {
                "lastHealthScore": 72,
                "lastBodyFatPercentage": 40,
                "lastBodyWeight": 89,
                "lastCBMI": 38
            },
            "otherDetails": {
                "activityLevel": 5,
                "race": "asian",
                "gender": "male",
                "dob": "1970-01-09T17:49:31.622Z",
                "height": 180,
                "waist": 38,
                "isDiabetic": false
            },
            "editingRanges": {
                "minBodyFat": 5,
                "recommendedBodyFat": 21.1,
                "maxBodyFat": 30,
                "minCalorieIntake": 974.912,
                "recommendedCaloricIntake": 1413.6224,
                "maxCalorieIntake": 1852.3328,
                "recommendedCarbsPercentage": 40,
                "recommendedProteinPercentage": 30,
                "recommendedFatPercentage": 30
            },
            "createdAt": "2023-10-24T01:21:14.966Z"
}
""".data(using: .utf8)!
