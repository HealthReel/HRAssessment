import Foundation
import UIKit

extension UIView {
    /// Return an `UIImage`with the visible contents inside the Cropping Rect
    /// - Parameter croppingRect: a rect to focus the screenshot
    /// - Returns: an `UIImage` with the visible contents inside the cropping rect
    func screenshotForCroppingRect(croppingRect: CGRect) -> UIImage? {
        UIGraphicsImageRenderer(bounds: croppingRect, format: .default())
            .image { ctx in
                layoutIfNeeded()
                layer.render(in: ctx.cgContext)
        }
    }
    
    /// Returns a screenshot as `UIImage` from the whole view
    @objc var screenshot: UIImage? {
        return self.screenshotForCroppingRect(croppingRect: self.bounds)
    }
}
