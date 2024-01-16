
import UIKit
import AVFoundation
import AVKit

protocol VideoRecordingDelegate {
    var gender: UserProfile.Gender { get }
    func uploadVideo(fileURL: URL)
}

final class VideoRecordingVC: BaseVC {

    // MARK: IBOutlets
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var constraintGifViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintGifViewWidth: NSLayoutConstraint!

    @IBOutlet weak var viewFrame: UIView!
    @IBOutlet weak var viewSpinner: UIView!
    @IBOutlet weak var lblSpin: UILabel!
    
    @IBOutlet weak var lblInstructions: UILabel!
    @IBOutlet weak var btnPlayPause: UIButton!
    
    @IBOutlet weak var imgRecording: UIImageView!
    @IBOutlet weak var lblRecording: UILabel!

    // MARK: Properties
    var isRecordingDone: Bool = false
    var delegate: VideoRecordingDelegate?
    
    private var gender: UserProfile.Gender { delegate?.gender ?? .female }
    private let movieOutput = AVCaptureMovieFileOutput()
    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .high
        return session
    }()
    
    private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.videoGravity = .resizeAspectFill
        return layer
    }()

    private lazy var circularLoader: CAShapeLayer = {
        let loader = CAShapeLayer()
        loader.strokeColor = UIColor.green.cgColor
        loader.lineWidth = 10
        loader.lineCap = .round
        loader.fillColor = UIColor.clear.cgColor
        loader.strokeEnd = 1
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 50, y: 50),
                                        radius: 50,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 2 * CGFloat.pi - CGFloat.pi / 2,
                                        clockwise: true)
        loader.path = circularPath.cgPath
        return loader
    }()
    
    private lazy var counterLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, 
                                        width: 100, height: 100))
        lbl.center = view.center
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 40)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.isHidden = true
        return lbl
    }()
            
    private var audioPlayer: AVAudioPlayer?
    private let screenInstructions: [String] = [
        String(localizedKey: "camera.instructions.1"), //"Phone is under the window or a well lit room",
        String(localizedKey: "camera.instructions.2"), //"Take 2 steps away from your phone",
        String(localizedKey: "camera.instructions.3"), //"Position Yourself",
        String(localizedKey: "camera.instructions.4"), //"No windows or lights in the background",
        String(localizedKey: "camera.instructions.5")  //"Bellybutton is visible"
    ]
    private let audiosFileName: [String] = [
        "assessment_1",
        "assessment_2",
        "assessment_3",
        "assessment_4",
        "assessment_5_female",
        "a6_recording_time_info",
        "a7_after_countdown_info",
        "a8_raise_hands_as_PIP",
        "a9_pose_time_info",
        "a10_pose_timer",
        "a11_start_beep",
        "a12_recording_time"
    ]
    
    private var currentAudio: Int = 0
    private var videoFileUrl: URL?

    private var isCapturing = false {
        didSet {
            if isCapturing {
                btnPlayPause.isSelected = true
                let title = screenInstructions[currentAudio]
                let fileName = audiosFileName[currentAudio]
                playAudioFromLocalFile(title: title, audioFileName: fileName)
            } else {
                btnPlayPause.isSelected = false
                audioPlayer?.pause()
            }
        }
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navBarTitleLabel.text = String(localizedKey: "nav.title.video_recording")
        
        view.bringSubviewToFront(viewContainer)
        viewContainer.roundTopCorners(radius: 30)
        
        imgRecording.isHidden = true
        lblRecording.isHidden = true
        lblSpin.isHidden = true
        lblInstructions.text = ""

        btnPlayPause.layer.cornerRadius = btnPlayPause.frame.width / 2
        btnPlayPause.layer.borderWidth = 4
        btnPlayPause.layer.borderColor = HRThemeColor.white.cgColor
        
        let image = HRImageAsset.icon_filled_circle.image
        btnPlayPause.setImage(image, for: .normal)

        let imageSelected = HRImageAsset.icon_filled_square.image
        btnPlayPause.setImage(imageSelected, for: .selected)
        btnPlayPause.tintColor = .clear

        setupVideoRecorder()
        
        createSpin()
        viewContainer.bringSubviewToFront(viewFrame)
        viewContainer.bringSubviewToFront(btnPlayPause)
        viewContainer.bringSubviewToFront(lblInstructions)
        viewContainer.bringSubviewToFront(viewSpinner)
        viewContainer.bringSubviewToFront(lblSpin)
        viewContainer.bringSubviewToFront(gifImageView)
        hackAVAudioPlayerToCircumventDelay()
    }
    
    private func hackAVAudioPlayerToCircumventDelay() {
        guard let path = Bundle.HRAssessment.path(forResource: "a11_start_beep", ofType: "mp3") else {
            return
        }
        
        audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        audioPlayer?.setVolume(0, fadeDuration: 0)
        audioPlayer?.play()
        audioPlayer?.stop()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer.frame = viewContainer.layer.bounds
    }
    
    // MARK: IBActions
    @IBAction func onTapPlayPause(_ sender: Any) {
        isCapturing = !isCapturing
    }
    
    // MARK: Functions
    private func setupVideoRecorder() {
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, 
                                                        for: .video,
                                                        position: .front),
              let input = try? AVCaptureDeviceInput(device: frontCamera) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        captureSession.addInput(input)
        captureSession.addOutput(movieOutput)
        
        // Setup the preview layer
        videoPreviewLayer.frame = viewContainer.layer.bounds
        viewContainer.layer.addSublayer(videoPreviewLayer)
        
        // Start the session
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }

    func playAudioFromLocalFile(title: String?, audioFileName: String) {
        lblInstructions.text = title ?? ""
        
        var fileName = audioFileName
        if audioFileName == "assessment_5_female", gender == .male {
            fileName = "assessment_5_Male"
        }

        guard let path = Bundle.HRAssessment.path(forResource: fileName, ofType: "mp3") else {
            return
        }

        let url = URL(fileURLWithPath: path)

        do {
            // Initialize the AVAudioPlayer with the audio file URL
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.setVolume(1, fadeDuration: 0)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error)")
        }
    }
    
    func startRecording() {
        startPulsatingAnimation()
        
        if movieOutput.isRecording {
            movieOutput.stopRecording()
        } else {
            guard let documentsDirectory = FileManager.default.urls(
                for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            
            let videoFilename = "assessment_\(Date()).mov"
            let fileURL = documentsDirectory.appendingPathComponent(videoFilename)
            movieOutput.startRecording(to: fileURL, recordingDelegate: self)
        }
    }
    
    func stopRecording() {
        isRecordingDone = true
        movieOutput.stopRecording()
    }
    
    private func showGif() {
        constraintGifViewWidth.constant = viewFrame.frame.width
        constraintGifViewHeight.constant = viewFrame.frame.height
        
        gifImageView.backgroundColor = .clear
        gifImageView.load(gif: HRGIF.guidanceFor(gender))
    }
    
    private func showCompletionPopup() {
        let alert = UIAlertController(title: "", 
                                      message: String(localizedKey: "camera.alert.recording_completion_msg"),
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: String(localizedKey: "camera.alert.reshoot"),
                                      style: .default,
                                      handler: { [weak self] _ in
            
            guard let self else { return }
            self.currentAudio = 0
            
            self.btnPlayPause.isHidden = false
            self.lblInstructions.isHidden = false
            self.btnPlayPause.isSelected = false

            let title = self.screenInstructions[self.currentAudio]
            let fileName = self.audiosFileName[self.currentAudio]
            
            self.playAudioFromLocalFile(title: title, audioFileName: fileName)
            
            DispatchQueue.global().async {
                self.deleteRecordedVideo()
            }
        }))
        
        alert.addAction(UIAlertAction(title: String(localizedKey: "camera.alert.ok"),
                                      style: .default,
                                      handler: { [weak self] _ in
            
            guard let self, let url = self.videoFileUrl else { return }
            self.delegate?.uploadVideo(fileURL: url)
        }))

        present(alert, animated: true, completion: nil)
    }
    
    private func deleteRecordedVideo() {
        guard let videoFileUrl else { return }
        do {
            try FileManager.default.removeItem(at: videoFileUrl)
            print("Successfully deleted video at \(videoFileUrl)")
        } catch {
            print("Error deleting video at \(videoFileUrl): \(error.localizedDescription)")
        }
    }
    
    private func createSpin() {
        viewSpinner.layer.addSublayer(circularLoader)
        viewSpinner.addSubview(counterLabel)
        
        viewSpinner.isHidden = true
        counterLabel.isHidden = true
        lblSpin.isHidden = true
        
        NSLayoutConstraint.activate([
            counterLabel.centerXAnchor.constraint(equalTo: viewSpinner.centerXAnchor),
            counterLabel.centerYAnchor.constraint(equalTo: viewSpinner.centerYAnchor)
        ])
    }
    
    private func startLoader(title: String, duration: Int, color: UIColor) {
        
        lblSpin.text = title
        lblSpin.textColor = color
        counterLabel.textColor = color
        counterLabel.text = duration.description
        circularLoader.strokeColor = color.cgColor

        counterLabel.isHidden = false
        viewSpinner.isHidden = false
        lblSpin.isHidden = false
        addCircularLoaderAnimation(duration: duration)
        
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(updateCounter(timer:)),
                             userInfo: nil,
                             repeats: true)
    }
    
    private func addCircularLoaderAnimation(duration: Int) {
        // Create a basic animation for the strokeEnd property
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 1
        animation.toValue = 0
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = CFTimeInterval(duration) //Duration in seconds

        // Add the animation to the circular loader layer
        circularLoader.removeAllAnimations()
        circularLoader.add(animation, forKey: "strokeEnd")
    }

    @objc func updateCounter(timer: Timer) {
        guard let text = counterLabel.text, let value = Int(text) else {
            return
        }
        
        if value > 1 {
            // Update the counter label with the new value
            counterLabel.text = "\(value - 1)"
        } else {
            counterLabel.isHidden = true
            viewSpinner.isHidden = true
            lblSpin.isHidden = true
            timer.invalidate()
        }
    }
    
    func startPulsatingAnimation() {
        imgRecording.isHidden = isRecordingDone
        lblRecording.isHidden = isRecordingDone
        
        guard !isRecordingDone else { return }
                
        UIView.animate(withDuration: 0.3,
                       animations: { self.imgRecording.alpha = 0 },
                       completion: { _ in
        
            UIView.animate(withDuration: 0.3,
                           animations: { self.imgRecording.alpha = 1 },
                           completion: { _ in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.startPulsatingAnimation()
                }
            })
        })
    }
    
    private func animateGifView() {
        UIView.animate(withDuration: 0.5) {
            self.constraintGifViewWidth.constant = 122
            self.constraintGifViewHeight.constant = 275
        }
    }
}

