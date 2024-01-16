
import UIKit
import AVKit

protocol VideoPlayerVCDelegate: AnyObject {
    func startVideoRecording()
    func backButtonTapped()
}

final class VideoPlayerVC: BaseVC {

    // MARK: IBOutlets
    @IBOutlet weak var viewContainer: UIView!

    // MARK: Properties
    var gender: UserProfile.Gender = .male
    weak var delegate: VideoPlayerVCDelegate!

    private lazy var playerViewController: AVPlayerViewController = {
        let playerViewController = AVPlayerViewController()
        playerViewController.view.backgroundColor = .clear
        playerViewController.videoGravity = .resizeAspect
        playerViewController.showsPlaybackControls = false
        playerViewController.player = player
        return playerViewController
    }()

    private lazy var playerItem: AVPlayerItem = {
        let file = HRVideo.guidance(gender)
        let url = URL(fileURLWithPath: file.path)
        return AVPlayerItem(url: url)
    }()

    private lazy var player: AVPlayer = {
        let player = AVPlayer(playerItem: playerItem)
        player.volume = 1
        return player
    }()

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navSkipButton.isHidden = false
        navBarTitleLabel.text = String(localizedKey: "nav.title.how_to_record")
        view.bringSubviewToFront(viewContainer)
        viewContainer.backgroundColor = HRThemeColor.black
        viewContainer.roundTopCorners(radius: 30)
        addPlayerViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Add an observer for the AVPlayerItemDidPlayToEndTime notification
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(videoDidFinishPlaying(_:)),
                         name: .AVPlayerItemDidPlayToEndTime,
                         object: playerItem)

        player.play()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false

        player.pause()
        player.seek(to: .zero)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemDidPlayToEndTime,
                                                  object: playerItem)
    }

    override func onTapNavBarSkipButton() {
        player.pause()
        showOptionPopup()
    }
    
    override func onTapNavBarLeftButton() {
        delegate.backButtonTapped()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Functions
    @objc func videoDidFinishPlaying(_ notification: Notification) {
        showOptionPopup()
    }
    
    fileprivate func addPlayerViewController() {
        addChild(playerViewController)
        playerViewController.view.frame = viewContainer.bounds
        viewContainer.addSubview(playerViewController.view)
        playerViewController.didMove(toParent: self)
    }
}

// MARK: Functions
extension VideoPlayerVC {
    func showOptionPopup() {
        player.pause()
        
        // Create the UIAlertController
        let actionSheet = UIAlertController()

        actionSheet.addAction(UIAlertAction(title: String(localizedKey: "camera.start_recording"),
                                            style: .destructive,
                                            handler: { _ in
            self.delegate.startVideoRecording()
        }))
        
        actionSheet.addAction(UIAlertAction(title: String(localizedKey: "camera.watch_again"),
                                            style: .default,
                                            handler: { _ in
            self.playerViewController.showsPlaybackControls = true
            self.player.seek(to: .zero)
            self.player.play()
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
}
