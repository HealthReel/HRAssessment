
import AVFoundation
import UIKit

protocol SocialNeedsVCDelegate {
    var socialNeedQuestionnaire: [SocialNeedsQuestion] { get }
    func response(for socialNeed: SocialNeedsQuestion) -> SocialNeedsResponse?
    func selectSocialNeeds(socialNeed: SocialNeedsQuestion, option: SocialNeedsResponse)
}

final class SocialNeedsVC: UIViewController, HRPageViewIndexed {

    // MARK: Properties
    var index = 0
    var delegate: SocialNeedsVCDelegate!

    var socialNeed: SocialNeedsQuestion {
        delegate.socialNeedQuestionnaire[index]
    }

    // MARK: IBOulets
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblSubtext: UILabel!
    @IBOutlet weak var tableView: UITableView!

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblHeading.text = socialNeed.category
        lblQuestion.text = socialNeed.question
        lblSubtext.text = socialNeed.subtext

        lblHeading.font = HRFonts.heading
        lblQuestion.font = HRFonts.regular20
        lblSubtext.font = HRFonts.regular16

        tableView.backgroundColor = HRThemeColor.white
        tableView.dataSource = self
        tableView.rowHeight = 60
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sizeHeaderToFit()
    }

    private func sizeHeaderToFit() {
        guard let headerView = tableView.tableHeaderView else { return }
        headerView.layoutIfNeeded()

        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
        var frame = headerView.frame
        frame.size.height = height + 30
        headerView.frame = frame

        tableView.tableHeaderView = headerView
    }
}

extension SocialNeedsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        socialNeed.options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: SocialNeedResponseCell.self, for: indexPath)
        let option = socialNeed.options[indexPath.row]
        let response = delegate?.response(for: socialNeed)
        cell.setupUI(title: String(localizedKey: option.rawValue),
                     isSelected: option == response)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = socialNeed.options[indexPath.row]
        delegate?.selectSocialNeeds(socialNeed: socialNeed, option: selectedOption)
        tableView.reloadData()
    }
}

extension String.LocalizationValue {
    
}
