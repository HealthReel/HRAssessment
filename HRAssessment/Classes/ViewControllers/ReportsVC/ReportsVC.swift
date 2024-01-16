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
        navShareButton.isHidden = false
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
        
        tableView.register(
            ReportSectionHeader.self,
            forHeaderFooterViewReuseIdentifier: "\(ReportSectionHeader.self)"
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            
        // Calculate the total content height of the table view
        let totalContentHeight = calculateContentHeight()
        print("Total content height: \(totalContentHeight)")
    }
    
    // MARK: Actions
    override func onTapNavBarShareButton() {
        if let screenshot = takeScreenshot(of: scrollView) {
            // Convert the image to PDF data
            if let pdfData = convertImageToPDF(image: screenshot) {
                // Save the PDF data to a file
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let pdfURL = documentsDirectory.appendingPathComponent("report.pdf")
                try? pdfData.write(to: pdfURL)
                
                // Share the PDF file
                sharePDF(pdfURL: pdfURL)
            }
        }
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
        return cell
    }
    
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
    private func takeScreenshot(of scrollView: UIScrollView) -> UIImage? {
        // Save the current content offset and frame of the scroll view
        let savedContentOffset = scrollView.contentOffset
        let savedFrame = scrollView.frame
        
        // Set the content offset to the top-left corner
        scrollView.contentOffset = .zero
        
        // Set the frame to match the content size
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        
        // Begin image context
        UIGraphicsBeginImageContext(scrollView.contentSize)
        
        // Check if the current context is not nil
        if let context = UIGraphicsGetCurrentContext() {
            // Render the entire content of the scroll view in the current context
            scrollView.layer.render(in: context)
            
            // Get the image from the current context
            if let screenshot = UIGraphicsGetImageFromCurrentImageContext() {
                // End the image context
                UIGraphicsEndImageContext()
                
                // Restore the saved content offset and frame
                scrollView.contentOffset = savedContentOffset
                scrollView.frame = savedFrame
                
                return screenshot
            }
        }
        
        // End the image context if it was created
        UIGraphicsEndImageContext()
        
        // Restore the saved content offset and frame
        scrollView.contentOffset = savedContentOffset
        scrollView.frame = savedFrame
        
        return nil
    }
    
    /// Covert Image to PDF
    private func convertImageToPDF(image: UIImage) -> Data? {
        // Create a PDF document
        let pdfDocument = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfDocument, CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height), nil)
        
        // Begin a PDF page
        UIGraphicsBeginPDFPage()
        
        // Draw the image in the PDF context
        image.draw(at: .zero)
        
        // End the PDF context
        UIGraphicsEndPDFContext()
        
        return pdfDocument as Data
    }
    
    /// Share PDF
    private func sharePDF(pdfURL: URL) {
        // Create an activity view controller with the PDF URL
        let activityViewController = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
        
        // Present the activity view controller
        present(activityViewController, animated: true, completion: nil)
    }
    
    /// Calculate Content Height
    private func calculateContentHeight() -> CGFloat {
        var totalContentHeight: CGFloat = 0
        
        // Add the heights of the headers
        for section in 0..<tableView.numberOfSections {
            totalContentHeight += tableView.rectForHeader(inSection: section).height
        }
        
        // Add the heights of the cells
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                totalContentHeight += tableView.rectForRow(at: IndexPath(row: row, section: section)).height
            }
        }
        
        // Add the heights of the footers
        for section in 0..<tableView.numberOfSections {
            totalContentHeight += tableView.rectForFooter(inSection: section).height
        }
        
        return totalContentHeight
    }
}
