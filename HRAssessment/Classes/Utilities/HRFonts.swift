import Foundation
import UIKit

enum HRFonts {
    case Poppins(Style)
    case Roboto(Style)
    case NotoSans(Style)

    enum Style: String, CaseIterable {
        case Regular
        case Medium
        case SemiBold
        case Bold
        case Light
    }
    
    var fontname: String {
        switch self {
        case .Poppins(let style):
            return "Poppins-\(style.rawValue)"
        case .Roboto(let style):
            return "Roboto-\(style.rawValue)"
        case .NotoSans(let style):
            return "NotoSans-\(style.rawValue)"
        }
    }
}

extension HRFonts: CaseIterable {
    static var allCases: [HRFonts] {
        var fonts = [HRFonts]()
        HRFonts.Style.allCases.forEach { style in
            fonts.append(HRFonts.Poppins(style))
            fonts.append(HRFonts.Roboto(style))
            fonts.append(HRFonts.NotoSans(style))
        }
        return fonts
    }
}

extension HRFonts {
    static var navigationTitle: UIFont {
        HRFonts.Poppins(.SemiBold).withSize(18)
    }

    static var heading: UIFont {
        HRFonts.Poppins(.SemiBold).withSize(18)
    }
    
    static var date: UIFont {
        HRFonts.Poppins(.SemiBold).withSize(14)
    }
    
    static var stepIndicatorTitle: UIFont {
        HRFonts.Poppins(.Regular).withSize(12)
    }
    
    static var regular20: UIFont {
        HRFonts.Poppins(.Regular).withSize(20)
    }
    
    static var regular16: UIFont {
        HRFonts.Poppins(.Regular).withSize(16)
    }

    static var regular14: UIFont {
        HRFonts.Poppins(.Regular).withSize(14)
    }
    
    static var light16: UIFont {
        HRFonts.Poppins(.Light).withSize(16)
    }
    
    static var reportText: UIFont {
        HRFonts.Roboto(.Regular).withSize(17)
    }
    
    static var reportHeader: UIFont {
        HRFonts.NotoSans(.Bold).withSize(18)
    }
 
    static var medium16: UIFont {
        HRFonts.Poppins(.Medium).withSize(16)
    }
}

extension HRFonts {
    func withSize(_ fontSize: CGFloat) -> UIFont {
        let size = fontSize * HRFonts.fontSizeMultiplier
        return UIFont(name: fontname, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    func withDefaultSize() -> UIFont {
        UIFont(name: fontname, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }
    
    func withFixedSize(_ fontSize: CGFloat) -> UIFont {
        UIFont(name: fontname, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    static var fontSizeMultiplier : Double {
        UIApplication.shared.screenWidth < 415 ? 1 : 1.7
    }
}

extension UIApplication {
    
#if os(iOS)
    var screenOrientation: UIInterfaceOrientation {
        keyWindow?
            .windowScene?
            .interfaceOrientation ?? .unknown
    }
#endif

    var screenWidth: CGFloat {
        
#if os(iOS)
        if screenOrientation.isPortrait {
            return UIScreen.main.bounds.size.width
        } else {
            return UIScreen.main.bounds.size.height
        }
#elseif os(tvOS)
        return UIScreen.main.bounds.size.width
#endif
    }
    
    var screenHeight: CGFloat {
#if os(iOS)
        if screenOrientation.isPortrait {
            return UIScreen.main.bounds.size.height
        } else {
            return UIScreen.main.bounds.size.width
        }
#elseif os(tvOS)
        return UIScreen.main.bounds.size.height
#endif
    }
}
