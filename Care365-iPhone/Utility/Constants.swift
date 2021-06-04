//
//  Constants.swift
//  Care365-iPhone
//
//  Created by Apple on 29/03/21.
//

import Foundation
import UIKit

let usrDefaults = UserDefaults.standard
var jwtToken = usrDefaults.string(forKey: "JwtToken") ?? ""
//var userId = usrDefaults.string(forKey: "UserId") ?? ""
var patientId = usrDefaults.string(forKey: "PatientId") ?? ""
var isLoggedIn = usrDefaults.bool(forKey: "LoggedIn")
var systolicBp = usrDefaults.string(forKey: "systolicBloodPressure") ?? ""
var diastolicBp = usrDefaults.string(forKey: "diastolicBloodPressure") ?? ""
var lastDialysisDate = usrDefaults.string(forKey: "last_dialysis_date") ?? ""
var nextDialysisDate = usrDefaults.string(forKey: "next_dialysis_date") ?? ""
var postDialysisWeight = usrDefaults.string(forKey: "post_wt") ?? ""
var dialysisStatus = usrDefaults.string(forKey: "status") ?? ""
//var patientWeight = usrDefaults.string(forKey: "weight") ?? ""
var interDialstolicPeriod = usrDefaults.string(forKey: "duration") ?? ""
var dryWeight = usrDefaults.string(forKey: "dryWeight") ?? ""
var createdAtDate = usrDefaults.string(forKey: "createdAt") ?? ""
var weightGainedDefaults = usrDefaults.double(forKey: "weightGained")
var permittedWeightGainDefaults = usrDefaults.double(forKey: "permittedWeightGain")
var timeLastDial = usrDefaults.string(forKey: "timeLastDial") ?? ""
var weightInput = usrDefaults.string(forKey: "weightInput") ?? ""
var isWeightInputGiven : Bool?
var weightDeviceId = usrDefaults.string(forKey: "weightDeviceId") ?? ""
var bpDeviceId = usrDefaults.string(forKey: "bpDeviceId") ?? ""

var upperLimitDefaults = usrDefaults.double(forKey: "upperLimit")
var upperPermWtGain : String?
var lowerPermWtGain : String?
var sysInput = usrDefaults.string(forKey: "sysInput") ?? ""
var diaInput = usrDefaults.string(forKey: "diaInput") ?? ""
var isBpInputGiven : Bool?
var isBpEmergency : Bool?
var isWeightEmergency : Bool?

//patientBpManagement
var bpMngmtId : String?
var bpMngmtSys : String?
var bpMngmtDia : String?
var bpMngmtZone : Int?
var bpMngmtCreatedAt: String?
var bpMngmtType : String?
var bpMngmtSymptomType : String?
var showBpInsights : Bool?
//patientWeightManagement
var wtMngmtId : String?
var wtMngmtZone : Int?
var wtMngmtCreatedAt: String?
var wtMngmtType : String?
var wtMngmtSymptomType : String?
var wtMngmtCurrentWeight : String?
var timeSinceLastDialysis : String?

var showWeightInsights : Bool?
var isExtraDialysis : Bool?

struct DevelopmentServer {
    static let baseUrl = "https://care365dev.xyramsoft.com:444"
}
struct InternetConnectivity {
    static let noInternet = "No Internet"
    static let internetMessage = "Please check your internet connectivity"
}
struct Login {
    static let loginUrl = "/authenticateapp"
    static let deviceId = UIDevice.current.identifierForVendor?.uuidString
    static let LoginViewController = "LoginViewController"
}
struct CreateBpAndWeight {
    static let createBpUrl = "/care365-profile-mgmt/patient-resource/createPatientbpmngt"
    static let createWeightUrl = "/care365-profile-mgmt/patient-resource/createPatientwtmngt"
}

