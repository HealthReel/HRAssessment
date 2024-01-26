import UIKit

final class InformationVC: UIViewController {
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var descriptionFont = HRFonts.regular20
    
    var dataPoint: CategorisedReport.DataPoint = .empty
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        populate()
        
        dismissButton.addTarget(self,
                                action: #selector(dismissInfoVC),
                                for: .touchUpInside)
    }
    
    private func configure() {
        titleLabel.font = HRFonts.heading
        descriptionLabel.font = descriptionFont
    }
    
    private func populate() {
        titleLabel.text = dataPoint.title
        descriptionLabel.text = dataPoint.definition
    }
    
    @objc private func dismissInfoVC() {
        dismiss(animated: true)
    }
}

fileprivate extension CategorisedReport.DataPoint {
    static var empty: Self {
        .init(title: "", definition: "", valueKey: "")
    }
}
