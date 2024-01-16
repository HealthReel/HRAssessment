
import UIKit
import DGCharts

final class ChartsVC: BaseVC {

    // MARK: IBOutlets
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var btnBodyFat: UIButton!
    @IBOutlet weak var btnBodyWeight: UIButton!
    @IBOutlet weak var btnBodyBMI: UIButton!
    
    @IBOutlet weak var lblCurrentValue: UILabel!
    @IBOutlet weak var lblRecommendation: UILabel!
    @IBOutlet weak var viewChart: UIView!
    
    var dataSource: ChartReport!

    // MARK: Properties
    private lazy var lineChartView: LineChartView = {
        let lineChartView = LineChartView()
        
        // Enable horizontal scrolling
        lineChartView.dragXEnabled = true
        lineChartView.xAxis.drawLabelsEnabled = true
        
        // Hide labels on the Y-axis (left and right)
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        
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
        
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.isUserInteractionEnabled = false
        
        lineChartView.frame = CGRect(x: 0, y: 0,
                                     width: view.frame.size.width,
                                     height: 300)
        lineChartView.center = view.center

        return lineChartView
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func onTapNavBarLeftButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Actions
    @objc func onTapBtn(_ sender: UIButton) {
        [btnBodyFat, btnBodyWeight, btnBodyBMI].forEach {
            $0?.backgroundColor = HRThemeColor.white
            $0?.setTitleColor(.black, for: .normal)
            $0?.isSelected = false
        }

        sender.backgroundColor = HRThemeColor.anotherBlue
        sender.setTitleColor(.white, for: .normal)
        sender.isSelected = true

        if sender === btnBodyFat {
            lblRecommendation.text = dataSource.bodyFat.recommendedValue.description
            lblCurrentValue.text = dataSource.bodyFat.currentValue.description
            setupChart(values: dataSource.bodyFat.data)
        } else if sender === btnBodyWeight {
            lblRecommendation.text = dataSource.bodyWeight.recommendedValue.description
            lblCurrentValue.text = dataSource.bodyWeight.currentValue.description
            setupChart(values: dataSource.bodyWeight.data)
        } else if sender === btnBodyBMI {
            lblRecommendation.text = dataSource.correctedBMI.recommendedValue.description
            lblCurrentValue.text = dataSource.correctedBMI.currentValue.description
            setupChart(values: dataSource.correctedBMI.data)
        }
    }
}

// MARK: Functions
extension ChartsVC {
    func setupViews() {
        navBarTitleLabel.text = "Charts"
        
        view.backgroundColor = HRThemeColor.white
        view.bringSubviewToFront(mainContainer)
        mainContainer.roundTopCorners(radius: 30)

        [btnBodyFat, btnBodyWeight, btnBodyBMI].forEach {
            $0?.addTarget(self, action: #selector(onTapBtn), for: .touchUpInside)
            $0?.addRounderBorder(radius: 4)
            $0?.dropShadow()
        }

        lblRecommendation.text = dataSource.bodyFat.recommendedValue.description
        lblCurrentValue.text = dataSource.bodyFat.currentValue.description
        setupChart(values: dataSource.bodyFat.data)
    }
    
    func chartEntries(_ values: [Point]) -> [ChartDataEntry] {
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
    
    func lineChartDataSet(_ entries: [ChartDataEntry]) -> LineChartDataSet {
        let dataSet = LineChartDataSet(entries: entries, label: "")
        // Change value color
        dataSet.valueTextColor = HRThemeColor.blue
        dataSet.valueFont = .systemFont(ofSize: 12)
        
        dataSet.fillColor = HRThemeColor.blue
        dataSet.drawFilledEnabled = true
        
        // Set value formatter for showing values up to 1 decimal place
        dataSet.valueFormatter = CustomValueFormatter()

        // Create the gradient
        let gradientColors = [HRThemeColor.blue.cgColor, HRThemeColor.white.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: gradientColors,
                                        locations: colorLocations) else {
            return dataSet
        }
        
        dataSet.fill = LinearGradientFill(gradient: gradient, angle: 90)
        return dataSet
    }
    
    func setupChart(values: [Point]) {
        viewChart.addSubview(lineChartView)
        mainContainer.bringSubviewToFront(lineChartView)
                                        
        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: viewChart.topAnchor),
            lineChartView.bottomAnchor.constraint(equalTo: viewChart.bottomAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: viewChart.leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: viewChart.trailingAnchor)
        ])
        
        let entries = chartEntries(values)
        let data = LineChartData(dataSet: lineChartDataSet(entries))
        lineChartView.data = data
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