struct ExtraDialysis {
    static let postExtraDialysisUrl = "/care365-profile-mgmt/patient-resource/createAppointmentReq"
    static let deniedDialysis = "You denied for extra dialysis, \nYou will receive a response shortly."
    static let acceptedDialysis = "You requested for extra dialysis, \nYou will receive a response shortly."
}
struct PatientDetails {
    static let patientDetailUrl = "/care365-profile-mgmt/patient-resource/patients/"
    static let patientDialysisInfoUrl = "/care365-profile-mgmt/patient-resource/getlastDialysisInfo/"
    static let pateintBpandWeightRecUrl = "/care365-profile-mgmt/patient-resource/getPatientWtBP/"
}
struct PostObservations {
    static let postBpObser = "/care365-profile-mgmt/patient-resource/createPatientbpObs?"
    static let postWeightObser = "/care365-profile-mgmt/patient-resource/createPatientwtObs?"
}
struct BpDescriptionType {
    static let bpHyperDescription = "Your BP is way above the normal"
    static let bpHypoDescription = "Your BP is way below the normal"
    static let bpRedSymptomDescription = "You probably might have Cardio Vascular Stroke"
}

struct WeightDescriptionType {
    static let weightOrangeDescription  = "Your Weight is way below the normal"
    static let weightRedDescription  = "Your Weight is way below the normal"
}
struct PatientHistory {
    static let weightHistory = "/care365-profile-mgmt/patient-resource/getpatientswt/"
    static let bloodPressHistory = "/care365-profile-mgmt/patient-resource/getPatientbp/"
}
struct StoryBoards {
    static let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    static let homeStoryBoard = UIStoryboard(name: "Home", bundle: nil)
}

struct HomeControllers {
    static let MenuViewController = "MenuViewController"
    static let MainViewController = "MainViewController"
    static let NavigationViewController = "NavigationViewController"
    static let tabBarViewController = "TabBarViewController"
    static let ReachabilityViewController = "ReachabilityViewController"
    static let homeViewController = "HomeViewController"
    static let PluseViewController = "PluseViewController"
    static let VideoViewController = "VideoViewController"
    static let NotificationsViewController = "NotificationsViewController"
}

struct Colors {
    static let AppColor = UIColor.init(named: "AppColor")
    static let WeightObservationGreenColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
    static let ActionButtonColor = UIColor(red: 0/255, green: 43/255, blue: 107/255, alpha: 1.0)
    static let symptomCellLayerColor =  UIColor(red: 0.129, green: 0.588, blue: 0.953, alpha: 1)
}
struct Fonts {
    static let HelveticaBoldFont = UIFont(name: "HelveticaNeue-Bold", size: 15)
}
struct CRImages {
    static let whiteThumbsupIcon = UIImage(named: "whiteThumbsup")
    static let greenThumbsupIcon = UIImage(named: "greenThumbsup")
    static let orangeAlertIcon = UIImage(named: "orangeAlert")
    static let whiteAlertIcon = UIImage(named: "whiteAlert")
    static let whiteHighAlertIcon = UIImage(named: "whiteHighAlert")
    static let redHighAlertIcon = UIImage(named: "redHighAlert")
    static let WeightWhiteIcon = UIImage(named: "Weight White")
    static let WeightBlueIcon = UIImage(named: "Weight Blue")
    static let BpBlueIcon = UIImage(named: "BP Blue")
    static let BpWhiteIcon = UIImage(named: "BPWhite")
}

struct VideoUrl {
    static let breathingExerciseUrl = "https://care365dev.xyramsoft.com/test/breathing_execise.mp4"
    static let anklePumpUrl = "https://care365dev.xyramsoft.com/test/ankle_pump_execise.mp4"
    static let weightMeasureUrl = "https://care365dev.xyramsoft.com/test/weight_measure.mp4"
    static let bpMeasureUrl = "https://care365dev.xyramsoft.com/test/measurebp.mp4"
}

struct BpType{
    static let HYPER = "hyper"
    static let HYPO = "hypo"
    static let NORMAL = "normal"
}
struct InsightType {
    static let bp = "bp"
    static let weight = "weight"
}
public struct PrintLog {
    public static func print(_ items: Any..., separator: String = " ", terminator: String = "\n", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        #if DISABLE_LOG
           // let prefix = modePrefix(Date(), file: file, function: function, line: line)
            let stringItem = items.map {"\($0)"} .joined(separator: separator)
            Swift.print("\(stringItem)", terminator: terminator)
        #endif
    }
}

