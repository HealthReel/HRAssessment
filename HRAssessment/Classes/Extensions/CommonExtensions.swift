import UIKit
import ImageIO

extension UIView {
    enum Borders {
        case top, bottom, left, right
    }
    
    func addBorders(_ borders: [Borders],_ thickness: CGFloat = 1,_ color: UIColor) {
        layer.masksToBounds = true
        for border in borders {
            if border == .top {
                let topBorder = CALayer()
                topBorder.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: thickness)
                topBorder.backgroundColor = color.cgColor
                layer.addSublayer(topBorder)
            } else if border == .bottom {
                let bottomBorder = CALayer()
                bottomBorder.frame = CGRect(x:0, y: frame.size.height - thickness, width: frame.size.width, height:thickness)
                bottomBorder.backgroundColor = color.cgColor
                layer.addSublayer(bottomBorder)
            } else if border == .left {
                let leftBorder = CALayer()
                leftBorder.frame = CGRect(x:0, y: 0.0, width: thickness, height: frame.size.height)
                leftBorder.backgroundColor = color.cgColor
                layer.addSublayer(leftBorder)
            } else if border == .right {
                let rightBorder = CALayer()
                rightBorder.frame = CGRect(x: frame.size.width, y: 0.0, width: thickness, height: frame.size.height)
                rightBorder.backgroundColor = color.cgColor
                layer.addSublayer(rightBorder)
            }
        }
    }
}
 
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        rectShape.path = UIBezierPath(roundedRect: bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: radius,
                                                          height: radius)
        ).cgPath
        layer.mask = rectShape
        layer.masksToBounds = true
    }
    
    func roundTopCorners(radius: CGFloat) {
        layer.cornerRadius = radius  // Set the corner radius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
    }
    
    func makeCircular() {
        layer.cornerRadius = 0.5 * bounds.size.height
        layer.masksToBounds = true
    }
    
    func addBorder(borderWidth: CGFloat = 1, borderColor: UIColor = UIColor.gray) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = true
    }
    
    func addRounderBorder(borderWidth: CGFloat = 1, 
                          borderColor: UIColor = .clear,
                           radius: CGFloat = 5,
                           showShadow: Bool = false) {
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = radius
        
        if showShadow {
            layer.shadowColor = HRThemeColor.black.cgColor
            layer.shadowOpacity = 0.1
            layer.shadowOffset = .zero
        }
    }
    
    func dropShadow(color: UIColor = .gray, opacity: Float = 0.3, radius: CGFloat = 1) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = .zero
        layer.shadowRadius = radius
    }
    
    func circularButton() {
        layer.masksToBounds = true
        layer.cornerRadius = frame.height/2
        layer.shadowColor = HRThemeColor.black.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 1.0
    }
}

extension UIImage {
    class func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }

        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var duration: TimeInterval = 0

        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))

                if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
                    let gifDict = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
                    let frameDuration = gifDict[kCGImagePropertyGIFDelayTime as String] as? TimeInterval {
                    duration += frameDuration
                }
            }
        }

        return UIImage.animatedImage(with: images, duration: duration)
    }
}

extension UIImageView {
    func load(gif: HRGIF) {
        loadGif(name: gif.rawValue)
    }
    
    func loadGif(name: String) {
        guard let path = Bundle.HRAssessment.path(forResource: name, ofType: "gif") else {
            return
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return
        }
        self.image = UIImage.gif(data: data)
    }
}

extension UIPageViewController {
    var scrollView: UIScrollView {
        for subview in view.subviews {
            if let scrollview = subview as? UIScrollView {
                return scrollview
            }
        }
        preconditionFailure("ScrollView Not Found")
    }

    var isScrollEnabled: Bool {
        get { scrollView.isScrollEnabled }
        set { scrollView.isScrollEnabled = newValue }
    }
}

extension UIEdgeInsets {
    init(uniform: CGFloat) {
        self.init(top: uniform, left: uniform, bottom: uniform, right: uniform)
    }
}

extension UITableView {
    func dequeueReusableCell<T>(type: T.Type, for: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: "\(type.self)",
                            for: `for`) as! T
    }
    
    func dequeueReusableHeaderFooterView<T>(type: T.Type) -> T {
        dequeueReusableHeaderFooterView(withIdentifier: "\(type.self)") as! T
    }
}

extension UICollectionView {
    func dequeueReusableCell<T>(type: T.Type, for: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: "\(type.self)", for: `for`) as! T
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
