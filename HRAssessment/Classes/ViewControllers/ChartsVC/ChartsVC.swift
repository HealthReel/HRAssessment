
import UIKit
import DGCharts

final class ChartsVC: BaseVC {

    // MARK: IBOutlets
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblCurrentValue: UILabel!
    @IBOutlet weak var lblRecommendation: UILabel!
    @IBOutlet weak var lblCurrentValueSuffix: UILabel!
    @IBOutlet weak var lblRecommendationValueSuffix: UILabel!
    @IBOutlet weak var viewChart: UIView!
    
    var dataSource: [ChartData] = []
    
    // MARK: Properties
    private var lineChartView: LineChartView = {
        let lineChartView = LineChartView()
        
        // Enable horizontal scrolling
        lineChartView.dragXEnabled = true
        lineChartView.xAxis.drawLabelsEnabled = true

        // Hide labels on the Y-axis (left and right)
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.enabled = false
        
        // Set the date value formatter for the X-axis
        lineChartView.xAxis.valueFormatter = DateValueFormatter()
        
        // Set the X-axis to the bottom of the chart
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelTextColor = HRThemeColor.gray
        
        // Hide horizontal grid line
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false

        // Make vertical grid lines dotted
        lineChartView.xAxis.gridLineDashLengths = [4, 4]
        lineChartView.drawMarkers = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.highlightPerDragEnabled = false
        lineChartView.highlightPerTapEnabled = false
        lineChartView.setExtraOffsets(left: 15, top: 0, right: 0, bottom: 15)
        
        lineChartView.clipDataToContentEnabled = false
        lineChartView.clipValuesToContentEnabled = false
    
        lineChartView.clipsToBounds = false
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.isUserInteractionEnabled = true
        return lineChartView
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        collectionView.selectItem(at: .zero, animated: true, scrollPosition: .top)
        collectionView(collectionView, didSelectItemAt: .zero)
    }
    
    override func onTapNavBarLeftButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupViews() {
        navBarTitleLabel.text = String(localizedKey: "nav.title.charts")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        view.backgroundColor = HRThemeColor.white
        view.bringSubviewToFront(mainContainer)
        mainContainer.roundTopCorners(radius: 30)
        
        viewChart.clipsToBounds = false
    }
    
    private func chartEntries(_ values: [Point]) -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        for value in values {
            guard let date = dateFormatter.date(from: value.x) else {
                continue
            }
            entries.append(ChartDataEntry(x: date.timeIntervalSince1970,
                                          y: value.y))
        }
        
        return entries
    }
    
    private func lineChartDataSet(_ entries: [ChartDataEntry]) -> LineChartDataSet {
        let dataSet = LineChartDataSet(entries: entries, label: "")
        dataSet.label = nil
        dataSet.mode = .cubicBezier

        dataSet.lineWidth = 3
        dataSet.isDrawLineWithGradientEnabled = false
        dataSet.setColor(HRThemeColor.blue)

        dataSet.drawCirclesEnabled = false
        
        // Change value color
        dataSet.valueTextColor = HRThemeColor.blue
        dataSet.valueFont = HRFonts.medium16
        dataSet.fillColor = HRThemeColor.blue
        dataSet.fillAlpha = 1
        dataSet.drawFilledEnabled = true
        
        // Set value formatter for showing values up to 1 decimal place
        dataSet.valueFormatter = CustomValueFormatter()
        
        guard let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: [HRThemeColor.blue.cgColor, HRThemeColor.white.cgColor] as CFArray,
            locations: [1.0, 0.0]
        ) else {
            return dataSet
        }
        
        dataSet.fill = LinearGradientFill(gradient: gradient, angle: 90)
        
        return dataSet
    }
    
    private func recommendedChartDataSetFor(_ entry: ChartDataEntry?) -> LineChartDataSet {
        guard let entry else { return .init() }
        
        let entries = [
            entry,
            ChartDataEntry(
                x: entry.x + 5260000,
                y: Double(lblRecommendation.text ?? "0") ?? entry.y
            )
        ]
        
        let dataSet = LineChartDataSet(entries: entries, label: "")
        dataSet.mode = .horizontalBezier

        dataSet.lineWidth = 3
        dataSet.lineDashPhase = CGFloat(2.0)
        dataSet.lineDashLengths = [2, 3]
        dataSet.setColor(HRThemeColor.blue)

        dataSet.drawCirclesEnabled = true
        
        // Change value color
        dataSet.valueTextColor = HRThemeColor.blue
        dataSet.valueColors = [.clear, HRThemeColor.blue]
        dataSet.valueFont = HRFonts.medium16
        
        // Set value formatter for showing values up to 1 decimal place
        dataSet.valueFormatter = CustomValueFormatter()
        
        return dataSet
    }

    
    private func setupChart(values: [Point]) {
        viewChart.addSubview(lineChartView)
        mainContainer.bringSubviewToFront(lineChartView)
                                        
        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: viewChart.topAnchor),
            lineChartView.bottomAnchor.constraint(equalTo: viewChart.bottomAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: viewChart.leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: viewChart.trailingAnchor)
        ])
        
        let entries = chartEntries(values)
        let data = LineChartData(dataSets: [
            lineChartDataSet(entries),
            recommendedChartDataSetFor(entries.last)
        ])
        lineChartView.data = data
    }
}

// MARK: Functions
extension ChartsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: ChartsCollectionViewCell.self, for: indexPath)
        cell.titleLabel.text = dataSource[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chartData = dataSource[indexPath.row]
        lblRecommendation.text = chartData.recommendedValue.description
        lblCurrentValue.text = chartData.currentValue.description
        lblCurrentValueSuffix.text = chartData.valueSuffix
        lblRecommendationValueSuffix.text = chartData.valueSuffix
        setupChart(values: chartData.data)
    }
}

final class ChartsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = HRFonts.date
        contentView.addRounderBorder(borderColor: HRThemeColor.gray)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = HRThemeColor.blue
                titleLabel.textColor = HRThemeColor.white
                contentView.addRounderBorder(borderColor: HRThemeColor.blue)
            } else {
                backgroundColor = HRThemeColor.white
                titleLabel.textColor = HRThemeColor.black
                contentView.addRounderBorder(borderColor: HRThemeColor.gray)
            }
        }
    }
}

fileprivate class DateValueFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter = DateFormatter()

    override init() {
        super.init()
        dateFormatter.dateFormat = "d MMM"
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

fileprivate class CustomValueFormatter: NSObject, ValueFormatter {
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        String(format: "%.1f", value)
    }
}

fileprivate extension IndexPath {
    static var zero: IndexPath {
        .init(item: 0, section: 0)
    }
}
