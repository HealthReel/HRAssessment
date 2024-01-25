
import UIKit

protocol DassAssessmentVCDelegate: AnyObject {
    var dassAssessmentQuestions: [DASSQuestion] { get }
    func dassResponseRecieved(for question: DASSQuestion, response: DASSResponse)
    func response(for question: DASSQuestion) -> DASSResponse?
}

final class DassAssessmentVC: UIViewController, HRPageViewIndexed {

    // MARK: IBOutlets
    @IBOutlet weak var lable: UILabel!
    
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!

    // MARK: Properties
    weak var delegate: DassAssessmentVCDelegate!
    var index: Int = 0

    var dassQuestion: DASSQuestion {
        delegate.dassAssessmentQuestions[index]
    }

    private var allButtons: [UIButton] {
        [btn0, btn1, btn2 ,btn3]
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        lable.text = dassQuestion.title
        allButtons.forEach {
            setupButton(button: $0)
        }

        guard let delegate,
              let response = delegate.response(for: dassQuestion) else { return }

        selectedButtonUI(button: getButton(for: response))
    }
    
    // MARK: IBActions
    @IBAction func onTapBtn0(_ sender: UIButton) {
        selectedButtonUI(button: sender)
        delegate.dassResponseRecieved(for: dassQuestion, response: .zero)
    }

    @IBAction func onTapBtn1(_ sender: UIButton) {
        selectedButtonUI(button: sender)
        delegate.dassResponseRecieved(for: dassQuestion, response: .one)
    }

    @IBAction func onTapBtn2(_ sender: UIButton) {
        selectedButtonUI(button: sender)
        delegate.dassResponseRecieved(for: dassQuestion, response: .two)
    }
    @IBAction func onTapBtn3(_ sender: UIButton) {
        selectedButtonUI(button: sender)
        delegate.dassResponseRecieved(for: dassQuestion, response: .three)
    }

    // MARK: Functions
    private func setupButton(button: UIButton) {
        button.backgroundColor = HRThemeColor.white
        button.tintColor = HRThemeColor.blue
        
        // To round the corners
        button.layer.cornerRadius = 4
        button.layer.borderColor = HRThemeColor.lightgray.cgColor
        button.layer.borderWidth = 1
      
        // To provide the shadow
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowColor = HRThemeColor.lightgray.cgColor
        button.layer.masksToBounds = false
    }
    
    private func selectedButtonUI(button: UIButton) {
        allButtons.forEach {
            setupButton(button: $0)
        }

        button.backgroundColor = HRThemeColor.blue
        button.tintColor = HRThemeColor.white
    }

    private func getButton(for response: DASSResponse) -> UIButton {
        switch response {
        case .zero: return btn0
        case .one: return btn1
        case .two: return btn2
        case .three: return btn3
        }
    }
}
