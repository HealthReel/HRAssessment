
import UIKit

protocol ActivityLevelVCDelegate: AnyObject {
    func activityLevelResponseUpdated(activityLevel: ActivityLevel)
    var activityLevelResponse: ActivityLevel { get }
}

final class ActivityLevelVC: UIViewController {

    weak var delegate: ActivityLevelVCDelegate!
    
    @IBOutlet weak var tableView: UITableView!

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ActivityLevelVC: UITableViewDataSource, UITableViewDelegate {
    private var datasource: [ActivityLevel] {
        ActivityLevel.allCases
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: ActivityLevelCell.self, for: indexPath)
        let activityLevel = datasource[indexPath.row]
        cell.populate(activityLevel: activityLevel,
                      selected: activityLevel == delegate.activityLevelResponse)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let activityLevel = ActivityLevel(rawValue: indexPath.row + 1) {
            delegate.activityLevelResponseUpdated(activityLevel: activityLevel)
        }
        tableView.reloadData()
    }
}

final class ActivityLevelCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var checkImageview: UIImageView!
    @IBOutlet weak var cardView: UIView!

    override var isSelected: Bool {
        didSet {
            setup()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setup()
    }

    func setup() {
        cardView.addRounderBorder(borderWidth: 1, borderColor: HRThemeColor.lightgray, radius: 4)
        cardView.backgroundColor = isSelected ? HRThemeColor.blue : HRThemeColor.white
        titleLabel.textColor = isSelected ? HRThemeColor.white : HRThemeColor.black
        subtitleLabel.textColor = isSelected ? HRThemeColor.white : HRThemeColor.gray
        subtitleLabel.font = isSelected ? .systemFont(ofSize: 14) : .systemFont(ofSize: 10)
        subtitleLabel.numberOfLines = 0
        checkImageview.isHidden = isSelected
    }

    func populate(activityLevel: ActivityLevel, selected: Bool) {
        isSelected = selected
        let (title, subtitle) = activityLevel.text
        titleLabel.text = title
        subtitleLabel.text = subtitle
        checkImageview.isHidden = isSelected
    }
}
