
import UIKit

protocol SelfHealthVCDelegate: AnyObject {
    func selfHealthResponseUpdated(for question: SelfHealthReadinessQuestion,
                                   response: SelfHealthReadinessResponse)
    func selfHealthResponse(for question: SelfHealthReadinessQuestion) -> SelfHealthReadinessResponse?
    var selfHealthQuestions: [SelfHealthReadinessQuestion] { get }
}

final class SelfHealthReadinessVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    weak var delegate: SelfHealthVCDelegate!

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.font = HRFonts.regular16
        tableView.estimatedRowHeight = 160
        tableView.rowHeight = 160
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.flashScrollIndicators()
        
        delegate.selfHealthQuestions.forEach {
            sliderValueUpdated(question: $0, value: 5)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate.selfHealthQuestions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            type: SelfHealthReadinessCell.self,
            for: indexPath
        )
        let question = delegate.selfHealthQuestions[indexPath.row]
        cell.populate(question: question,
                      sliderValue: delegate.selfHealthResponse(for: question))
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: 156.0
        case 1: 174.0
        case 2: 192.0
        case 3: 140.0
        case 4: 174.0
        default: 0
        }
    }
}

extension SelfHealthReadinessVC: SelfHealthReadinessCellDelegate {
    func sliderValueUpdated(question: SelfHealthReadinessQuestion, value: Int) {
        delegate.selfHealthResponseUpdated(for: question, response: value)
    }
}
