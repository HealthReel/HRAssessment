import Foundation

typealias Point = (x: String, y: Double)

public struct ChartReport {
    let bodyFat: ChartData
    let bodyWeight: ChartData
    let correctedBMI: ChartData
}

public struct ChartData {
    let currentValue: CGFloat
    let recommendedValue: CGFloat
    let data: [Point]
}

public extension ChartReport {
    static var mockData: ChartReport {
        return ChartReport(
            bodyFat: ChartData(
                currentValue: 10.8,
                recommendedValue: 8.9,
                data: [
                    (x: "05/08/2023", y: 15),
                    (x: "26/08/2023", y: 15),
                    (x: "1 Sep 2023", y: 12),
                    (x: "15 Sep 2023", y: 11),
                    (x: "9 Oct 2023", y: 10),
                    (x: "10 Nov 2023", y: 10)
                ]
            ),
            bodyWeight: ChartData(
                currentValue: 107,
                recommendedValue: 80,
                data: [
                    (x: "05/08/2023", y: 9),
                    (x: "26/08/2023", y: 15),
                    (x: "1 Sep 2023", y: 12),
                    (x: "15 Sep 2023", y: 11),
                    (x: "9 Oct 2023", y: 10),
                    (x: "10 Nov 2023", y: 10)
                ]
            ),
            correctedBMI: ChartData(
                currentValue: 10.8,
                recommendedValue: 8.9,
                data: [
                    (x: "05/08/2023", y: 15),
                    (x: "26/08/2023", y: 15),
                    (x: "1 Sep 2023", y: 12),
                    (x: "15 Sep 2023", y: 11),
                    (x: "9 Oct 2023", y: 10),
                    (x: "10 Nov 2023", y: 10)
                ]
            )
        )
    }
}
