import Foundation

extension Bundle {
    static var HRAssessment: Bundle {
        Bundle(for: HRCoordinator.self)
//        Bundle(identifier: "org.cocoapods.HRAssessment")!
    }
}

extension String {
    init(localizedKey: String.LocalizationValue) {
        self.init(localized: localizedKey, bundle: .HRAssessment)
    }
}
