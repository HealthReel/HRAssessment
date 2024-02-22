
import UIKit
import AVFoundation
import AVKit

protocol VideoRecordingDelegate: AnyObject {
    var gender: UserProfile.Gender { get }
    func uploadVideo(fileURL: URL, delegate: APIServiceDelegate)
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
    weak var delegate: VideoRecordingDelegate?
    var isRecordingDone: Bool = false
    
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
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        lbl.center = view.center
        lbl.screenInstructionify()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.isHidden = true
        return lbl
    }()
    
    private var instructions = Instructions.allCases
    private var audioPlayer: AVAudioPlayer?

    private var currentInstruction = Instructions.assessment_1 {
        didSet {
            DispatchQueue.main.async { self.updateUI() }
            playAudio(fileName: currentInstruction.filename(for: gender))
        }
    }
    
    private var videoFileUrl: URL?
    private var paused: Bool = false
    private var isCapturing = false {
        didSet {
            if isCapturing {
                btnPlayPause.isSelected = true
                if paused { paused = audioPlayer?.play() ?? false }
                else { currentInstruction = Instructions.assessment_1 }
            } else {
                btnPlayPause.isSelected = false
                audioPlayer?.pause()
                paused = true
            }
        }
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navBarTitleLabel.text = String(localizedKey: "nav.title.video_recording")
        
        view.bringSubviewToFront(viewContainer)
        viewContainer.roundTopCorners(radius: 30)
        
        viewFrame.isHidden = true
        viewFrame.backgroundColor = .clear
        viewFrame.layer.borderWidth = 5
        viewFrame.layer.borderColor = HRThemeColor.green.cgColor

        imgRecording.isHidden = true
        lblRecording.isHidden = true
        lblSpin.isHidden = true
        lblSpin.screenInstructionify()
    
        lblInstructions.text = ""
        lblInstructions.screenInstructionify()
    
        btnPlayPause.layer.cornerRadius = btnPlayPause.frame.width / 2
        btnPlayPause.layer.borderWidth = 4
        btnPlayPause.layer.borderColor = HRThemeColor.white.cgColor
        
        btnPlayPause.setImage(HRImageAsset.icon_filled_circle.image, for: .normal)
        btnPlayPause.setImage(HRImageAsset.icon_filled_square.image, for: .selected)
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
        guard let path = Bundle.HRAssessment.path(
            forResource: "a11_start_beep", ofType: "mp3"
        ) else {
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

    func playAudio(fileName: String) {
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
            debugPrint("Error playing audio: \(error)")
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
            self.currentInstruction = .assessment_1
            
            self.btnPlayPause.isHidden = false
            self.lblInstructions.isHidden = false
            self.btnPlayPause.isSelected = false
            
            DispatchQueue.global().async {
                self.deleteRecordedVideo()
            }
        }))
        
        alert.addAction(UIAlertAction(title: String(localizedKey: "camera.alert.ok"),
                                      style: .default,
                                      handler: { [weak self] _ in
            
            guard let self, let url = self.videoFileUrl else { return }
            self.delegate?.uploadVideo(fileURL: url, delegate: self)
        }))

        present(alert, animated: true, completion: nil)
    }
    
    private func deleteRecordedVideo() {
        guard let videoFileUrl else { return }
        do {
            try FileManager.default.removeItem(at: videoFileUrl)
            debugPrint("Successfully deleted video at \(videoFileUrl)")
        } catch {
            debugPrint("Error deleting video at \(videoFileUrl): \(error.localizedDescription)")
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
    
    private func animateGifViewToBottom() {
        UIView.animate(withDuration: 0.5) {
            self.constraintGifViewWidth.constant = 122
            self.constraintGifViewHeight.constant = 275
        }
    }
}

extension VideoRecordingVC: AVAudioPlayerDelegate {
    private func updateUI() {
        lblInstructions.text = currentInstruction.screenPrompt

        switch currentInstruction {
        case .assessment_1, .assessment_2, .assessment_3, .assessment_4, .assessment_5, .a11_start_beep:
            break
            
        case .a6_recording_time_info, .a7_after_countdown_info:
            btnPlayPause.isHidden = true
            viewFrame.isHidden = false
            
        case .a8_raise_hands_as_PIP:
            gifImageView.isHidden = false
            showGif()
            
        case .a9_pose_time_info:
            animateGifViewToBottom()
        case .a10_pose_timer:
            startLoader(title: String(localizedKey: "camera.loader.pose"),
                        duration: 5,
                        color: HRThemeColor.mustard)
        case .a12_recording_time:
            startRecording()
            startLoader(title: String(localizedKey: "camera.loader.spin"),
                        duration: 10,
                        color: HRThemeColor.green)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let next = currentInstruction.next {
            currentInstruction = next
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
        debugPrint("Video recorded successfully to \(outputFileURL)")
    }
}

extension VideoRecordingVC: APIServiceDelegate {
    func reportGeneratedSuccessfully() {
        let title = String(localizedKey: "camera.success")
        let message = String(localizedKey: "camera.report_generated_successfully")
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: String(localizedKey: "camera.alert.ok"),
                                      style: .default,
                                      handler: { [weak self] _ in
            self?.deleteRecordedVideo()
            self?.navigationController?.popToRootViewController(animated: true)
        }))

        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func reportGenerationFailed() {
        let title = String(localizedKey: "camera.failure")
        let message = String(localizedKey: "camera.report_generation_failed")
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: String(localizedKey: "camera.retry"),
                                      style: .default,
                                      handler: { [weak self] _ in
            guard let self, let url = self.videoFileUrl else { return }
            self.delegate?.uploadVideo(fileURL: url, delegate: self)
        }))
        
        alert.addAction(UIAlertAction(title: String(localizedKey: "camera.alert.ok"),
                                      style: .default,
                                      handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))

        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

private extension VideoRecordingVC {
    enum Instructions: Int, CaseIterable {
        case assessment_1
        case assessment_2
        case assessment_3
        case assessment_4
        case assessment_5
        case a6_recording_time_info
        case a7_after_countdown_info
        case a8_raise_hands_as_PIP
        case a9_pose_time_info
        case a10_pose_timer
        case a11_start_beep
        case a12_recording_time
        
        func filename(for gender: UserProfile.Gender) -> String {
            return switch self {
            case .assessment_1: "assessment_1"
            case .assessment_2: "assessment_2"
            case .assessment_3: "assessment_3"
            case .assessment_4: "assessment_4"
            case .assessment_5:
                gender == .male ? "assessment_5_Male" : "assessment_5_female"
            case .a6_recording_time_info: "a6_recording_time_info"
            case .a7_after_countdown_info: "a7_after_countdown_info"
            case .a8_raise_hands_as_PIP: "a8_raise_hands_as_PIP"
            case .a9_pose_time_info: "a9_pose_time_info"
            case .a10_pose_timer: "a10_pose_timer"
            case .a11_start_beep: "a11_start_beep"
            case .a12_recording_time: "a12_recording_time"
            }
        }
        
        var screenPrompt: String {
            return switch self {
            case .assessment_1: 
                String(localizedKey: "camera.instructions.1") 
                //"Phone is under the window or a well lit room",
            case .assessment_2:
                String(localizedKey: "camera.instructions.2") 
                //"Take 2 steps away from your phone",
            case .assessment_3:
                String(localizedKey: "camera.instructions.3") 
                //"Position Yourself",
            case .assessment_4:
                String(localizedKey: "camera.instructions.4") 
                //"No windows or lights in the background",
            case .assessment_5:
                String(localizedKey: "camera.instructions.5")  
                //"Bellybutton is visible"
            default: ""
            }
        }
        
        var next: Self? {
            .init(rawValue: rawValue + 1)
        }
    }
}

fileprivate extension UILabel {
    func screenInstructionify() {
        textAlignment = .center
        font = HRFonts.recordingInstruction
        shadowColor = HRThemeColor.gray.withAlphaComponent(0.5)
        shadowOffset = .init(width: 0, height: 1)
    }
}
