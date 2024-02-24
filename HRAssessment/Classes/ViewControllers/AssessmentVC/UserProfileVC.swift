
import UIKit

final class UserProfileVC: BaseVC {
    var user: UserProfile!
    var nextButtonAction: (() -> ())?

    lazy var activeTextfield: UITextField = dobTextfield
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var dobTextfield: DTTextField!
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()

    @IBOutlet weak var genderTextfield: DTTextField!
    private lazy var genderTextfieldPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = HRThemeColor.white
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    @IBOutlet weak var heightTextfield: DTTextField!
    private lazy var heightTextfieldPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = HRThemeColor.white
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    @IBOutlet weak var diabeticTextfield: DTTextField!
    private lazy var diabeticTextfieldPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = HRThemeColor.white
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    @IBOutlet weak var raceTextfield: DTTextField!
    private lazy var raceTextfieldPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = HRThemeColor.white
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.bringSubviewToFront(viewContainer)
        viewContainer.roundTopCorners(radius: 30)

        nextButton.makeCircular()
        nextButton.backgroundColor = HRThemeColor.blue
        let nextTitle = String(localizedKey: "userprofile.button.next")
        nextButton.setAttributedTitle(
            .init(string: nextTitle,
                  attributes: [
                    .font: HRFonts.heading,
                    .foregroundColor: UIColor.white
        ]), for: .normal)
        
        navBarTitleLabel.text = String(localizedKey: "nav.title.user_profile")
        setupFields()
    }
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        view.endEditing(true)
    }
    
    private func setupFields() {
        [dobTextfield,
         genderTextfield,
         heightTextfield,
         diabeticTextfield,
         raceTextfield
        ].forEach {
            $0?.inputAccessoryView = createToolbar()
            $0?.font = HRFonts.regular16
            $0?.delegate = self
        }
        
        dobTextfield.placeholder = String(localizedKey: "userprofile.dateofbirth")
        dobTextfield.inputView = {
            let picker = UIDatePicker()
            picker.tintColor = HRThemeColor.white
            picker.maximumDate = Date.maximumAllowedDate
            picker.datePickerMode = .date
            picker.preferredDatePickerStyle = .wheels
            picker.addTarget(self, action: #selector(onDateValueChanged(_:)), for: .valueChanged)
            return picker
        }()
                
        genderTextfield.placeholder = String(localizedKey: "userprofile.gender")
        genderTextfield.inputView = genderTextfieldPicker

        heightTextfield.placeholder = String(localizedKey: "userprofile.height")
        heightTextfield.inputView = heightTextfieldPicker
        heightTextfieldPicker.selectRow(165, inComponent: 0, animated: true)
        
        diabeticTextfield.placeholder = String(localizedKey: "userprofile.diabetic")
        diabeticTextfield.inputView = diabeticTextfieldPicker

        raceTextfield.placeholder = String(localizedKey: "userprofile.race")
        raceTextfield.inputView = raceTextfieldPicker
    }
    
    @IBAction func nextButtonTapped() {
        guard validate() else { return }
        nextButtonAction?()
    }
    
    private func validate() -> Bool {
        guard let dob = dobTextfield.text, !dob.isEmptyStr else {
            showError(dobTextfield)
            return false
        }
        
        guard let genderString = genderTextfield.text,
              let gender = UserProfile.Gender(rawValue: genderString.lowercased()) else {
            showError(genderTextfield)
            return false
        }
        
        guard let heightString = heightTextfield.text,
              let height = NumberFormatter().number(from: heightString)?.floatValue else {
            showError(heightTextfield)
            return false
        }
        
        guard let diabetic = diabeticTextfield.text, !diabetic.isEmptyStr else {
            showError(diabeticTextfield)
            return false
        }
        
        guard let raceString = raceTextfield.text, !raceString.isEmptyStr else {
            showError(raceTextfield)
            return false
        }
                
        user.gender = gender
        user.height = CGFloat(height)
        user.diabetic = diabetic == "Yes" ? true : false
        user.race = UserProfile.Race(stringValue: raceString)

        return true
    }
    
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let previousBtn = UIBarButtonItem(
            title: String(localizedKey: "userprofile.barbutton.previous"),
            style: .plain,
            target: nil,
            action: #selector(previousBtnTapped)
        )

        let nextBtn = UIBarButtonItem(
            title: String(localizedKey: "userprofile.barbutton.next"),
            style: .done,
            target: nil,
            action: #selector(nextBtnTapped)
        )
        
        toolbar.setItems (
            [previousBtn,
             .flexibleSpace(),
             nextBtn
            ],
            animated: true)
        return toolbar
    }
}

