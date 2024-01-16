
final class ReportsController {
    let source: [ReportModel]
    var currentDateIndex = 0
    var currentReport: ReportModel {
        source[currentDateIndex]
    }
    
    private var fullReport: HealthReport {
        HealthReport.fullReport(for: currentReport)
    }
    
    private let iso8601DateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private let dateFormatterMMMdyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()

    private let dateFormatterdMMM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }()
    
    init(source: [ReportModel]) {
        self.source = source
    }
    
    // MARK: Functions
    func dateForReport(index: Int) -> String {
        guard let date = iso8601DateFormatter.date(from: source[index].createdAt) else {
            return ""
        }

        return dateFormatterdMMM.string(from: date)
    }
    
    var reportsCount: Int {
        source.count
    }

    var sections: Int {
        fullReport.data.count
    }

    func rows(section: Int) -> Int {
        dataPoints(section: section).count
    }
    
    func sectionTitle(section: Int) -> String {
        fullReport.data[section].title
    }
    
    func sectionSubTitle(section: Int) -> String {
        guard let date = iso8601DateFormatter.date(from: currentReport.createdAt) else {
            return "Last updated on \(currentReport.createdAt)"
        }
        
        let formattedDate = dateFormatterMMMdyyyy.string(from: date)
        return "Last updated on \(formattedDate)"
    }
    
    func dataPoints(section: Int) -> [CategorisedReport.DataPoint] {
        fullReport.data[section].dataPoints
    }
}

extension CategorisedReport.DataPoint {
    func format(value: ReportModel.Value) -> String {
        return switch value {
        case .number(let double):
            format(value: double) + suffix
        case .text(let string):
            string + suffix
        }
    }
    
    private func format(value: Double) -> String {
        return switch self {
        case .diabetes:
            value < 1.0 ? "<1" : (value > 99 ? ">99" : value.string)
        default:
            value.string
        }
    }
}

extension Double {
    var string: String {
        String(format: "%.1f", self)
    }
}
