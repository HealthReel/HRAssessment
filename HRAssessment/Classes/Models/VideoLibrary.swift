import Foundation

enum HRVideo: String {
    case guidanceFemale = "Guidance_Female"
    case guidanceMale = "Guidance_Male"
    
    static func guidance(_ gender: UserProfile.Gender) -> HRVideo {
        gender == .female ? .guidanceFemale : .guidanceMale
    }
    
    var path: String {
        guard let path = Bundle.HRAssessment.path(forResource: rawValue, ofType: "mp4") else {
            preconditionFailure("Video Not Found")
        }
        return path
    }

}

enum HRGIF: String {
    case female = "PIP_Female"
    case male = "PIP_Male"
    
    static func guidanceFor(_ gender: UserProfile.Gender) -> HRGIF {
        gender == .female ? .female : .male
    }
}

enum HRAudio: String {
    case assessment_1 = "assessment_1"
    case assessment_2 = "assessment_2"
    case assessment_3 = "assessment_3"
    case assessment_4 = "assessment_4"
    case assessment_5_male = "assessment_5_male"
    case assessment_5_female = "assessment_5_female"
    case a6_recording_time_info = "a6_recording_time_info"
    case a7_after_countdown_info = "a7_after_countdown_info"
    case a8_raise_hands_as_PIP = "a8_raise_hands_as_PIP"
    case a9_pose_time_info = "a9_pose_time_info"
    case a10_pose_timer = "a10_pose_timmer"
    case a11_start_beep = "a11_start_beep"
    case a12_recording_time = "a12_recording_time"
    
    static func assessment_5(_ gender: UserProfile.Gender) -> HRAudio {
        gender == .female ? .assessment_5_female : .assessment_5_male
    }
    
    var path: String {
        guard let path = Bundle.HRAssessment.path(forResource: rawValue, ofType: "mp3") else {
            preconditionFailure("Video Not Found")
        }
        return path
    }
    
    func next(with gender: UserProfile.Gender) -> HRAudio? {
        switch self {
        case .assessment_1:
            return .assessment_2
        case .assessment_2:
            return .assessment_3
        case .assessment_3:
            return .assessment_4
        case .assessment_4:
            return gender == .male ? .assessment_5_male : .assessment_5_female
        case .assessment_5_male:
            return .a6_recording_time_info
        case .assessment_5_female:
            return .a6_recording_time_info
        case .a6_recording_time_info:
            return .a7_after_countdown_info
        case .a7_after_countdown_info:
            return .a8_raise_hands_as_PIP
        case .a8_raise_hands_as_PIP:
            return .a9_pose_time_info
        case .a9_pose_time_info:
            return .a10_pose_timer
        case .a10_pose_timer:
            return .a11_start_beep
        case .a11_start_beep:
            return .a12_recording_time
        case .a12_recording_time:
            return nil
        }
    }
    
    static func audioFileName(with index: Int, gender: UserProfile.Gender) -> String? {
        switch index {
        case 0: return HRAudio.assessment_1.rawValue
        case 1: return HRAudio.assessment_2.rawValue
        case 2: return HRAudio.assessment_3.rawValue
        case 3: return HRAudio.assessment_4.rawValue
        case 4: 
            return gender == .male ? 
            HRAudio.assessment_5_male.rawValue :
            HRAudio.assessment_5_female.rawValue
        case 5: return HRAudio.a6_recording_time_info.rawValue
        case 6: return HRAudio.a7_after_countdown_info.rawValue
        case 7: return HRAudio.a8_raise_hands_as_PIP.rawValue
        case 8: return HRAudio.a9_pose_time_info.rawValue
        case 9: return HRAudio.a10_pose_timer.rawValue
        case 10: return HRAudio.a11_start_beep.rawValue
        case 11: return HRAudio.a12_recording_time.rawValue
        default: return nil
        }
    }
    
    var index: Int {
        switch self {
        case .assessment_1: return 0
        case .assessment_2: return 1
        case .assessment_3: return 2
        case .assessment_4: return 3
        case .assessment_5_male, .assessment_5_female: return 4
        case .a6_recording_time_info: return 5
        case .a7_after_countdown_info: return 6
        case .a8_raise_hands_as_PIP: return 7
        case .a9_pose_time_info: return 8
        case .a10_pose_timer: return 9
        case .a11_start_beep: return 10
        case .a12_recording_time: return 11
        }
    }
}
