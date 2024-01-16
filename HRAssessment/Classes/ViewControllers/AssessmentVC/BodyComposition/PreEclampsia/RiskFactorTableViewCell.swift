
import UIKit

final class RiskFactorTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var imageCheckbox: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override var isSelected: Bool {
        didSet {
            setupIcon()
        }
    }
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .default
    }
    
    override func prepareForReuse() {
        imageCheckbox.image = HRImageAsset.icon_unchecked.image
    }

    // MARK: Functions
    
    func setup(title: String) {
        lblTitle.text = title
        setupIcon()
    }

    private func setupIcon() {
        imageCheckbox.image = isSelected ? HRImageAsset.icon_checked.image : HRImageAsset.icon_unchecked.image
    }
}
