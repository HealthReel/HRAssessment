import UIKit

// MARK: PageView Datasource
extension BasePageViewController: HRPageViewControllerDataSource, UIPageViewControllerDelegate {
    func presentationIndex(for pageViewController: HRPageViewController) -> Int {
        controller.currentPageIndex
    }

    func presentationCount(for pageViewController: HRPageViewController) -> Int {
        controller.numberOfPages
    }

    func pageViewController(_ pageViewController: HRPageViewController,
                            viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        switch controller.currentPageType {
        case .socialNeeds:
            return getPreviousSocialNeedsScene(for: viewController)
        case .dass:
            return getPreviousDassScene(for: viewController)
        case .preEclampsia:
            return getPreviousPreEclampsiaScene(for: viewController)
        default:
            return nil
        }
    }

    func pageViewController(_ pageViewController: HRPageViewController,
                            viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        switch controller.currentPageType {
        case .socialNeeds:
            return getNextSocialNeedsScene(for: viewController)
        case .dass:
            return getNextDassScene(for: viewController)
        case .preEclampsia:
            return getNextPreEclampsiaScene(for: viewController)
        default:
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard let scene = pageViewController.viewControllers?.last else {
            return
        }
        
        if let scene = scene as? HRPageViewIndexed {
            updatePageCount(index: scene.index)
        }
    }
}

extension BasePageViewController {
    fileprivate func getPreviousSocialNeedsScene(for vc: UIViewController) -> SocialNeedsVC? {
        guard let socialNeedsScene = vc as? SocialNeedsVC,
              socialNeedsScene.index > 0 else {
            return nil
        }

        controller.currentPageIndex = socialNeedsScene.index - 1

        return SceneFactory.socialNeedsScene(
            questionIndex: controller.currentPageIndex,
            delegate: controller
        )
    }

    fileprivate func getNextSocialNeedsScene(for vc: UIViewController) -> SocialNeedsVC? {
        guard let socialNeedsScene = vc as? SocialNeedsVC,
              socialNeedsScene.index < controller.numberOfPages - 1 else {
            return nil
        }

        guard controller.socialNeedsResponses.keys.contains(socialNeedsScene.socialNeed) else {
            return nil
        }

        controller.currentPageIndex = socialNeedsScene.index + 1

        return SceneFactory.socialNeedsScene(
            questionIndex: controller.currentPageIndex,
            delegate: controller
        )
    }

    fileprivate func getPreviousDassScene(for vc: UIViewController) -> DassAssessmentVC? {
        guard let dassScene = vc as? DassAssessmentVC,
              dassScene.index > 0 else {
            return nil
        }

        controller.currentPageIndex = dassScene.index - 1

        return SceneFactory.dassAssessmentScene(
            questionIndex: controller.currentPageIndex,
            delegate: controller
        )
    }

    fileprivate func getNextDassScene(for vc: UIViewController) -> DassAssessmentVC? {
        guard let dassScene = vc as? DassAssessmentVC,
              dassScene.index < controller.numberOfPages - 1 else {
            return nil
        }

        guard controller.dassResponses.keys.contains(dassScene.dassQuestion) else {
            return nil
        }

        controller.currentPageIndex = dassScene.index + 1

        return SceneFactory.dassAssessmentScene(
            questionIndex: controller.currentPageIndex,
            delegate: controller
        )
    }

    fileprivate func getPreviousPreEclampsiaScene(for vc: UIViewController) -> UIViewController? {
        guard let preEclampsiaScene = vc as? PreEclampsiaRiskFactorsVC,
              preEclampsiaScene.index > 0 else {
            return nil
        }

        controller.currentPageIndex = preEclampsiaScene.index - 1

        if preEclampsiaScene.index == 1 {
            return SceneFactory.pregnantScene(delegate: controller)
        } else {
            return SceneFactory.preEclampsiaScene(
                questionIndex: controller.currentPageIndex,
                delegate: controller
            )
        }
    }

    fileprivate func getNextPreEclampsiaScene(for vc: UIViewController) -> PreEclampsiaRiskFactorsVC? {
        guard let preEclampsiaScene = vc as? PreEclampsiaRiskFactorsVC,
              preEclampsiaScene.index < controller.numberOfPages - 1 else {
            return nil
        }

        guard controller.preEclampsiaResponses.keys.contains(preEclampsiaScene.preEclampsiaQuestion) else {
            return nil
        }

        controller.currentPageIndex = preEclampsiaScene.index + 1

        return SceneFactory.preEclampsiaScene(
            questionIndex: controller.currentPageIndex,
            delegate: controller
        )
    }
}
