
import UIKit

final class ReportsTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblTrend: UILabel!
    @IBOutlet weak var iconTrend: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        [lblTitle, lblScore, lblTrend].forEach {
            $0?.font = HRFonts.reportText
        }
    }
    
    // MARK: Functions
    func populate(data: CategorisedReport.DataPoint, reportModel: ReportModel) {
        lblTitle.text = data.title
        
        guard let value = reportModel.valueFor(data.valueKey) else {
            lblScore.text = ""
            return
        }
        
        lblTitle.text = data.title
        lblScore.text = data.format(value: value)
        
        guard let trendKey = data.trendKey,
              let trend = reportModel.trendFor(trendKey) else {
            lblTrend.text = ""
            iconTrend.image = nil
            return
        }
        
        lblTrend.text = trend.value.string
        
        let color = trend.isPositive ? HRThemeColor.green : HRThemeColor.red
        lblTrend.textColor = color
        
        let iconTrendUp = HRImageAsset.icon_trend_up.image(with: color)
        let iconTrendDown = HRImageAsset.icon_trend_down.image(with: color)
    
        iconTrend.image = trend.hasIncreased ? iconTrendUp : iconTrendDown
        iconTrend.tintColor = color
    }
}

final class ReportSectionHeader: UITableViewHeaderFooterView {
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.backgroundColor = HRThemeColor.blue
        title.textColor = HRThemeColor.white
        title.font = HRFonts.reportHeader
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        title.addBorder(
            borderWidth: 1.5,
            borderColor: .gray
        )
        return title
    }()
    
    private let subTitleLabel: UILabel = {
        let subTitle = UILabel()
        subTitle.backgroundColor = HRThemeColor.white
        subTitle.textColor = HRThemeColor.gray
        subTitle.font = HRFonts.reportHeader
        subTitle.textAlignment = .center
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        return subTitle
    }()

    let sectionHeaderStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fillEqually
        stackview.alignment = .fill
        stackview.spacing = 0
        return stackview
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        sectionHeaderStackView.addArrangedSubviews([
            titleLabel,
            subTitleLabel
        ])
        contentView.addSubview(sectionHeaderStackView)

        subTitleLabel.isHidden = true
    }
    
    override func layoutSubviews() {
        sectionHeaderStackView.frame = bounds
        super.layoutSubviews()
    }
    
    func populate(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
