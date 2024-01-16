import Foundation

protocol BasePageControllerDelegate: AnyObject {
    func currentPageUpdated()
    func scrollToNextPage()
    func startVideoRecording()
}

final class BasePageController {
    weak var delegate: BasePageControllerDelegate?
    
    // MARK: Properties
    var socialNeedsResponses: SocialNeedsResponses = [:]
    var dassResponses: DASSResponses = [:]
    var preEclampsiaResponses: PreEclampsiaResponses = [:]
    var selfHealthResponses: SelfHealthReadinessResponses = [:]

    var activityLevel: ActivityLevel = .sedentary
    var bodyWeight: Double = 165.4
    
    let userProfile: UserProfile
    
    var currentPageIndex: Int = 0
    var currentPageType: PageType = .socialNeeds {
        didSet {
            switch currentPageType {
            case .socialNeeds, .dassDescription, .dass, .pregnant, .selfHealth:
                currentPageIndex = 0
            case .preEclampsia, .activityLevel:
                currentPageIndex = 1
            case .bodyWeight:
                currentPageIndex = 2
            }
            
            delegate?.currentPageUpdated()
        }
    }

    // MARK: Initializer
    init(userProfile: UserProfile) {
        self.userProfile = userProfile
    }
    
    // MARK: Functions
    internal func skipCurrentPageType() {
        switch currentPageType {
        case .socialNeeds:
            socialNeedsResponses.removeAll()
            currentPageType = .dassDescription
        case .dassDescription, .dass:
            dassResponses.removeAll()
            currentPageType = gender == .female ? .pregnant : .selfHealth
        default: break
        }
    }
    
    /// Get Number of Questions
    internal var numberOfPages: Int {
        switch currentPageType {
        case .socialNeeds:
            return socialNeedQuestionnaire.count
        case .dassDescription:
            return 1
        case .dass:
            return dassAssessmentQuestions.count
        case .pregnant, .preEclampsia:
            return 5
        case .selfHealth, .activityLevel, .bodyWeight:
            return 4
        }
    }
}

// MARK: Social Needs Protocol
extension BasePageController: SocialNeedsVCDelegate {
    var socialNeedQuestionnaire: [SocialNeedsQuestion] {
        SocialNeedsQuestion.default
    }

    func selectSocialNeeds(socialNeed: SocialNeedsQuestion, option: SocialNeedsResponse) {
        socialNeedsResponses[socialNeed] = option
        // When user answers the last question, move to the next form
        if socialNeed == socialNeedQuestionnaire.last {
            currentPageType = .dassDescription
        } else {
            delegate?.scrollToNextPage()
        }
    }

    func response(for socialNeed: SocialNeedsQuestion) -> SocialNeedsResponse? {
        socialNeedsResponses[socialNeed]
    }
}

// MARK: Mental Protocol
extension BasePageController: DassAssessmentVCDelegate {
    var dassAssessmentQuestions: [DASSQuestion] {
        DASSQuestion.default
    }

    func dassResponseRecieved(for question: DASSQuestion, response: DASSResponse) {
        dassResponses[question] = response

        if dassAssessmentQuestions.last == question {
            currentPageType = gender == .female ? .pregnant : .selfHealth
        } else {
            delegate?.scrollToNextPage()
        }
    }

    func response(for question: DASSQuestion) -> DASSResponse? {
        dassResponses[question]
    }
}

// MARK: Mental Desc Protocol
extension BasePageController: DassDescVCProtocol {
    func startDassAssessment() {
        currentPageType = .dass
    }
}

// MARK: Pregnant Protocol
extension BasePageController: PregnantVCDelegate {
    func responseRecieved(_ response: PregnantVC.Response) {
        guard let areYouPregnantQues = preEclampsiaQuestions.first else { return }
        preEclampsiaResponses[areYouPregnantQues] = [response.rawValue]
        currentPageType = response == .yes ? .preEclampsia : .selfHealth
    }

    var response: PregnantVC.Response? {
        guard let areYouPregnantQues = preEclampsiaQuestions.first else { return nil }
        return PregnantVC.Response(rawValue: preEclampsiaResponses[areYouPregnantQues]?.first ?? "")
    }
}

extension BasePageController: RiskFactorVCDelegate {
    var preEclampsiaQuestions: [PreEclampsiaQuestion] {
        PreEclampsiaQuestion.default
    }

    func response(for question: PreEclampsiaQuestion) -> PreEclampsiaResponse {
        preEclampsiaResponses[question] ?? .init()
    }

    func responseUpdated(for question: PreEclampsiaQuestion, response: PreEclampsiaResponse) {
        preEclampsiaResponses[question] = response
    }
}

// MARK: Self Health Protocol
extension BasePageController: SelfHealthVCDelegate {
    func selfHealthResponseUpdated(for question: SelfHealthReadinessQuestion, response: SelfHealthReadinessResponse) {
        selfHealthResponses[question] = response
    }

    func selfHealthResponse(for question: SelfHealthReadinessQuestion) -> SelfHealthReadinessResponse? {
        selfHealthResponses[question]
    }

    var selfHealthQuestions: [SelfHealthReadinessQuestion] {
        SelfHealthReadinessQuestion.default
    }
}

// MARK: Activity Level Protocol
extension BasePageController: ActivityLevelVCDelegate {
    func activityLevelResponseUpdated(activityLevel: ActivityLevel) {
        self.activityLevel = activityLevel
    }

    var activityLevelResponse: ActivityLevel {
        activityLevel
    }
}

// MARK: Body Weight Protocol
extension BasePageController: BodyWeightVCDelegate {
    func bodyWeightUpdated(weight: Double) {
        bodyWeight = weight
    }

    var bodyWeightResponse: Double {
        bodyWeight
    }
}

// MARK: Video Player Protocol
extension BasePageController: VideoPlayerVCDelegate {
    func startVideoRecording() {
        delegate?.startVideoRecording()
    }
    
    func backButtonTapped() {
        
    }
}

extension BasePageController: VideoRecordingDelegate {
    var gender: UserProfile.Gender {
        userProfile.gender
    }
    
    func uploadVideo(fileURL: URL) {
        Task {
            await APIService.generateHealthReport(fileURL: fileURL,
                                                  requestObj: createReportRequest())
        }
    }
}

extension BasePageController {
    fileprivate func createReportRequest() -> HRReportRequest {
        var request = HRReportRequest(user: userProfile,
                                      selfHealthReadiness: selfHealthResponses.json,
                                      activityLevel: activityLevelResponse.rawValue,
                                      weight: bodyWeightResponse)
        
        if let dassScore = dassResponses.dassScore {
            request.anxietyScore = dassScore.anxiety
            request.depressionScore = dassScore.depression
            request.stressScore = dassScore.stress
        }
        
        if socialNeedsResponses.isEmpty == false {
            request.sdoh = socialNeedsResponses.json
        }
        
        if selfHealthResponses.isEmpty == false {
            request.selfHealthReadiness = selfHealthResponses.json
        }
        
        if preEclampsiaResponses.isEmpty == false {
            request.preEclampsia = preEclampsiaResponses.json
        }
        
        return request
    }
}
