
import UIKit

protocol PregnantVCDelegate {
    func responseRecieved(_ response: PregnantVC.Response)
    var response: PregnantVC.Response? { get }
}

extension PregnantVC {
    enum Response: String {
        case yes = "Yes"
        case no = "No"
    }
}

final class PregnantVC: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    // MARK: Properties
    var delegate: PregnantVCDelegate!
    var index = 0

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.font = HRFonts.heading
        questionLabel.font = HRFonts.regular20

        let attr: [NSAttributedString.Key:Any] = [
            .font: HRFonts.medium16, .foregroundColor: HRThemeColor.blue
        ]
        btnYes.setAttributedTitle(.init(string: "Yes", attributes: attr),
                                  for: .normal)
        btnNo.setAttributedTitle(.init(string: "No", attributes: attr),
                                 for: .normal)
        [btnYes, btnNo].forEach {
            $0?.makeCircular()
            $0?.dropShadow()
        }
        
        switch delegate.response {
        case .no:
            selectButton(btnNo)
            deselectButton(btnYes)
        case .yes:
            selectButton(btnYes)
            deselectButton(btnNo)
        case .none:
            deselectButton(btnYes)
            deselectButton(btnNo)
        }
    }
    
    // MARK: IBActions
    @IBAction func onTapBtnYes(_ sender: UIButton) {
        selectButton(sender)
        delegate.responseRecieved(.yes)
    }
    
    @IBAction func onTapBtnNo(_ sender: UIButton) {
        selectButton(sender)
        delegate.responseRecieved(.no)
    }

    private func selectButton(_ button: UIButton) {
        button.backgroundColor = HRThemeColor.blue
        button.setTitleColor(HRThemeColor.white, for: .normal)
    }

    private func deselectButton(_ button: UIButton) {
        button.backgroundColor = HRThemeColor.white
        button.setTitleColor(HRThemeColor.blue, for: .normal)
    }
}
