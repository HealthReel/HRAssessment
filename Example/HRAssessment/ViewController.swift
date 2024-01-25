//
//  ViewController.swift
//  HRAssessment
//
//  Created by HealthReel on 12/01/2023.
//  Copyright (c) 2023 HealthReel. All rights reserved.
//

import UIKit
import HRAssessment

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var btnChart: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var startAssessmentFemale: UIButton!
    @IBOutlet weak var startAssessmentMale: UIButton!
    
    var coordinator: HRCoordinator? {
        guard let navigationController else { return nil }
        return HRCoordinator(navigationController)
    }
    
    // MARK: IBActions
    @IBAction func startAssessmentMaleTapped() {
        let user = UserProfile(dob: 628385125,
                               gender: .male,
                               height: 169,
                               diabetic: true,
                               race: .asian)
        coordinator?.startAssessment(user: user)
    }
    
    @IBAction func startAssessmentFemaleTapped() {
        let user = UserProfile(dob: 628385125,
                               gender: .female,
                               height: 169,
                               diabetic: true,
                               race: .asian)
        coordinator?.startAssessment(user: user)
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

