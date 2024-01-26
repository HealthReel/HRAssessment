import UIKit

enum HRImageAsset: String {
    case back_arrow
    case icon_checked, icon_unchecked
    case icon_filled_circle, icon_filled_square
    case icon_trend_up, icon_trend_down
    case icon_share
    case info_icon
    case navigation_bar
    case poweredByNASA
}

extension HRImageAsset {
    var image: UIImage? {
        UIImage(named: rawValue, in: .HRAssessment, with: .none)
    }
    
    var alwaysTemplateImage: UIImage? {
        image?.withRenderingMode(.alwaysTemplate)
    }
    
    func image(with color: UIColor) -> UIImage? {
        alwaysTemplateImage?.withTintColor(color)
    }
}
