import UIKit

final class ReportVC: BaseVC {

    // MARK: Properties
    var controller: ReportsController!

    // MARK: IBOutlets
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
        
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = HRThemeColor.white
        view.bringSubviewToFront(viewContainer)

        navBarTitleLabel.text = "Reports"
        titleHeader.font = HRFonts.regular16

        navRightButton.isHidden = false
        navRightButton.configuration = {
            var config = UIButton.Configuration.borderless()
            config.image = HRImageAsset.icon_share.image
            config.imagePadding = 5
            config.imagePlacement = .leading
            config.baseForegroundColor = .white
            return config
        }()
        
        viewContainer.roundTopCorners(radius: 30)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = HRThemeColor.white
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.backgroundColor = HRThemeColor.white
        
        tableView.tableFooterView = {
            let logo = UIImageView(image: HRImageAsset.poweredByNASA.image)
            logo.contentMode = .center
            logo.frame = .init(origin: .zero,
                               size: .init(width: tableView.bounds.width,
                                           height: 60)
            )
            return logo
        }()
        
        tableView.register(
            ReportSectionHeader.self,
            forHeaderFooterViewReuseIdentifier: "\(ReportSectionHeader.self)"
        )
    }
    
    // MARK: Actions
    override func onTapNavBarRightButton() {
        HRAPILoader.start()
        guard let screenshot = tableView.screenshot else {
            HRAPILoader.stop()
            return
        }

        guard let pdfData = screenshot.convertToPDF() else {
            HRAPILoader.stop()
            return
        }
        
        // Save the PDF data to a file
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let pdfURL = documentsDirectory.appendingPathComponent("InovCare Health Report.pdf")
        try? pdfData.write(to: pdfURL)
        
        HRAPILoader.stop()
        // Share the PDF file
        sharePDF(pdfURL: pdfURL)
    }
    
    override func onTapNavBarLeftButton() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: Table View Delegate and Datasource
extension ReportVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        controller.sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        controller.rows(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            type: ReportSectionHeader.self
        )
        let title = controller.sectionTitle(section: section)
        let subTitle = controller.sectionSubTitle(section: section)
        header.populate(title: title, subTitle: subTitle)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 40 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: ReportsTableViewCell.self, for: indexPath)
        let dataPoints = controller.dataPoints(section: indexPath.section)
        cell.populate(data: dataPoints[indexPath.row],
                      reportModel: controller.currentReport)
        
//        cell.iconTrend.isHidden = indexPath.section > 1
//        cell.lblTrend.isHidden = indexPath.section > 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 44 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = InformationVC.instantiate(from: .HealthReel)
        vc.dataPoint = controller.dataPoints(section: indexPath.section)[indexPath.row]
        present(vc, animated: true)
    }
}

// MARK: Collection View Delegate and Datasource
extension ReportVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        controller.reportsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            type: ReportDateCollectionViewCell.self,
            for: indexPath
        )
        cell.lblDate.text = controller.dateForReport(index: indexPath.row)
        cell.populate(isSelected: indexPath.row == controller.currentDateIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller.currentDateIndex = indexPath.row
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 60, height: 40)
    }
}

// MARK: Share PDF Functions
extension ReportVC {
    /// Share PDF
    private func sharePDF(pdfURL: URL) {
        // Create an activity view controller with the PDF URL
        let activityViewController = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
        
        // Present the activity view controller
        present(activityViewController, animated: true, completion: nil)
    }
}
