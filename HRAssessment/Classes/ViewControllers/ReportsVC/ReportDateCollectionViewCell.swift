
import UIKit

final class ReportDateCollectionViewCell: UICollectionViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblDate: UILabel!
    
    // MARK: Functions
    func populate(isSelected: Bool) {
        viewContainer.addRounderBorder(radius: 4)
        viewContainer.dropShadow()
        
        viewContainer.backgroundColor = isSelected ? HRThemeColor.blue : HRThemeColor.white
        lblDate.textColor = isSelected ? HRThemeColor.white : HRThemeColor.black
        lblDate.font = HRFonts.date
    }
}
