import Foundation

typealias Point = (x: String, y: Double)

public struct ChartData {
    let title: String
    let currentValue: CGFloat
    let recommendedValue: CGFloat
    let data: [Point]
}

public extension [ChartData] {
    static var mock: Self {
        [.bodyFat, .bodyWeight, .correctedBMI, .leanBodyMass, .fatBodyMass]
    }
}

extension ChartData {
    static var bodyFat: Self {
        ChartData(
            title: "Body Fat",
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
    }
    
    static var bodyWeight: Self {
        ChartData(
            title: "Body Weight",
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
        )
    }
    
    static var correctedBMI: Self {
        ChartData(
            title: "Corrected BMI",
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
    }

    static var leanBodyMass: Self {
        ChartData(
            title: "Lean Body Mass",
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
    }
    
    static var fatBodyMass: Self {
        ChartData(
            title: "Fat Mass",
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
    }
    
}
