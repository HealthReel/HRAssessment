import UIKit

protocol HRPageViewIndexed {
    var index: Int { get set }
}

final class HRPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    var isForwardEnabled: Bool = true
    var isBackwardEnabled: Bool = true

    weak var datasource: HRPageViewControllerDataSource?

    convenience init() {
        self.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = HRThemeColor.white
        scrollView.backgroundColor = HRThemeColor.white
        dataSource = self
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        isBackwardEnabled ? datasource?.pageViewController(self, viewControllerBefore: viewController) : nil

    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        isForwardEnabled ? datasource?.pageViewController(self, viewControllerAfter: viewController) : nil

    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        datasource?.presentationCount(for: self) ?? 0
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        datasource?.presentationIndex(for: self) ?? 0
    }
}

protocol HRPageViewControllerDataSource: AnyObject {
    func pageViewController(_ pageViewController: HRPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController?

    func pageViewController(_ pageViewController: HRPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController?

    func presentationCount(for pageViewController: HRPageViewController) -> Int

    func presentationIndex(for pageViewController: HRPageViewController) -> Int
}
