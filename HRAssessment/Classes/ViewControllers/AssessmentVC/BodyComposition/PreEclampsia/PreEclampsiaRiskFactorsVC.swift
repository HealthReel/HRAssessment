
import UIKit

protocol RiskFactorVCDelegate: AnyObject {
    var preEclampsiaQuestions: [PreEclampsiaQuestion] { get }
    func response(for question: PreEclampsiaQuestion) -> PreEclampsiaResponse
    func responseUpdated(for question: PreEclampsiaQuestion, response: PreEclampsiaResponse)
}

final class PreEclampsiaRiskFactorsVC: BaseVC, HRPageViewIndexed {

    // MARK: IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintsTableViewHeight: NSLayoutConstraint!
       
    // MARK: Properties
    weak var delegate: RiskFactorVCDelegate!
    var index: Int = 1

    var riskFactors: [String] {
        preEclampsiaQuestion.options
    }

    var preEclampsiaQuestion: PreEclampsiaQuestion {
        delegate.preEclampsiaQuestions[index]
    }

    var selectedRiskFactors: Set<String> = .init() {
        didSet {
            delegate.responseUpdated(for: preEclampsiaQuestion, 
                                     response: selectedRiskFactors)
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = HRThemeColor.white
        view.bringSubviewToFront(viewContainer)

        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self

        lblTitle.text = preEclampsiaQuestion.title
        lblTitle.font = HRFonts.regular16
        
        constraintsTableViewHeight.constant = CGFloat(riskFactors.count * 30)
    }
}

// MARK: UITableView Delegate and Datasource
extension PreEclampsiaRiskFactorsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        riskFactors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: RiskFactorTableViewCell.self, for: indexPath)
        let riskFactor = riskFactors[indexPath.row]
        cell.setup(title: riskFactor)
        cell.isSelected = delegate.response(for: preEclampsiaQuestion).contains(riskFactor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RiskFactorTableViewCell else {
            return
        }
        cell.isSelected = true
        selectedRiskFactors.insert(riskFactors[indexPath.row])
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RiskFactorTableViewCell else {
            return
        }
        cell.isSelected = false
        selectedRiskFactors.remove(riskFactors[indexPath.row])
    }
}
