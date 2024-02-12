//
//  ViewController.swift
//  HRAssessment
//
//  Created by HealthReel on 12/01/2023.
//  Copyright (c) 2023 HealthReel. All rights reserved.
//

import UIKit
import HRAssessment

final class ViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var btnChart: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var startAssessment: UIButton!
    
    var coordinator: HRCoordinator? {
        guard let navigationController else { return nil }
        let credentials = HRCredentials(apiKey:"",
                                        businessUniqueId: "",
                                        appUniqueId: "",
                                        callbackUrl: "")
        return HRCoordinator(navigationController, credentials: credentials)
    }
    
    // MARK: IBActions
    @IBAction func startAssessmentTapped() {
        let previousReport = PreviousReportDetails(healthScore: 90,
                                                   bodyFatPercentage: 23,
                                                   bodyWeight: 210,
                                                   cBMI: 29)
        coordinator?.startAssessment(userReferenceID: "000",
                                     previousReport: previousReport)
    }
    
    @IBAction func viewChartTapped() {
        coordinator?.showCharts(data: .mock)
    }
    
    @IBAction func viewReportTapped() {
        guard let report = try? JSONDecoder().decode(ReportModel.self,
                                                     from: rawReport) else {
            return
        }
        coordinator?.showReport(data: [report])
    }
}