extension VideoRecordingVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        currentAudio += 1
        if currentAudio < 5 {
//            let instructions = screenInstructions[currentAudio]
            let fileName = audiosFileName[currentAudio]
            playAudioFromLocalFile(title: title, audioFileName: fileName)
        } else if currentAudio == 5 || currentAudio == 6 {
            lblInstructions.isHidden = true
            btnPlayPause.isHidden = true
            
            viewFrame.isHidden = false
            viewFrame.backgroundColor = .clear
            viewFrame.layer.borderWidth = 5
            viewFrame.layer.borderColor = HRThemeColor.green.cgColor
            
            let fileName = audiosFileName[currentAudio]
            playAudioFromLocalFile(title: nil, audioFileName: fileName)
        } else if currentAudio == 7 {
            gifImageView.isHidden = false
            showGif()
            let fileName = audiosFileName[currentAudio]
            playAudioFromLocalFile(title: nil, audioFileName: fileName)
        } else if currentAudio == 8 {
            // Animate GIF to bottom
            animateGifView()
            let fileName = audiosFileName[currentAudio]
            playAudioFromLocalFile(title: nil, audioFileName: fileName)
        } else if currentAudio == 9 {
            // Start the spin
            startLoader(title: String(localizedKey: "camera.loader.pose"),
                        duration: 5,
                        color: HRThemeColor.mustard)
            let fileName = audiosFileName[currentAudio]
            playAudioFromLocalFile(title: nil, audioFileName: fileName)
        } else if currentAudio == 10 {
            let fileName = audiosFileName[currentAudio]
            playAudioFromLocalFile(title: nil, audioFileName: fileName)
        } else if currentAudio == 11 {
            startRecording()
            
            startLoader(title: String(localizedKey: "camera.loader.spin"), 
                        duration: 10,
                        color: HRThemeColor.green)
            let fileName = audiosFileName[currentAudio]
            playAudioFromLocalFile(title: nil, audioFileName: fileName)
        } else {
            stopRecording()
            
            gifImageView.isHidden = true
            viewSpinner.isHidden = true
            viewFrame.isHidden = true
            lblSpin.isHidden = true
            showCompletionPopup()
        }
    }
}

extension VideoRecordingVC: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        
        guard error == nil else {
            return
        }
        
        videoFileUrl = outputFileURL
        print("Video recorded successfully to \(outputFileURL)")
    }
}
