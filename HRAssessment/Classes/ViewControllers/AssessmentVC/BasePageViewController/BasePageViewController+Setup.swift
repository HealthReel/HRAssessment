import UIKit

extension BasePageViewController {

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let pageControl = UIPageControl.appearance()
        pageControl.hidesForSinglePage = true
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = HRThemeColor.lightgray
        pageControl.currentPageIndicatorTintColor = HRThemeColor.blue

        controller.delegate = self

        [lblSocialNeeds, lblMental, lblBodyComposition].forEach {
            $0?.font = HRFonts.stepIndicatorTitle
        }

        configureNavigationViews()
        configureViews()
        resetPageContainerBottomSpace()
        configurePageViewController()
        setupCounterButton()
        currentPageUpdated()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewContainer.roundTopCorners(radius: 30)
    }
}

// MARK: Functions
extension BasePageViewController {
    func configureNavigationViews() {
        navRightButton.isHidden = true
    }

    private func configureViews() {
        view.backgroundColor = HRThemeColor.white
        view.bringSubviewToFront(viewContainer)
        viewContainer.bringSubviewToFront(btnSkip)
        viewContainer.bringSubviewToFront(btnNext)

        [button1, button2, button3, btnNext].forEach {
            $0?.makeCircular()
        }

        lblPageCount.font = HRFonts.light16
        lblPageCount.textColor = HRThemeColor.blue
        btnNext.backgroundColor = HRThemeColor.blue
    }

    private func configurePageViewController() {
        pageViewController.delegate = self
        pageViewController.datasource = self

        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        viewChildContainer.addSubview(pageViewController.view)

        let views: [String: Any] = ["PageView": pageViewController.view!]
        viewChildContainer.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[PageView]-0-|",
                                           options: NSLayoutConstraint.FormatOptions(),
                                           metrics: nil,
                                           views: views)
        )
        viewChildContainer.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[PageView]-0-|",
                                           options: NSLayoutConstraint.FormatOptions(),
                                           metrics: nil,
                                           views: views)
        )
    }

    func applyPageConfiguration() {
        let pageConfig = controller.currentPageType.configuration
        btnNext.isHidden = pageConfig.hideNextButton
        navBarTitleLabel.text = pageConfig.title

        if let skipButtonTitle = pageConfig.skipButtonTitle {
            let attrTitle = NSAttributedString(string: skipButtonTitle,
                                               attributes: [ .font: HRFonts.regular16])
            btnSkip.setAttributedTitle(attrTitle, for: .normal)
            btnSkip.isHidden = false
        } else {
            btnSkip.isHidden = true
        }
    }
    
    func updatePageCount(index: Int) {
        lblPageCount.text = "\(index + 1)/\(controller.numberOfPages)"
    }

    func setupCounterButton() {
        setupPageButtonUI(button: button1, label: lblSocialNeeds)
        setupPageButtonUI(button: button2, label: lblMental)
        setupPageButtonUI(button: button3, label: lblBodyComposition)

        progressBar1.backgroundColor = HRThemeColor.gray
        progressBar2.backgroundColor = HRThemeColor.gray

        switch controller.currentPageType {
        case .socialNeeds:
            setupPageButtonUI(button: button1, label: lblSocialNeeds, isSelected: true)
        case .dass, .dassDescription:
            progressBar1.backgroundColor = HRThemeColor.blue
            setupPageButtonUI(button: button1, label: lblSocialNeeds, isSelected: true, fill: true)
            setupPageButtonUI(button: button2, label: lblMental, isSelected: true)
        case .pregnant, .preEclampsia, .selfHealth, .activityLevel, .bodyWeight:
            progressBar2.backgroundColor = HRThemeColor.blue
            setupPageButtonUI(button: button1, label: lblSocialNeeds, isSelected: true, fill: true)
            setupPageButtonUI(button: button2, label: lblMental, isSelected: true, fill: true)
            setupPageButtonUI(button: button3, label: lblBodyComposition, isSelected: true)
        }
    }

    private func setupPageButtonUI(button: UIButton,
                                   label: UILabel,
                                   isSelected: Bool = false,
                                   fill: Bool = false) {
        let color: UIColor = isSelected ? HRThemeColor.blue : HRThemeColor.gray
        button.tintColor = fill ? HRThemeColor.white : color
        button.backgroundColor = fill ? HRThemeColor.blue : HRThemeColor.white
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 1
        label.textColor = color
    }

    func collapseViewPageContainer() {
        constraintPageHeight.constant = 0
        constraintTop.constant = -30
        viewPageContainer.isHidden = true
    }

    func expandViewPageContainer() {
        constraintPageHeight.constant = 60
        constraintTop.constant = 30
        viewPageContainer.isHidden = false
    }

    func stickPageContainerToBottom() {
        constraintPageContainerBottom.constant = 0
    }

    func resetPageContainerBottomSpace() {
        constraintPageContainerBottom.constant = 100
    }
}
