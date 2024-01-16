
import UIKit

protocol SelfHealthReadinessCellDelegate: AnyObject {
    func sliderValueUpdated(question: SelfHealthReadinessQuestion, value: Int)
}

final class SelfHealthReadinessCell: UITableViewCell {
    @IBOutlet weak var quesNumber: UILabel!
    @IBOutlet weak var quesTitle: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var stepSlider: HRStepSlider!

    weak var delegate: SelfHealthReadinessCellDelegate?

    var question: SelfHealthReadinessQuestion?

    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        stepSlider.addTarget(self,
                             action: #selector(sliderValueChanged),
                             for: .valueChanged)
        
        [quesNumber, quesTitle].forEach {
            $0?.font = HRFonts.regular16
        }
        
        cardView.addRounderBorder(borderWidth: 1,
                                  borderColor: HRThemeColor.lightblue,
                                  radius: 4)
    }

    @objc private func sliderValueChanged() {
        if let question {
            delegate?.sliderValueUpdated(question: question, value: stepSlider.intValue)
        }
    }

    func populate(question: SelfHealthReadinessQuestion, sliderValue: SelfHealthReadinessResponse?) {
        self.question = question
        quesNumber.text = "Q\(question.number)."
        quesTitle.text = question.question
        stepSlider.set(value: sliderValue ?? stepSlider.defaultValue)
    }
}
