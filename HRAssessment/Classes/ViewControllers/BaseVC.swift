import UIKit

public class BaseVC: UIViewController {
    
    // MARK: Properties
    private var offsetY: CGFloat = {
        var offsetY: CGFloat = 10
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            offsetY += windowScene.statusBarManager?.statusBarFrame.height ?? 0.0
        }
        return offsetY
    }()
    
    private lazy var navigationView : UIImageView = {
        let navigationView = UIImageView(frame: CGRect(origin: .zero,
                                                       size: .init(width: UIApplication.shared.screenWidth,
                                                                   height: 150)))
        navigationView.backgroundColor = HRThemeColor.navigationBackgroundColor
        navigationView.image = HRImageAsset.navigation_bar.image
        navigationView.isUserInteractionEnabled = true
        return navigationView
    }()
    
    private lazy var backButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.image = HRImageAsset.back_arrow.image

        let button = UIButton(configuration: config)
        button.frame = CGRect(x: 10, y: offsetY, width: 30, height: 30)
        button.addTarget(self,
                         action: #selector(onTapNavBarLeftButton),
                         for: .touchUpInside)
        return button
    }()
    
    lazy var navBarTitleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 50, y: offsetY - 5,
                                          width: UIApplication.shared.screenWidth - 50, height: 40))
        label.font = HRFonts.navigationTitle
        label.textColor = HRThemeColor.white
        return label
    }()
    
    lazy var navSkipButton: UIButton = {
        // Navigation bar Skip button
        let navSkipButton = UIButton(frame: CGRect(x: Int(UIApplication.shared.screenWidth - 100),
                                                   y: Int(offsetY),
                                                   width: 100, height: 30))
        navSkipButton.setAttributedTitle(NSAttributedString(string: "Skip",
                                                            attributes: [.font: HRFonts.navigationTitle]),
                                         for: .normal)
        navSkipButton.setTitleColor(HRThemeColor.white, for: .normal)
        navSkipButton.isHidden = true
        navSkipButton.addTarget(self, action: #selector(onTapNavBarSkipButton), for: .touchUpInside)
        return navSkipButton
    }()
    
    lazy var navShareButton: UIButton = {
        // Navigation bar Share button
        var config = UIButton.Configuration.borderless()
        config.image = HRImageAsset.icon_share.image
        config.imagePadding = 5
        config.imagePlacement = .leading
        config.baseForegroundColor = .white

        let navShareButton = UIButton(configuration: config)
        navShareButton.frame = CGRect(x: Int(UIApplication.shared.screenWidth - 50),
                                      y: Int(offsetY),
                                      width: 30, height: 30)
        navShareButton.isHidden = true
        navShareButton.addTarget(self, action: #selector(onTapNavBarShareButton),
                                 for: .touchUpInside)
        return navShareButton
    }()
    
    // MARK: Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar()
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: Actions
    @objc func onTapNavBarLeftButton() {
        navigationController?.popViewController(animated: true)
    }

    @objc func onTapNavBarSkipButton() {
        
    }

    @objc func onTapNavBarShareButton() {

    }

    // MARK: Functions
    private func createNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(navigationView)
        navigationView.addSubview(backButton)
        navigationView.addSubview(navBarTitleLabel)
        navigationView.addSubview(navShareButton)
        navigationView.addSubview(navSkipButton)
    }
}