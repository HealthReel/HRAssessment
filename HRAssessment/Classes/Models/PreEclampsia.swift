import Foundation

typealias PreEclampsiaResponse = Set<String>
typealias PreEclampsiaResponses = [PreEclampsiaQuestion: PreEclampsiaResponse]

enum RiskFactor {
    case preliminary, high, moderate, probable, low
    
    var title: String {
        switch self {
        case .preliminary: "Are you pregnant?"
        case .high: "High Risk Factors"
        case .moderate: "Moderate Risk Factors"
        case .probable: "Probable Risk Factors"
        case .low: "Low Risk Factors"
        }
    }
}

struct PreEclampsiaQuestion: Hashable {
    let type: RiskFactor
    let options: [String]
    
    var title: String {
        type.title
    }
}

extension PreEclampsiaQuestion {
    static var `default`: [PreEclampsiaQuestion] {
        return [
            PreEclampsiaQuestion(type: .preliminary, options: [
                PregnantVC.Response.yes.rawValue, PregnantVC.Response.no.rawValue
            ]),
            PreEclampsiaQuestion(type: .high, options: [
                "Prior Pre-eclampsia", "Chronic hypertension", "Type-1 or Type-2 Diabetes", "Adolescence", "Severe anaemia", "Advance Maternal Age"
            ]),
            PreEclampsiaQuestion(type: .moderate, options: [
                "Early pregnancy", "Stage-1 hypertension", "Prehypertension", "Antiphospholipid syndrome", "Smoking", "Obstructive sleep apnoea", "Family history in mother or sister", "Any infection in current pregnancy", "UTI in current pregnancy", "Prior stillbirth"
            ]),
            PreEclampsiaQuestion(type: .probable, options: [
                "Maternal age>40 years", "Systemic lupus erythematosus", "Chronic kidney disease", "Thrombophilia", "Nulliparity / Multiple pregnancy", "New or change in partner", "Prior miscarriage at ≤10weeks", "Methamphetmine use", "Sub-Saharan African", "South Asian /Maori", "Sickle cell disease", "Rheumatoid arthritis", "Polycystic ovarian syndrome", "Periodontal disease", "Depression", "Placental abruption prior pregnancy", "Prior preterm birth", "Anaemia", "Family history of heart disease"
            ]),
            PreEclampsiaQuestion(type: .low, options: [
                "Prior lower maternal birthweight", "Preterm birth", "Pacific Islander", "Hepatitis B infection", "Previous miscarriage", "Interpregnancy interval ≥10 years", "Duration of sexual relationship < 1 yr", "Low socio-economic status", "Stress", "Endometriosis", "Prior hypertensive disorder pregnancy", "Abnormal uterine artery", "Doppler incurrent pregnancy"
            ])
        ]
    }
}

extension PreEclampsiaResponses {
    var json: JSONDictionary {
        var json = JSONDictionary()
        let riskFactors: [RiskFactor] = [.high, .moderate, .probable, .low]
        
        for riskFactor in riskFactors {
            guard let question = keys.first(where: { $0.type == riskFactor }) else {
                continue
            }
            
            guard let selected = self[question]?.compactMap({ $0 }) else {
                continue
            }

            json[riskFactor.parameterName] = [
                "selected": selected,
                "options": question.options
            ]
        }
        return json
    }
}

extension RiskFactor {
    fileprivate var parameterName: String {
        switch self {
        case .preliminary: return ""
        case .high: return "highRiskFactors"
        case .moderate: return "moderateRiskFactors"
        case .probable: return "probableRiskFactors"
        case .low: return "lowRiskFactors"
        }
    }
}
