
import UIKit

protocol BodyWeightVCDelegate: AnyObject {
    func bodyWeightUpdated(weight: Double)
    var bodyWeightResponse: Double { get }
}

final class BodyWeightVC: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberPicker: UIPickerView!
    @IBOutlet weak var decimalPicker: UIPickerView!

    // MARK: Properties
    weak var delegate: BodyWeightVCDelegate!

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.font = HRFonts.regular16
        numberPicker.delegate = self
        numberPicker.dataSource = self

        decimalPicker.delegate = self
        decimalPicker.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let bodyWeight = delegate.bodyWeightResponse
        let n = Int(bodyWeight)
        let d = Int((bodyWeight - Double(n))/10)

        numberPicker.selectRow(n, inComponent: 0, animated: true)
        decimalPicker.selectRow(d, inComponent: 0, animated: true)
    }

    private var selectedBodyWeight: Double {
        let n = Double(numberPicker.selectedRow(inComponent: 0))
        let d = Double(decimalPicker.selectedRow(inComponent: 0))
        return n + (d/10)
    }
}

// MARK: UIPickerView Delegate and Datasource
extension BodyWeightVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        95
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView === numberPicker ? 350 : 10
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate.bodyWeightUpdated(weight: selectedBodyWeight)
        pickerView.reloadComponent(component)
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int,
                    reusing view: UIView?) -> UIView {

        let label = view as? UILabel ?? UILabel()
        label.text = row.description
        label.textAlignment = .center

        if pickerView.selectedRow(inComponent: component) == row {
            // If this is the selected row, use a larger font size
            label.textColor = HRThemeColor.blue
            label.font = UIFont.systemFont(ofSize: 60)
        } else {
            // If this is not the selected row, use a smaller font size
            label.textColor = HRThemeColor.gray
            label.font = UIFont.systemFont(ofSize: 20)
        }
        return label
    }
}
