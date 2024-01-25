
import UIKit

protocol DassDescVCProtocol: AnyObject {
    func startDassAssessment()
}

final class DassDescVC: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var viewRatingHint: UIView!
    @IBOutlet weak var btnStart: UIButton!

    // MARK: Properties
    weak var delegate: DassDescVCProtocol?

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        contentScrollView.isScrollEnabled = true
        viewRatingHint.addRounderBorder(borderColor: HRThemeColor.blue,
                                        radius: 15)
        btnStart.makeCircular()
        btnStart.backgroundColor = HRThemeColor.blue
        btnStart.setAttributedTitle(.init(string: "Start", attributes: [
            .font: HRFonts.medium16, .foregroundColor: UIColor.white
        ]), for: .normal)
    }
    
    // MARK: IBActions
    @IBAction func onTapBtnStart(_ sender: Any) {
        delegate?.startDassAssessment()
    }
}
