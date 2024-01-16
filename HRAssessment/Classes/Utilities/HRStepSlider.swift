import Foundation
import UIKit

final class HRStepSlider: UISlider {
    
    // Define the step value
    let defaultValue: Int = 5
    var intValue: Int { Int(value) }
    
    private let step: Float = 1.0
    private let trackHeight: CGFloat = 1
    private let valueLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = HRThemeColor.white
        lbl.font = HRFonts.regular16
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        minimumTrackTintColor = HRThemeColor.black
        maximumTrackTintColor = HRThemeColor.black
        thumbTintColor = HRThemeColor.blue

        minimumValue = 1
        maximumValue = 10

        self.addSubview(valueLabel)
    }

    // Override the track rect method to adjust the track height
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.trackRect(forBounds: bounds)
        rect.size.height = trackHeight
        return rect
    }

    // Override the setValue method to snap to the nearest step value
    override func setValue(_ value: Float, animated: Bool) {
        let newValue = round(value / step) * step
        super.setValue(newValue, animated: animated)
    }

    // Override the thumb rect to adjust the position of the thumb
    override func thumbRect(forBounds bounds: CGRect, 
                            trackRect rect: CGRect,
                            value: Float) -> CGRect {
        let rect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let value1 = CGFloat(value - minimumValue)
        let value2 = CGFloat(maximumValue - minimumValue)
        return rect.offsetBy(dx: value1 / value2 * bounds.width - rect.midX, dy: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateValueLabelFrame()
    }

    private func updateValueLabelFrame() {
        let trackRect = trackRect(forBounds: bounds)
        let thumbRect = thumbRect(forBounds: bounds,
                                  trackRect: trackRect,
                                  value: value)

        valueLabel.center = CGPoint(x: thumbRect.midX, y: thumbRect.midY)
        valueLabel.text = intValue.description
        bringSubviewToFront(valueLabel)
    }
    
    func set(value: Int) {
        setValue(Float(value), animated: true)
    }
}
