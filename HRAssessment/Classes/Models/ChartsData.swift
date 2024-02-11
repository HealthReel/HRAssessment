import Foundation

typealias Point = (x: String, y: Double)

public struct ChartData {
    let title: String
    let currentValue: CGFloat
    let recommendedValue: CGFloat
    let valueSuffix: String
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
            valueSuffix: "%",
            data: [
                (x: "05/08/2023", y: 15),
                (x: "26/08/2023", y: 15),
                (x: "1 Sep 2023", y: 12),
                (x: "15 Sep 2023", y: 11),
                (x: "9 Oct 2023", y: 10.5),
                (x: "10 Nov 2023", y: 10)
            ]
        )
    }
    
    static var bodyWeight: Self {
        ChartData(
            title: "Body Weight",
            currentValue: 173,
            recommendedValue: 160,
            valueSuffix: "lbs",
            data: [
                (x: "05/08/2023", y: 209),
                (x: "26/08/2023", y: 198),
                (x: "1 Sep 2023", y: 192),
                (x: "15 Sep 2023", y: 181),
                (x: "9 Oct 2023", y: 180),
                (x: "10 Nov 2023", y: 173)
            ]
        )
    }
    
    static var correctedBMI: Self {
        ChartData(
            title: "Corrected BMI",
            currentValue: 25,
            recommendedValue: 23.5,
            valueSuffix: "",
            data: [
                (x: "05/08/2023", y: 30),
                (x: "26/08/2023", y: 29),
                (x: "1 Sep 2023", y: 27),
                (x: "15 Sep 2023", y: 26),
                (x: "9 Oct 2023", y: 26),
                (x: "10 Nov 2023", y: 25)
            ]
        )
    }

    static var leanBodyMass: Self {
        ChartData(
            title: "Lean Body Mass",
            currentValue: 140,
            recommendedValue: 132,
            valueSuffix: "lbs",
            data: [
                (x: "05/08/2023", y: 159),
                (x: "26/08/2023", y: 155),
                (x: "1 Sep 2023", y: 152),
                (x: "15 Sep 2023", y: 149),
                (x: "9 Oct 2023", y: 144),
                (x: "10 Nov 2023", y: 140)
            ]
        )
    }
    
    static var fatBodyMass: Self {
        ChartData(
            title: "Fat Mass",
            currentValue: 30.8,
            recommendedValue: 28.9,
            valueSuffix: "lbs",
            data: [
                (x: "05/08/2023", y: 44),
                (x: "26/08/2023", y: 41),
                (x: "1 Sep 2023", y: 42),
                (x: "15 Sep 2023", y: 35),
                (x: "9 Oct 2023", y: 34.2),
                (x: "10 Nov 2023", y: 30.8)
            ]
        )
    }
    
}
