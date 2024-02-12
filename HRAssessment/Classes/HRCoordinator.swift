import Foundation

public final class HRCoordinator {
    let navigationController: UINavigationController
    let credentials: HRCredentials
    
    public init(_ navigationController: UINavigationController,
                credentials: HRCredentials) {
        self.navigationController = navigationController
        self.credentials = credentials
        
        loadFonts()
    }

    public func startAssessment(userReferenceID: String,
                                previousReport: PreviousReportDetails? = nil) {
        let scene = UserProfileVC.instantiate(from: .HealthReel)
        scene.user = UserProfile(userReferenceID: userReferenceID)
        scene.nextButtonAction = {
            self.startAssessment(user: scene.user,
                                 previousReport: previousReport)
        }
        navigationController.pushViewController(scene, animated: true)
    }
    
    public func startAssessment(user: UserProfile,
                                previousReport: PreviousReportDetails? = nil) {
        let scene = BasePageViewController.instantiate(from: .HealthReel)
        scene.controller = BasePageController(userProfile: user,
                                              credentials: credentials,
                                              previousReport: previousReport)
        navigationController.pushViewController(scene, animated: true)
    }
    
    public func showCharts(data: [ChartData]) {
        let chartsScene = ChartsVC.instantiate(from: .HealthReel)
        chartsScene.dataSource = data
        navigationController.pushViewController(chartsScene, animated: true)
    }
    
    public func showReport(data: [ReportModel]) {
        let reportScene = ReportVC.instantiate(from: .HealthReel)
        reportScene.controller = ReportsController(source: data)
        navigationController.pushViewController(reportScene, animated: true)
    }
}

extension HRCoordinator {
    private func loadFonts() {
      let fontNames = HRFonts.allCases.map { $0.fontname }
      for fontName in fontNames {
        loadFont(withName: fontName)
      }
    }

    private func loadFont(withName fontName: String) {
      guard 
        let fontURL = Bundle.HRAssessment.url(forResource: fontName,
                                              withExtension: "ttf"),
        let fontData = try? Data(contentsOf: fontURL) as CFData,
        let provider = CGDataProvider(data: fontData),
        let font = CGFont(provider) else {
          return
      }
      CTFontManagerRegisterGraphicsFont(font, nil)
    }
}

enum PageType {
    case socialNeeds
    case dassDescription
    case dass
    case pregnant
    case preEclampsia
    case selfHealth
    case activityLevel
    case bodyWeight
}

extension PageType {
    struct Configuration {
        let title: String
        let skipButtonTitle: String?
        let hideNextButton: Bool
    }

    var configuration: Configuration {
        switch self {
        case .socialNeeds:
            return .init(title: String(localizedKey: "nav.title.social_needs_screening"),
                         skipButtonTitle: String(localizedKey: "skip.title.sdoh_assessment"),
                         hideNextButton: true)
        case .dassDescription, .dass:
            return .init(title: String(localizedKey: "nav.title.mental_emotional"),
                         skipButtonTitle: String(localizedKey: "skip.title.mental_emotional_assessment"),
                         hideNextButton: true)
        case .pregnant:
            return .init(title: String(localizedKey: "nav.title.preeclampsia_risk_estimation"),
                         skipButtonTitle: nil,
                         hideNextButton: true)
        case .preEclampsia:
            return .init(title: String(localizedKey: "nav.title.preeclampsia_risk_estimation"),
                         skipButtonTitle: nil,
                         hideNextButton: false)
        case .selfHealth:
            return .init(title: String(localizedKey: "nav.title.self_health_readiness"),
                         skipButtonTitle: nil,
                         hideNextButton: false)
        case .activityLevel:
            return .init(title: String(localizedKey: "nav.title.activity_level"),
                         skipButtonTitle: nil,
                         hideNextButton: false)
        case .bodyWeight:
            return .init(title: String(localizedKey: "nav.title.body_weight"),
                         skipButtonTitle: nil,
                         hideNextButton: false)
        }
    }
}
