import UIKit

final class BasePageViewController: BaseVC {
    
    // MARK: IBOutlets
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var progressBar1: UIImageView!
    @IBOutlet weak var progressBar2: UIImageView!
    @IBOutlet weak var lblPageCount: UILabel!
    
    @IBOutlet weak var lblSocialNeeds: UILabel!
    @IBOutlet weak var lblMental: UILabel!
    @IBOutlet weak var lblBodyComposition: UILabel!

    @IBOutlet weak var viewPageContainer: UIView!
    @IBOutlet weak var constraintPageContainerBottom: NSLayoutConstraint!

    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var constraintPageHeight: NSLayoutConstraint!
    @IBOutlet weak var viewChildContainer: UIView!

    // MARK: Properties
    var controller: BasePageController!
    let pageViewController = HRPageViewController()
    
    // MARK: IBActions
    @IBAction func onTapNextBtn(_ sender: Any) {
        switch controller.currentPageType {
        case .socialNeeds, .dassDescription, .dass, .pregnant:
            // These screens does not have next button
            break
        case .preEclampsia:
            scrollToNextPage()
        case .selfHealth:
            controller.currentPageType = .activityLevel
        case .activityLevel:
            controller.currentPageType = .bodyWeight
        case .bodyWeight:
            let videoPlayer = SceneFactory.videoPlayer(gender: controller.gender,
                                                       delegate: controller)
            navigationController?.pushViewController(videoPlayer, animated: true)
        }
    }
    
    @IBAction func onTapSkipBtn(_ sender: Any) {
        controller.skipCurrentPageType()
    }
    
    override func onTapNavBarRightButton() {
        if controller.currentPageType == .dassDescription {
            let infoScene = InformationVC.instantiate(from: .HealthReel)
            infoScene.descriptionFont = HRFonts.regular14
            infoScene.dataPoint = .init(
                title: String(localizedKey: "dass.description.title"),
                definition: String(localizedKey: "dass.description"),
                valueKey: "")
            present(infoScene, animated: true)
        }
    }
}

extension BasePageViewController: BasePageControllerDelegate {
    func currentPageUpdated() {
        configureNavigationViews()
        setupCounterButton()
        updatePageCount(index: controller.currentPageIndex)
        applyPageConfiguration()
        pageViewController.isScrollEnabled = true
        
        switch controller.currentPageType {
        case .socialNeeds:
            let socialNeedsScene = SceneFactory.socialNeedsScene(
                questionIndex: controller.currentPageIndex,
                delegate: controller
            )
            configurePageVC(viewController: socialNeedsScene)
            resetPageContainerBottomSpace()

        case .dassDescription:
            let dassDescScene = SceneFactory.dassDescScene(delegate: controller)
            configurePageVC(viewController: dassDescScene)
            stickPageContainerToBottom()
            pageViewController.isScrollEnabled = false
            
            navRightButton.isHidden = false
            navRightButton.setImage(HRImageAsset.info_icon.image, for: .normal)
            
        case .dass:
            let dassAssessmentScene = SceneFactory.dassAssessmentScene(
                questionIndex: controller.currentPageIndex,
                delegate: controller
            )
            configurePageVC(viewController: dassAssessmentScene)
            resetPageContainerBottomSpace()

        case .pregnant:
            let pregnantScene = SceneFactory.pregnantScene(delegate: controller)
            configurePageVC(viewController: pregnantScene)
            resetPageContainerBottomSpace()

        case .preEclampsia:
            let scene = SceneFactory.preEclampsiaScene(delegate: controller)
            configurePageVC(viewController: scene)
            resetPageContainerBottomSpace()

        case .selfHealth:
            let selfHealthReadinessScene = SceneFactory.selfHealthReadinessScene(delegate: controller)
            configurePageVC(viewController: selfHealthReadinessScene)
            resetPageContainerBottomSpace()
            pageViewController.isScrollEnabled = false

        case .activityLevel:
            let activityLevelScene = SceneFactory.activityLevelScene(delegate: controller)
            configurePageVC(viewController: activityLevelScene)
            resetPageContainerBottomSpace()
            pageViewController.isScrollEnabled = false

        case .bodyWeight:
            let bodyWeightScene = SceneFactory.bodyWeightScene(delegate: controller)
            configurePageVC(viewController: bodyWeightScene)
            resetPageContainerBottomSpace()
            pageViewController.isScrollEnabled = false
        }
    }

    func scrollToNextPage() {
        guard let nextViewController = getNextViewController() else {
            return
        }

        configurePageVC(viewController: nextViewController)
        updatePageCount(index: controller.currentPageIndex)
    }

    func startVideoRecording() {
        let videoRecordingScene = SceneFactory.videoRecordingScene(delegate: controller)
        navigationController?.pushViewController(videoRecordingScene, animated: true)
    }
}

// MARK: Page View Functions
extension BasePageViewController {
    func configurePageVC(viewController: UIViewController) {
        pageViewController.setViewControllers([viewController],
                                              direction: .forward,
                                              animated: true)
    }

    func getNextViewController() -> UIViewController? {
        switch controller.currentPageType {
        case .socialNeeds:
            guard let currentViewController = pageViewController.viewControllers?.first as? SocialNeedsVC,
                    currentViewController.index < controller.numberOfPages - 1 else {
                return nil
            }

            let nextIndex = currentViewController.index + 1
            controller.currentPageIndex = nextIndex
            return SceneFactory.socialNeedsScene(questionIndex: nextIndex, delegate: controller)

        case .dassDescription:
            return nil

        case .dass:
            guard let currentViewController = pageViewController.viewControllers?.first as? DassAssessmentVC,
                    currentViewController.index < controller.numberOfPages - 1 else {
                return nil
            }
            let nextIndex = currentViewController.index + 1
            controller.currentPageIndex = nextIndex

            return SceneFactory.dassAssessmentScene(questionIndex: nextIndex, delegate: controller)

        case .pregnant:
            guard let currentViewController = pageViewController.viewControllers?.first as? PregnantVC,
                    currentViewController.index < controller.numberOfPages - 1 else {
                return nil
            }
            let nextIndex = currentViewController.index + 1
            controller.currentPageIndex = nextIndex

            return SceneFactory.preEclampsiaScene(delegate: controller)

        case .preEclampsia:
            guard let currentViewController = pageViewController.viewControllers?.first as? PreEclampsiaRiskFactorsVC else {
                return nil
            }

            if currentViewController.index < controller.numberOfPages - 1  {
                let nextIndex = currentViewController.index + 1
                controller.currentPageIndex = nextIndex
                return SceneFactory.preEclampsiaScene(questionIndex: nextIndex, 
                                                      delegate: controller)

            } else {
                controller.currentPageType = .selfHealth
                return nil
            }

        case .selfHealth, .activityLevel, .bodyWeight:
            return nil
        }
    }
}
