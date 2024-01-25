import UIKit

enum HRThemeColor {
    static let navigationBackgroundColor = UIColor(hex: "4499F2")
    static let lightgray = UIColor(hex: "F0F0F2")
    static let gray = UIColor(hex: "7A7A7A")
    static let lightblue = UIColor(hex: "C9EBFF")
    static let blue = UIColor(hex: "007DC3")
    static let anotherBlue = UIColor(hex: "009AF9")
    static let mustard = UIColor(hex: "b0aa07")
    static let green = UIColor(hex: "0b8b2b")
    static let red = UIColor.red
    static let white = UIColor.white
    static let black = UIColor.black

}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
