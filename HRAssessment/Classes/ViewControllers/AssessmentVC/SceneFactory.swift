import Foundation

enum SceneFactory { }

extension SceneFactory {
    static func socialNeedsScene(questionIndex: Int = 0,
                                 delegate: SocialNeedsVCDelegate) -> SocialNeedsVC {
        let scene = SocialNeedsVC.instantiate(from: .HealthReel)
        scene.delegate = delegate
        scene.index = questionIndex
        return scene
    }

    static func dassDescScene(delegate: DassDescVCProtocol) -> DassDescVC {
        let scene = DassDescVC.instantiate(from: .HealthReel)
        scene.delegate = delegate
        return scene
    }

    static func dassAssessmentScene(questionIndex: Int = 0, 
                                    delegate: DassAssessmentVCDelegate) -> DassAssessmentVC {
        let scene = DassAssessmentVC.instantiate(from: .HealthReel)
        scene.delegate = delegate
        scene.index = questionIndex
        return scene
    }

    static func pregnantScene(delegate: PregnantVCDelegate) -> PregnantVC {
        let scene = PregnantVC.instantiate(from: .HealthReel)
        scene.delegate = delegate
        return scene
    }

    static func preEclampsiaScene(questionIndex: Int = 1, 
                                  delegate: RiskFactorVCDelegate) -> PreEclampsiaRiskFactorsVC {
        let scene = PreEclampsiaRiskFactorsVC.instantiate(from: .HealthReel)
        scene.delegate = delegate
        scene.index = questionIndex
        return scene
    }

    static func selfHealthReadinessScene(delegate: SelfHealthVCDelegate) -> SelfHealthReadinessVC {
        let scene = SelfHealthReadinessVC.instantiate(from: .HealthReel)
        scene.delegate = delegate
        return scene
    }

    static func activityLevelScene(delegate: ActivityLevelVCDelegate) -> ActivityLevelVC {
        let scene = ActivityLevelVC.instantiate(from: .HealthReel)
        scene.delegate = delegate
        return scene
    }

    static func bodyWeightScene(delegate: BodyWeightVCDelegate) -> BodyWeightVC {
        let scene = BodyWeightVC.instantiate(from: .HealthReel)
        scene.delegate = delegate
        return scene
    }

    static func videoPlayer(gender: UserProfile.Gender, delegate: VideoPlayerVCDelegate) -> VideoPlayerVC {
        let scene = VideoPlayerVC.instantiate(from: .HealthReel)
        scene.gender = gender
        scene.delegate = delegate
        return scene
    }
    
    static func videoRecordingScene(delegate: VideoRecordingDelegate) -> VideoRecordingVC {
        let scene = VideoRecordingVC.instantiate(from: .HealthReel)
        scene.delegate = delegate
        return scene
    }
}
