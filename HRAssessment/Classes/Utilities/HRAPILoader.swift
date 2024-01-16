import Foundation
import UIKit

final class HRAPILoader: UIView {
    private let loader = UIActivityIndicatorView(style: .large)
    fileprivate static let shared = HRAPILoader()
    
    convenience init() {
        self.init(frame: .init(origin: .zero, size: .init(width: 100, height: 100)))
        backgroundColor = HRThemeColor.white
        isHidden = true
        layer.cornerRadius = 10
        
        loader.hidesWhenStopped = true
        loader.color = HRThemeColor.black
        loader.center = center
        addSubview(loader)
    }
    
    private func startAnimating() {
        isHidden = false
        loader.startAnimating()
    }
    
    private func stopAnimating() {
        loader.stopAnimating()
        isHidden = true
    }
}

extension HRAPILoader {
    class func start() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        DispatchQueue.main.async {
            keyWindow.isUserInteractionEnabled = false
            self.shared.center = keyWindow.center
            keyWindow.addSubview(self.shared)
            self.shared.startAnimating()
        }
    }
    
    class func stop() {
        DispatchQueue.main.async {
            self.shared.stopAnimating()
            self.shared.superview?.isUserInteractionEnabled = true
            self.shared.removeFromSuperview()
        }
    }
}

extension UIApplication {
    var keyWindow: UIWindow? {
        // Get connected scenes
        return self.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
}