extension UserProfileVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextfield = textField
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextfield = textField
        
        if let picker = activeTextfield.inputView as? UIPickerView {
            let selectedRow = picker.selectedRow(inComponent: 0)
            pickerView(picker, didSelectRow: selectedRow, inComponent: 0)
        } else if let picker = activeTextfield.inputView as? UIDatePicker {
            onDateValueChanged(picker)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField,
                                reason: UITextField.DidEndEditingReason) {
        switch textField {
        case dobTextfield:
            if let dob = dobTextfield.text, dob.isEmptyStr {
                showError(dobTextfield)
            }
        case genderTextfield:
            if let gender = genderTextfield.text, gender.isEmptyStr {
                showError(genderTextfield)
            }
        case heightTextfield:
            if let height = heightTextfield.text, height.isEmptyStr {
                showError(heightTextfield)
            }
        case diabeticTextfield:
            if let diabetic = diabeticTextfield.text, diabetic.isEmptyStr {
                showError(diabeticTextfield)
            }
        case raceTextfield:
            if let race = raceTextfield.text, race.isEmptyStr {
                showError(raceTextfield)
            }
        default:
            break
        }
    }
    
    @objc private func previousBtnTapped() {
        switch activeTextfield {
        case dobTextfield:
            view.endEditing(true)
        case genderTextfield:
            dobTextfield.becomeFirstResponder()
        case heightTextfield:
            genderTextfield.becomeFirstResponder()
        case diabeticTextfield:
            heightTextfield.becomeFirstResponder()
        case raceTextfield:
            diabeticTextfield.becomeFirstResponder()
        default:
            break
        }
    }
    
    @objc private func nextBtnTapped() {
        switch activeTextfield {
        case dobTextfield:
            genderTextfield.becomeFirstResponder()
        case genderTextfield:
            heightTextfield.becomeFirstResponder()
        case heightTextfield:
            diabeticTextfield.becomeFirstResponder()
        case diabeticTextfield:
            raceTextfield.becomeFirstResponder()
        case raceTextfield:
            view.endEditing(true)
        default:
            break
        }
    }
    
    @objc private func onDateValueChanged(_ datePicker: UIDatePicker) {
        user.dob = Int(datePicker.date.timeIntervalSince1970)
        let dateString = dateFormatter.string(from: datePicker.date)
        dobTextfield.text = dateString
    }
    
    private func showError(_ textfield: UITextField) {
        switch textfield {
        case dobTextfield:
            dobTextfield.showError(
                message: String(localizedKey: "userprofile.error.dob")
            )
        case genderTextfield:
            genderTextfield.showError(
                message: String(localizedKey: "userprofile.error.gender")
            )
        case heightTextfield:
            heightTextfield.showError(
                message: String(localizedKey: "userprofile.error.height")
            )
        case diabeticTextfield:
            diabeticTextfield.showError(
                message: String(localizedKey: "userprofile.error.diabetic")
            )
        case raceTextfield:
            raceTextfield.showError(
                message: String(localizedKey: "userprofile.error.race")
            )
        default:
            break
        }
        
    }
}

extension UserProfileVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case genderTextfieldPicker,
            heightTextfieldPicker,
            diabeticTextfieldPicker,
            raceTextfieldPicker:
            1
        default:
            0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, 
                    numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case genderTextfieldPicker: UserProfile.Gender.allCases.count
        case heightTextfieldPicker: 200
        case diabeticTextfieldPicker: 2
        case raceTextfieldPicker: UserProfile.Race.allCases.count
        default: 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, 
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        switch pickerView {
        case genderTextfieldPicker: UserProfile.Gender.allCases[row].rawValue.capitalized
        case heightTextfieldPicker: "\(Array(1...200)[row])"
        case diabeticTextfieldPicker: ["Yes", "No"][row]
        case raceTextfieldPicker: UserProfile.Race.allCases[row].stringValue
        default: ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, 
                    didSelectRow row: Int,
                    inComponent component: Int) {
        let title = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        activeTextfield.text = title
    }
}

fileprivate extension Date {
    static var maximumAllowedDate: Date {
        var gregorianCalendar = Calendar(identifier: .gregorian)
        gregorianCalendar.locale = Locale.autoupdatingCurrent
        return gregorianCalendar.date(
            byAdding: DateComponents(year: -18),
            to: .now
        ) ?? .now
        
    }
}
