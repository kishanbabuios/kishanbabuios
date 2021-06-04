//
//  ObservationsViewController.swift
//  Care365-iPhone
//
//  Created by Apple on 05/04/21.
//

import UIKit
import MKMagneticProgress
class ObservationsViewController: UIViewController  {
    let obserViewModel = ObsevationViewModel()
    var weightZoneValue : Int?
    var bpZoneValue : Int?
    var bpType : String?
    let bpRedViewModel = BpRedObservationViewModel()
    let wtObsViewModel = WeightObservationViewModel()
    
    
    var weightCreatedString : String?
    var bpCreatedString : String?
    
    var currentWeight :  String?
    var nextWeightCheckupString : String?
    var nextBpCheckupString : String?
    
    var timeLastDial : String?
    //var showSymptoms : Bool?
    
    var isEmergency : Bool?
    var call911Text : String?
    var currentSystolicBp : String?
    var currentDiastolicBp : String?
    
    let HYPER = "hyper"
    let HYPO = "hypo"
    let NORMAL = "normal"
    
    var insightRowHeight : Bool?
    var extraDialysisAccepted : Bool?
    var patientRequestedValue = ""
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var observationTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        //self.loadXibFile()
        isBpEmergency = false
        isWeightEmergency = false
        self.extraDialysisAccepted = false
        self.getPatientWtRecords()
    }
    
    @IBAction func segmentedControllerAction(_ sender: Any) {
        if self.segmentControl.selectedSegmentIndex == 0 {
            isWeightInputGiven = false
            self.getPatientWtRecords()
        }else{
            isBpInputGiven = false
            self.getPatientBpRecords()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isWeightInputGiven == true{
            self.segmentControl.selectedSegmentIndex = 0
            isWeightInputGiven = false
            self.getPatientWtRecords()
        }else if isBpInputGiven == true{
            self.segmentControl.selectedSegmentIndex = 1
            isBpInputGiven = false
            self.getPatientBpRecords()
        }else{
            self.observationTableview.reloadData()
        }
    }
    
    func loadXibFile()  {
        if self.segmentControl.selectedSegmentIndex == 0 {
            let ObservationNib = UINib(nibName:"WeightObservationCell", bundle: nil)
            self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "WeightObservationCell")
            let weightInsightNib = UINib(nibName:"WeightInsightObservationCell", bundle: nil)
            self.observationTableview.register(weightInsightNib, forCellReuseIdentifier: "WeightInsightObservationCell")
        }else{
            let ObservationNib = UINib(nibName:"BpObservationCell", bundle: nil)
            self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "BpObservationCell")
        }
        
    }
    func getPatientWtRecords()  {
        if Utility.isConnectedToInternet() {
            self.showIndicator()
            obserViewModel.getPatientWtRecord { [self] (records, statusCode) in
                DispatchQueue.main.async {
                    self.hideIndicator()
                }
                if statusCode == 200{
                    if records.patientWtMngt == nil {
                        PrintLog.print("No records found")
                    }else{
                        if let patRequested = records.patientWtMngt?.patientRequested{
                            self.extraDialysisAccepted = true
                            self.patientRequestedValue = patRequested
                        }else{
                            
                        }
                        guard let devId = records.patientWtMngt?.deviceId else { return }
                        usrDefaults.setValue(devId, forKey: "weightDeviceId")
                        guard let id = records.patientWtMngt?.id else { return }
                        wtMngmtId = id
                        guard let responseDate = records.patientWtMngt?.createdAt else { return }
                        wtMngmtCreatedAt = responseDate
                        let createdDate = self.responseDateFormatter(dateString: responseDate)
                        self.weightCreatedString = createdDate
                        guard let weight = records.patientWtMngt?.weight else { return  }
                        if weight == "" {
                            DispatchQueue.main.async {
                                self.showAlert(title: "Looks like no weight recordings", message: "please take a new Weight recording")
                                self.tabBarController?.selectedIndex = 0
                            }
                            return
                        }else{
                            self.currentWeight = weight
                            wtMngmtCurrentWeight = weight
                        }
                        let dateFormatter1 = DateFormatter()
                        dateFormatter1.dateFormat = "MM/dd/yyyy HH:mm"
                        guard let starttime = dateFormatter1.date(from: lastDialysisDate) else { return  }
                        guard let endTime = dateFormatter1.date(from: createdDate) else { return  }
                        let timeDifference = Calendar.current.dateComponents([.hour, .minute,.second], from: starttime, to: endTime)
                        if timeDifference.minute! <= 9 {
                            self.timeLastDial = "\(timeDifference.hour!):0\(timeDifference.minute!)"
                            
                        }else{
                            self.timeLastDial = "\(timeDifference.hour!):\(timeDifference.minute!) "
                        }
                        usrDefaults.setValue(self.timeLastDial, forKey: "timeLastDial")
                        let timeDuration = Double(timeDifference.hour!) + (Double(timeDifference.minute!)/60.0)
                        let weightCalculations  = WeightCalculations()
                        self.weightZoneValue = weightCalculations.weight(dryWeight: dryWeight, currentWeight: self.currentWeight!, timeDuration: Double(timeDuration))
                        let strD = dateFormatter1.string(from: Date())
                        let ad = strD.components(separatedBy: " ")
                        let bd = ad[1].components(separatedBy: ":")
                        if Int(bd[0])! > 8  && Int(bd[0])! < 20 || Int(bd[0])! < 20{
                            let updatedDate = self.nextWeightCheckUp(interval: 0)
                            self.nextWeightCheckupString = "\(updatedDate) 20:00 Hrs"
                            PrintLog.print("\(updatedDate) 20:00 Hrs")
                        }else if Int(bd[0])! < 8 ||  Int(bd[0])! > 20 || Int(bd[0])! == 20{
                            let updatedDate = self.nextWeightCheckUp(interval: 8)
                            self.nextWeightCheckupString = "\(updatedDate) 08:00 Hrs"
                            PrintLog.print("\(updatedDate) 08:00 Hrs")
                        }
                        
                        if (records.patientWtMngt?.status) != nil{
                            showWeightInsights = true
                            isBpEmergency = false
                        }else{
                            switch self.weightZoneValue {
                            case 1:
                                showWeightInsights = false
                                isWeightEmergency = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    
                                    guard let vc = StoryBoards.homeStoryBoard.instantiateViewController(identifier: "WeightMajorQuestionnaireVc") as? WeightMajorQuestionnaireVc else { return }
                                    //PrintLog.print(self.bpType! , self.bpZoneValue!)
                                    vc.weightRedSymptomDelegate = self
                                    vc.zoneValue = self.weightZoneValue
                                    let nc = UINavigationController(rootViewController: vc)
                                    nc.modalPresentationStyle = .fullScreen
                                    self.present(nc, animated: true, completion: nil)
                                }
                               
                            case 2:
                                showWeightInsights = false
                                isWeightEmergency = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

                                    guard let vc = StoryBoards.homeStoryBoard.instantiateViewController(identifier: "WeightMajorQuestionnaireVc") as? WeightMajorQuestionnaireVc else { return }
                                   // PrintLog.print(self.bpType! , self.bpZoneValue!)
                                    vc.weightRedSymptomDelegate = self
                                    vc.zoneValue = self.weightZoneValue
                                    let nc = UINavigationController(rootViewController: vc)
                                    nc.modalPresentationStyle = .fullScreen
                                    self.present(nc, animated: true, completion: nil)
                                }
                               
                            case 3:
                                let jsonSymptomWt = ""
                                self.wtObsViewModel.postWeightObservation(presentWt: self.currentWeight!, wtGained: String(weightGainedDefaults), upperPermittedWtGain: upperPermWtGain!, lowerPermittedWtGain: lowerPermWtGain!, zoneOfPat: self.weightZoneValue!, createdAt: wtMngmtCreatedAt!, patientId: patientId, wtMngmntId: wtMngmtId!, timepostdialysis: self.timeLastDial!, symptomsWt: jsonSymptomWt, dryweight: dryWeight, success: { (WeightObservations, statusCode) in
                                    PrintLog.print(WeightObservations, statusCode)
                                }, alertController: self)
                            default:
                                PrintLog.print("default")
                            }
                        }
                        DispatchQueue.main.async {
                            self.observationTableview.delegate = self
                            self.observationTableview.dataSource = self
                            self.observationTableview.reloadData()
                        }
                    }
                }else if statusCode == 401{
                    self.navigationController?.popViewController(animated: false)
                    self.showAlert(title: "Token expired", message: "Please login again")
                }
            }
            
        }else{
            self.showAlert(title: InternetConnectivity.noInternet, message: InternetConnectivity.internetMessage )
        }
    }
    
    func getPatientBpRecords()  {
        if Utility.isConnectedToInternet() {
            self.showIndicator()
            obserViewModel.getPatientBpRecord { (records, statusCode) in
                DispatchQueue.main.async {
                    self.hideIndicator()
                }
                if statusCode == 200{
                    if records.patientBpMngt == nil {
                        PrintLog.print("No records found")
                    }else{
                        guard let devId = records.patientBpMngt?.devid else { return }
                        usrDefaults.setValue(devId, forKey: "bpDeviceId")
                        guard let id = records.patientBpMngt?.id else { return }
                        bpMngmtId = id
                        guard let responseDate = records.patientBpMngt?.created_at else { return }
                        bpMngmtCreatedAt = responseDate
                        let createdDate = self.responseDateFormatter(dateString: responseDate)
                        self.bpCreatedString = createdDate
                        let dateFormatter1 = DateFormatter()
                        dateFormatter1.dateFormat = "MM/dd/yyyy HH:mm"
                        guard let starttime = dateFormatter1.date(from: lastDialysisDate) else { return  }
                        guard let endTime = dateFormatter1.date(from: createdDate) else { return  }
                        let timeDifference = Calendar.current.dateComponents([.hour, .minute], from: starttime, to: endTime)
                        if timeDifference.minute! <= 9 {
                            self.timeLastDial = "\(timeDifference.hour!):0\(timeDifference.minute!) Hrs"
                        }else{
                            self.timeLastDial = "\(timeDifference.hour!):\(timeDifference.minute!) Hrs"
                        }
                        usrDefaults.setValue(self.timeLastDial, forKey: "timeLastDial")
                        guard let sys = records.patientBpMngt?.sys else { return  }
                        if sys == "" {
                            DispatchQueue.main.async {
                                self.showAlert(title: "Looks like no BP recordings", message: "please take a new BP recording")
                                self.tabBarController?.selectedIndex = 0
                            }
                            return
                        }else{
                            self.currentSystolicBp = sys
                        }
                        bpMngmtSys = self.currentSystolicBp
                        guard let dia = records.patientBpMngt?.dia else { return  }
                        self.currentDiastolicBp = dia
                        bpMngmtDia = self.currentDiastolicBp
                        let bpCalculations  = BpCalculations()
                        let sysZone = bpCalculations.SysBloodPressure(sys: self.currentSystolicBp!)
                        let diaZone = bpCalculations.diaBloodPressure(dia: self.currentDiastolicBp!)
                        if sysZone < diaZone {
                            self.bpZoneValue = sysZone
                        }else if diaZone < sysZone{
                            self.bpZoneValue = diaZone
                        }else if diaZone == sysZone{
                            self.bpZoneValue = diaZone
                        }
                        bpMngmtZone = self.bpZoneValue
                        self.bpType =  bpCalculations.getBpType()
                        bpMngmtType = self.bpType
                        let strD = dateFormatter1.string(from: Date())
                        if (records.patientBpMngt?.status) != nil{
                            showBpInsights = true
                            isBpEmergency = false
                        }else{
                            switch self.bpZoneValue {
                            case 1:
                                showBpInsights = false
                                isBpEmergency = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    guard let vc = StoryBoards.homeStoryBoard.instantiateViewController(identifier: "BpQuestionnaireMajorSymptomVc") as? BpQuestionnaireMajorSymptomVc else { return }
                                    PrintLog.print(self.bpType! , self.bpZoneValue!)
                                    vc.bpRedSymptomDelegate = self
                                    vc.bptype = self.bpType
                                    vc.zoneValue = self.bpZoneValue
                                    let nc = UINavigationController(rootViewController: vc)
                                    nc.modalPresentationStyle = .fullScreen
                                    self.present(nc, animated: true, completion: nil)
                                }
                            case 2:
                                showBpInsights = false
                                isBpEmergency = false
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                                    guard let vc = StoryBoards.homeStoryBoard.instantiateViewController(identifier: "BpOrangeQuestionnaireViewContoller") as? BpOrangeQuestionnaireViewContoller else { return }
//                                    PrintLog.print(self.bpType! , self.bpZoneValue!)
//                                    //vc.bpRedSymptomDelegate = self
//                                    vc.bpRedSymptomDelegate = self
//                                    vc.bptype = self.bpType!
//                                    vc.zoneValue = self.bpZoneValue!
//                                    let nc = UINavigationController(rootViewController: vc)
//                                    nc.modalPresentationStyle = .fullScreen
//                                    self.present(nc, animated: true, completion: nil)
//                              }
                         
                            case 3:
                                let  jsonSymptomBp = ""
                                  PrintLog.print(jsonSymptomBp)
                                  self.bpRedViewModel.postBpRedObservation(presentBp: "\(bpMngmtSys!)/\(bpMngmtDia!)", bpResult: bpMngmtType!, symptomsBp: jsonSymptomBp, zoneOfPat: bpMngmtZone!, createdAt: bpMngmtCreatedAt!, patientId: patientId, bpMngmntId: bpMngmtId!, success: { (BpObservations, statusCode) in
                                      //self.bpRedSymptomDelegate?.bpRedSymptomSelected()
                                      PrintLog.print(BpObservations.id!)
                                      PrintLog.print(statusCode)
                                  }, alertController: self)
                            default:
                                PrintLog.print(self.bpZoneValue!)
                            }
                           
                           // self.showSymptoms = true
                        }
                        let ad = strD.components(separatedBy: " ")
                        let bd = ad[1].components(separatedBy: ":")
                        PrintLog.print(ad , bd)
                        if Int(bd[0])! > 8  && Int(bd[0])! < 20 || Int(bd[0])! < 20{
                            let updatedDate = self.nextWeightCheckUp(interval: 0)
                            self.nextBpCheckupString = "\(updatedDate) 20:00 Hrs"
                            PrintLog.print("\(updatedDate) 20:00 Hrs")
                        }else if Int(bd[0])! < 8 ||  Int(bd[0])! > 20 || Int(bd[0])! == 20{
                            let updatedDate = self.nextWeightCheckUp(interval: 8)
                            self.nextBpCheckupString = "\(updatedDate) 08:00 Hrs"
                            PrintLog.print("\(updatedDate) 08:00 Hrs")
                        }
                        DispatchQueue.main.async {
                            self.observationTableview.delegate = self
                            self.observationTableview.dataSource = self
                            self.observationTableview.reloadData()
                        }
                    }
                }else if statusCode == 401{
                    self.navigationController?.popViewController(animated: false)
                }
            }
            
        }else{
            self.showAlert(title: InternetConnectivity.noInternet, message: InternetConnectivity.internetMessage )
        }
    }
    @IBAction func menuAction(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    @IBAction func infoAction(_ sender: Any) {
        guard let vc = StoryBoards.homeStoryBoard.instantiateViewController(identifier: "InformationViewController") as? InformationViewController else { return }
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}
extension ObservationsViewController : UITableViewDelegate,UITableViewDataSource, MajorSymptomDelegate,BpRedSymptomDelegate,BpRedSymptomDelegateFromOrange,WeightRedSymptomDelegate,WeightQuestionnaireDelegate{
    func wtQuestionnaireDelegate() {
        DispatchQueue.main.async {
            let topRow = IndexPath(row: 0,
                                      section: 0)
                                      
               // 2
               self.observationTableview.scrollToRow(at: topRow,
                                          at: .top,
                                          animated: true)
            self.observationTableview.reloadData()
        }
    }
    
    func WeightRedSymptomDelegate() {
        DispatchQueue.main.async {
            let topRow = IndexPath(row: 0,
                                      section: 0)
                                      
               // 2
               self.observationTableview.scrollToRow(at: topRow,
                                          at: .top,
                                          animated: true)
            self.observationTableview.reloadData()
        }
    }
    
    func BpRedSymptomDelegateFromOrange() {
        PrintLog.print(isBpEmergency!)
        DispatchQueue.main.async {
            let topRow = IndexPath(row: 0,
                                      section: 0)
                                      
               // 2
               self.observationTableview.scrollToRow(at: topRow,
                                          at: .top,
                                          animated: true)
            self.observationTableview.reloadData()
        }
    }
    
    func bpRedSymptomSelected() {
        DispatchQueue.main.async {
            let topRow = IndexPath(row: 0,
                                      section: 0)
                                      
               // 2
               self.observationTableview.scrollToRow(at: topRow,
                                          at: .top,
                                          animated: true)
            self.observationTableview.reloadData()
        }

    }
    
    func majorSymptomSelected(titleAlert: String) {
        self.weightZoneValue = 1
        self.isEmergency = true
        self.call911Text = titleAlert
        self.observationTableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentControl.selectedSegmentIndex == 0 {
          return 1
        }else{
            //return self.bpSectionSetUp()
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if self.segmentControl.selectedSegmentIndex == 0 {
            if self.weightZoneValue == 3{
                let ObservationNib = UINib(nibName:"WeightObservationGreenCell", bundle: nil)
                self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "WeightObservationGreenCell")
                let current = tableView.dequeueReusableCell(withIdentifier: "WeightObservationGreenCell", for: indexPath) as! WeightObservationGreenCell
                current.backgroundColor = .clear
                current.weightGreenCreatedAtLabel.text = "\(self.weightCreatedString!) Hrs"
                current.weightGreenNextCheckupLabel.text = "Your next weight check is at:"
                current.weightGreenNextCheckupDateLabel.text = self.nextWeightCheckupString!
                current.weightGreenLastDialysisLabel.text = "Time since last dialysis: \(self.timeLastDial!) Hrs"
                current.weightGreenGainedLabel.text = "Weight gained: \(weightGainedDefaults) kg"
                current.weightGreenPermittedWeightGainLabel.text = "Permitted weight gain: \(permittedWeightGainDefaults) kg"
                current.weightGreenAckLabel.text = "You are doing good"
                //current.weightAcknowledgeLabel.font = Fonts.HelveticaBoldFont
                current.weightGreenMagneticProgressView.percentColor  = Colors.WeightObservationGreenColor
                current.weightGreenMagneticProgressView.progressShapeColor = Colors.WeightObservationGreenColor
                current.weightGreenAckView.backgroundColor = Colors.WeightObservationGreenColor
                current.weightGreenAckViewTwo.backgroundColor = Colors.WeightObservationGreenColor
                current.weightGreenMagneticProgressView.lineWidth = 12
                current.weightGreenMagneticProgressView.backgroundShapeColor = Colors.WeightObservationGreenColor
                current.weightGreenMagneticProgressView.setProgress(progress: 1.0, animated: false)
                current.weightGreenMagneticProgressView.percentLabelFormat = "\(self.currentWeight!) kg"
                cell = current
            }else if self.weightZoneValue == 1 {
                if showWeightInsights == true {
                    let ObservationNib = UINib(nibName:"WeightInsightCell", bundle: nil)
                    self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "WeightInsightCell")
                    let current = tableView.dequeueReusableCell(withIdentifier: "WeightInsightCell", for: indexPath) as! WeightInsightCell
                    current.backgroundColor = .clear
                    current.weightMagneticProgressView.percentColor  = .red
                    current.weightMagneticProgressView.progressShapeColor = .red
                    current.weightMagneticProgressView.lineWidth = 12
                    current.weightMagneticProgressView.backgroundShapeColor = .red
                    current.weightMainAckView.backgroundColor = .red
                    current.weightMagneticProgressView.setProgress(progress: 1.0, animated: false)
                    current.weightMagneticProgressView.percentLabelFormat = "\(self.currentWeight!) kg"
                    current.weightMagneticProgressView.percentColor = .red
                    current.weightLastCreatedatLabel.text = "\(self.weightCreatedString!) Hrs"
                    current.weightNextCheckupLabel.text = "Your next weight check is at:"
                    current.weightNextCheckupDateLabel.text = self.nextWeightCheckupString!
                    current.WeightTimeSinceLastDiaLabel.text = "Time since last dialysis: \(self.timeLastDial!) Hrs"
                    current.weightGainedLabel.text = "Weight gained: \(weightGainedDefaults) kg"
                    current.weightActionableInsightsView.backgroundColor = .red
                    current.weightDescriptionLabel.text = WeightDescriptionType.weightRedDescription
                    current.weightDescriptionLabelTwo.text = "You have gained \(weightGainedDefaults) Kg in \(self.timeLastDial!) Hrs"
                    current.permittedWeightGainLabel.text = "Permitted weight gain: \(permittedWeightGainDefaults) kg"
                    current.weightObservationImageViewThree.image = CRImages.whiteHighAlertIcon
                    current.weightObservationImageView.image = CRImages.redHighAlertIcon
                    current.weightObservationImageViewTwo.image = CRImages.whiteHighAlertIcon
                    current.permittedView.isHidden = false
                    if self.extraDialysisAccepted! {
                        current.weightExtradialysisLabel.isHidden = false
                        switch self.patientRequestedValue {
                        case "0":
                            current.weightExtradialysisLabel.text = ExtraDialysis.acceptedDialysis
                        default:
                            current.weightExtradialysisLabel.text = ExtraDialysis.deniedDialysis
                        }
                    }else{
                        current.weightExtradialysisLabel.isHidden = true
                    }
                    
                    cell = current
                }else if isWeightEmergency == true{
                    let ObservationNib = UINib(nibName:"WeightObservationCell", bundle: nil)
                    self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "WeightObservationCell")
                    let current = tableView.dequeueReusableCell(withIdentifier: "WeightObservationCell", for: indexPath) as! WeightObservationCell
                    current.backgroundColor = .clear
                    current.weightObservationImageView.image = CRImages.redHighAlertIcon
                    current.weightObservationImageViewTwo.image = CRImages.whiteHighAlertIcon
                    current.weightMagneticProgressView.percentColor  = .red
                    current.weightMagneticProgressView.progressShapeColor = .red
                    current.weightMagneticProgressView.lineWidth = 12
                    current.weightMagneticProgressView.backgroundShapeColor = .red
                    current.weightMagneticProgressView.setProgress(progress: 1.0, animated: false)
                    current.weightMagneticProgressView.percentLabelFormat = "\(self.currentWeight!) kg"
                    current.weightMagneticProgressView.percentColor = .red
                    current.weightLastCreatedAtLabel.text = "\(self.weightCreatedString!) Hrs"
                    current.weightNextCheckupLabel.text = "Your next weight check is at:"
                    current.weightNextCheckupDateLabel.text = self.nextWeightCheckupString!
                    current.WeightTimeSinceLastDiaLabel.text = "Time since last dialysis: \(self.timeLastDial!) Hrs"
                    current.weightGainedLabel.text = "Weight gained: \(weightGainedDefaults) kg"
                    current.weightMainAckView.backgroundColor = .red
                    current.permittedView.isHidden = false
                    current.call911View.isHidden = false
                    current.emergencyDescriptionLabel.text = wtMngmtSymptomType ?? ""
                 
                    cell = current
                }else{
                    let ObservationNib = UINib(nibName:"WeightObservationCell", bundle: nil)
                    self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "WeightObservationCell")
                    let current = tableView.dequeueReusableCell(withIdentifier: "WeightObservationCell", for: indexPath) as! WeightObservationCell
                    current.backgroundColor = .clear
                    current.weightMagneticProgressView.percentColor  = .red
                    current.weightMagneticProgressView.progressShapeColor = .red
                    current.weightMagneticProgressView.lineWidth = 12
                    current.weightMagneticProgressView.backgroundShapeColor = .red
                    current.weightMagneticProgressView.setProgress(progress: 1.0, animated: false)
                    current.weightMagneticProgressView.percentLabelFormat = "\(self.currentWeight!) kg"
                    current.weightMagneticProgressView.percentColor = .red
                    current.weightLastCreatedAtLabel.text = "\(self.weightCreatedString!) Hrs"
                    current.weightNextCheckupLabel.text = "Your next weight check is at:"
                    current.weightNextCheckupDateLabel.text = self.nextWeightCheckupString!
                    current.WeightTimeSinceLastDiaLabel.text = "Time since last dialysis: \(self.timeLastDial!) Hrs"
                    current.weightGainedLabel.text = "Weight gained: \(weightGainedDefaults) kg"
                    current.weightMainAckView.backgroundColor = .red
                    current.weightObservationImageView.image = CRImages.redHighAlertIcon
                    current.weightObservationImageViewTwo.image = CRImages.whiteHighAlertIcon
                    current.permittedView.isHidden = true
                    current.call911View.isHidden = true
                    if self.extraDialysisAccepted! {
                        current.extraDialysisLabel.isHidden = false
                        switch self.patientRequestedValue {
                        case "0":
                            current.extraDialysisLabel.text = ExtraDialysis.acceptedDialysis
                        default:
                            current.extraDialysisLabel.text = ExtraDialysis.deniedDialysis
                        }
                    }else{
                        current.extraDialysisLabel.isHidden = true
                    }
                    cell = current
                }
                
            }else if self.weightZoneValue == 2{
                if showWeightInsights == true {
                    let ObservationNib = UINib(nibName:"WeightInsightCell", bundle: nil)
                    self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "WeightInsightCell")
                    let current = tableView.dequeueReusableCell(withIdentifier: "WeightInsightCell", for: indexPath) as! WeightInsightCell
                    current.backgroundColor = .clear
                    current.weightMagneticProgressView.percentColor  = .orange
                    current.weightMagneticProgressView.progressShapeColor = .orange
                    current.weightMagneticProgressView.lineWidth = 12
                    current.weightMagneticProgressView.backgroundShapeColor = .orange
                    current.weightMainAckView.backgroundColor = .orange
                    current.weightMagneticProgressView.setProgress(progress: 1.0, animated: false)
                    current.weightMagneticProgressView.percentLabelFormat = "\(self.currentWeight!) kg"
                    current.weightMagneticProgressView.percentColor = .orange
                    current.weightLastCreatedatLabel.text = "\(self.weightCreatedString!) Hrs"
                    current.weightNextCheckupLabel.text = "Your next weight check is at:"
                    current.weightNextCheckupDateLabel.text = self.nextWeightCheckupString!
                    current.WeightTimeSinceLastDiaLabel.text = "Time since last dialysis: \(self.timeLastDial!) Hrs"
                    current.weightGainedLabel.text = "Weight gained: \(weightGainedDefaults) kg"
                    current.weightActionableInsightsView.backgroundColor = .orange
                    current.weightDescriptionLabel.text = "Alert"
                    current.weightDescriptionLabelTwo.text = "You have gained \(weightGainedDefaults) kg in \(self.timeLastDial!) Hrs"
                    current.weightObservationImageViewThree.image = CRImages.whiteAlertIcon
                    current.weightObservationImageView.image = CRImages.orangeAlertIcon
                    current.weightObservationImageViewTwo.image = CRImages.whiteAlertIcon
                    current.permittedView.isHidden = false
                    if self.extraDialysisAccepted! {
                        current.weightExtradialysisLabel.isHidden = false
                        switch self.patientRequestedValue {
                        case "0":
                            current.weightExtradialysisLabel.text = ExtraDialysis.acceptedDialysis
                        default:
                            current.weightExtradialysisLabel.text = ExtraDialysis.deniedDialysis
                        }
                    }else{
                        current.weightExtradialysisLabel.isHidden = true
                    }
                    cell = current
                }else if isWeightEmergency == true{
                    let ObservationNib = UINib(nibName:"WeightObservationCell", bundle: nil)
                    self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "WeightObservationCell")
                    let current = tableView.dequeueReusableCell(withIdentifier: "WeightObservationCell", for: indexPath) as! WeightObservationCell
                    current.backgroundColor = .clear
                    current.weightMagneticProgressView.percentColor  = .red
                    current.weightMagneticProgressView.progressShapeColor = .red
                    current.weightMagneticProgressView.lineWidth = 12
                    current.weightMagneticProgressView.backgroundShapeColor = .red
                    current.weightObservationImageView.image = CRImages.redHighAlertIcon
                    current.weightObservationImageViewTwo.image = CRImages.whiteHighAlertIcon
                    current.weightMagneticProgressView.setProgress(progress: 1.0, animated: false)
                    current.weightMagneticProgressView.percentLabelFormat = "\(self.currentWeight!) kg"
                    current.weightMagneticProgressView.percentColor = .red
                    current.weightLastCreatedAtLabel.text = "\(self.weightCreatedString!) Hrs"
                    current.weightNextCheckupLabel.text = "Your next weight check is at:"
                    current.weightNextCheckupDateLabel.text = self.nextWeightCheckupString!
                    current.WeightTimeSinceLastDiaLabel.text = "Time since last dialysis: \(self.timeLastDial!) Hrs"
                    current.weightGainedLabel.text = "Weight gained: \(weightGainedDefaults) kg"
                    current.weightMainAckView.backgroundColor = .red
                    current.permittedView.isHidden = true
                    current.call911View.isHidden = false
                    current.emergencyDescriptionLabel.text = wtMngmtSymptomType ?? ""
                    current.extraDialysisLabel.isHidden = true
                    cell = current
                }else{
                    let ObservationNib = UINib(nibName:"WeightObservationCell", bundle: nil)
                    self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "WeightObservationCell")
                    let current = tableView.dequeueReusableCell(withIdentifier: "WeightObservationCell", for: indexPath) as! WeightObservationCell
                    current.backgroundColor = .clear
                    current.weightMagneticProgressView.percentColor  = .orange
                    current.weightMagneticProgressView.progressShapeColor = .orange
                    current.weightMagneticProgressView.lineWidth = 12
                    current.weightMagneticProgressView.backgroundShapeColor = .orange
                    current.weightMagneticProgressView.setProgress(progress: 1.0, animated: false)
                    current.weightMagneticProgressView.percentLabelFormat = "\(self.currentWeight!) kg"
                    current.weightMagneticProgressView.percentColor = .orange
                    current.weightLastCreatedAtLabel.text = "\(self.weightCreatedString!) Hrs"
                    current.weightNextCheckupLabel.text = "Your next weight check is at:"
                    current.weightNextCheckupDateLabel.text = self.nextWeightCheckupString!
                    current.WeightTimeSinceLastDiaLabel.text = "Time since last dialysis: \(self.timeLastDial!) Hrs"
                    current.weightGainedLabel.text = "Weight gained: \(weightGainedDefaults) kg"
                    current.weightMainAckView.backgroundColor = .orange
                    
                    current.weightObservationImageView.image = CRImages.orangeAlertIcon
                    current.weightObservationImageViewTwo.image = CRImages.whiteAlertIcon
                    current.permittedView.isHidden = true
                    current.call911View.isHidden = true
                    current.extraDialysisLabel.isHidden = true
                    cell = current
                }
               
            }
        }else{
            if  self.bpZoneValue == 3 {
                let ObservationNib = UINib(nibName:"BpObservationCell", bundle: nil)
                self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "BpObservationCell")
                let current = tableView.dequeueReusableCell(withIdentifier: "BpObservationCell", for: indexPath) as! BpObservationCell
                current.backgroundColor = .clear
                current.bpTitleLabel.text = "Blood Pressure"
                current.bpCreatedLabel.text = "\(self.bpCreatedString!) Hrs"
                current.bpNextCheckupLabel.text = "Your next BP check is at: "
                current.bpNextCheckupDateLabel.text = self.nextBpCheckupString!
                current.bpNextCheckupLabelTwo.text = "Your next BP Check is at: \(self.nextBpCheckupString!)"
                current.bpMagneticProgress.lineWidth = 12
                current.bpMagneticProgress.percentLabelFormat = "\(self.currentSystolicBp!)/\(self.currentDiastolicBp!)"
                current.bpMagneticProgress.percentColor = Colors.WeightObservationGreenColor
                current.bpUnitsLabel.text =  "mmHg"
                current.bpUnitsLabel.textColor = Colors.WeightObservationGreenColor
                current.bpMagneticProgress.progressShapeColor = Colors.WeightObservationGreenColor
                current.bpMagneticProgress.setProgress(progress: 1.0, animated: true)
                cell = current
            }else if self.bpZoneValue == 1{
                if showBpInsights == true {
                    if self.bpType == BpType.HYPO {
                        let ObservationNib = UINib(nibName:"BpObservationHypoCell", bundle: nil)
                        self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "BpObservationHypoCell")
                        let current = tableView.dequeueReusableCell(withIdentifier: "BpObservationHypoCell", for: indexPath) as! BpObservationHypoCell
                        current.backgroundColor = .clear
                            current.bpCreatedAtLabel.text = "\(self.bpCreatedString!) Hrs"
                            current.bpRedNextChekupLabel.text = "Your next Bp Check is at: "
                            current.bpRedNextCheckupDateLabel.text = self.nextBpCheckupString!
                            current.bpRedMagneticProgressView.lineWidth = 12
                        current.bpRedUnitsLabel.textColor = .red
                            current.bpRedMagneticProgressView.percentLabelFormat = "\(self.currentSystolicBp!)/\(self.currentDiastolicBp!)"
                            current.bpRedMagneticProgressView.percentColor = .red
                            current.bpRedMagneticProgressView.progressShapeColor = .red
                        current.bpRedDescriptionLabel.text = BpDescriptionType.bpHypoDescription
                        current.bpHypoImageView.image = CRImages.redHighAlertIcon
                        current.bpHypoImageViewTwo.image = CRImages.whiteHighAlertIcon
                        current.bpHypoView.backgroundColor = .red
                           current.bpRedMagneticProgressView.setProgress(progress: 1.0, animated:false)
                        cell = current
                    }else{
                        let ObservationNib = UINib(nibName:"BpObservationHyperCell", bundle: nil)
                        self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "BpObservationHyperCell")
                        let current = tableView.dequeueReusableCell(withIdentifier: "BpObservationHyperCell", for: indexPath) as! BpObservationHyperCell
                        current.backgroundColor = .clear
                            current.bpHyperCreatedAtLabel.text = "\(self.bpCreatedString!) Hrs"
                            current.bpHyperNextCheckupLabel.text = "Your next Bp Check is at: "
                            current.bpHyperCheckupDateLabel.text = self.nextBpCheckupString!
                            current.bpHyperMagneticProgressView.lineWidth = 12
                        current.bpHyperUnitsLabel.textColor = .red
                            current.bpHyperMagneticProgressView.percentLabelFormat = "\(self.currentSystolicBp!)/\(self.currentDiastolicBp!)"
                            current.bpHyperMagneticProgressView.percentColor = .red
                            current.bpHyperMagneticProgressView.progressShapeColor = .red
                       // current.bpHyperMagneticProgressView.backgroundColor = .red
                        current.bpHyperMagneticProgressView.setProgress(progress: 1.0, animated:false)
                        current.bpHyperDescriptionLabel.text = BpDescriptionType.bpHyperDescription
                        current.bpHyperImageView.image = CRImages.redHighAlertIcon
                        current.bpHyperImageViewTwo.image = CRImages.whiteHighAlertIcon
                        current.bpHyperView.backgroundColor = .red
                        cell = current
                    }
                } else if isBpEmergency == true {
                    let ObservationNib = UINib(nibName:"BpObservationEmergencyCell", bundle: nil)
                    self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "BpObservationEmergencyCell")
                    let current = tableView.dequeueReusableCell(withIdentifier: "BpObservationEmergencyCell", for: indexPath) as! BpObservationEmergencyCell
                    current.backgroundColor = .clear
                        current.bpRedCreatedAtLabel.text = "\(self.bpCreatedString!) Hrs"
                        current.bpRedNextCheckupLabel.text = "Your next Bp Check is at: "
                        current.bpRedNextCheckupDateLabel.text = self.nextBpCheckupString!
                        current.bpRedMagneticProgressView.lineWidth = 12
                        current.bpRedMagneticProgressView.percentLabelFormat = "\(self.currentSystolicBp!)/\(self.currentDiastolicBp!)"
                        current.bpRedMagneticProgressView.percentColor = .red
                        current.bpRedMagneticProgressView.progressShapeColor = .red
                        current.bpRedMagneticProgressView.setProgress(progress: 1.0, animated: false)
                    if bpMngmtType == BpType.HYPER {
                        current.bpRedDescriptionLabel.text = BpDescriptionType.bpHyperDescription
                        current.bpRedSymtomLabel.text = BpDescriptionType.bpRedSymptomDescription
                    }else{
                        current.bpRedDescriptionLabel.text = BpDescriptionType.bpHypoDescription
                        current.bpRedSymtomLabel.text = bpMngmtSymptomType
                    }
                    cell = current
                }else{
                    let ObservationNib = UINib(nibName:"BpObservationRedCell", bundle: nil)
                    self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "BpObservationRedCell")
                    let current = tableView.dequeueReusableCell(withIdentifier: "BpObservationRedCell", for: indexPath) as! BpObservationRedCell
                current.backgroundColor = .clear
                    current.bpCreatedLabel.text = "\(self.bpCreatedString!) Hrs"
                    current.nextBpCheckupLabel.text = "Your next Bp Check is at: "
                    current.nextBpCheckupDateLabel.text = self.nextBpCheckupString!
                    current.bpRedMagneticProgressView.lineWidth = 12
                    current.bpRedMagneticProgressView.percentLabelFormat = "\(self.currentSystolicBp!)/\(self.currentDiastolicBp!)"
                    current.bpRedMagneticProgressView.percentColor = .red
                    current.bpUnitsLabel.text =  "mmHg"
                    current.bpUnitsLabel.textColor = .red
                    current.bpRedMagneticProgressView.progressShapeColor = .red
                    current.bpRedMagneticProgressView.setProgress(progress: 1.0, animated: false)
                    if self.bpType == HYPO {
                        current.bpTypeDescriptionLabel.text = BpDescriptionType.bpHypoDescription
                    }else if self.bpType == HYPER {
                        current.bpTypeDescriptionLabel.text = BpDescriptionType.bpHyperDescription
                    }
                    cell = current
                }
            }else if self.bpZoneValue == 2{
                if showBpInsights == true {
                    if self.bpType == BpType.HYPO{
                        let ObservationNib = UINib(nibName:"BpObservationHypoCell", bundle: nil)
                        self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "BpObservationHypoCell")
                        let current = tableView.dequeueReusableCell(withIdentifier: "BpObservationHypoCell", for: indexPath) as! BpObservationHypoCell
                        current.backgroundColor = .clear
                            current.bpCreatedAtLabel.text = "\(self.bpCreatedString!) Hrs"
                            current.bpRedNextChekupLabel.text = "Your next Bp Check is at: "
                            current.bpRedNextCheckupDateLabel.text = self.nextBpCheckupString!
                            current.bpRedMagneticProgressView.lineWidth = 12
                        current.bpRedUnitsLabel.textColor = .orange
                            current.bpRedMagneticProgressView.percentLabelFormat = "\(self.currentSystolicBp!)/\(self.currentDiastolicBp!)"
                            current.bpRedMagneticProgressView.percentColor = .orange
                            current.bpRedMagneticProgressView.progressShapeColor = .orange
                        current.bpRedDescriptionLabel.text = BpDescriptionType.bpHypoDescription
                        current.bpHypoImageView.image = CRImages.orangeAlertIcon
                        current.bpHypoImageViewTwo.image = CRImages.whiteAlertIcon
                        current.bpHypoView.backgroundColor = .orange
                        current.bpRedMagneticProgressView.setProgress(progress: 1.0, animated: false)
                        cell = current
                    }else{
                        let ObservationNib = UINib(nibName:"BpObservationHyperCell", bundle: nil)
                        self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "BpObservationHyperCell")
                        let current = tableView.dequeueReusableCell(withIdentifier: "BpObservationHyperCell", for: indexPath) as! BpObservationHyperCell
                        current.backgroundColor = .clear
                            current.bpHyperCreatedAtLabel.text = "\(self.bpCreatedString!) Hrs"
                            current.bpHyperNextCheckupLabel.text = "Your next Bp Check is at: "
                            current.bpHyperCheckupDateLabel.text = self.nextBpCheckupString!
                            current.bpHyperMagneticProgressView.lineWidth = 12
                        current.bpHyperUnitsLabel.textColor = .orange
                            current.bpHyperMagneticProgressView.percentLabelFormat = "\(self.currentSystolicBp!)/\(self.currentDiastolicBp!)"
                            current.bpHyperMagneticProgressView.percentColor = .orange
                            current.bpHyperMagneticProgressView.progressShapeColor = .orange
                        current.bpHyperDescriptionLabel.text = BpDescriptionType.bpHyperDescription
                        current.bpHyperImageView.image = CRImages.orangeAlertIcon
                        current.bpHyperImageViewTwo.image = CRImages.whiteAlertIcon
                        current.bpHyperView.backgroundColor = .orange
                        cell = current
                    }
                }else if isBpEmergency == true{
                    let ObservationNib = UINib(nibName:"BpObservationEmergencyCell", bundle: nil)
                    self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "BpObservationEmergencyCell")
                    let current = tableView.dequeueReusableCell(withIdentifier: "BpObservationEmergencyCell", for: indexPath) as! BpObservationEmergencyCell
                    current.backgroundColor = .clear
                        current.bpRedCreatedAtLabel.text = "\(self.bpCreatedString!) Hrs"
                        current.bpRedNextCheckupLabel.text = "Your next Bp Check is at: "
                        current.bpRedNextCheckupDateLabel.text = self.nextBpCheckupString!
                        current.bpRedMagneticProgressView.lineWidth = 12
                        current.bpRedMagneticProgressView.percentLabelFormat = "\(self.currentSystolicBp!)/\(self.currentDiastolicBp!)"
                        current.bpRedMagneticProgressView.percentColor = .red
                        current.bpRedMagneticProgressView.progressShapeColor = .red
                        current.bpRedMagneticProgressView.setProgress(progress: 1.0, animated: true)
                    if bpMngmtType == BpType.HYPER {
                        current.bpRedDescriptionLabel.text = BpDescriptionType.bpHyperDescription
                        current.bpRedSymtomLabel.text = BpDescriptionType.bpRedSymptomDescription
                    }else{
                        current.bpRedDescriptionLabel.text = BpDescriptionType.bpHypoDescription
                        current.bpRedSymtomLabel.text = bpMngmtSymptomType
                    }
                    cell = current
                }else{
                    let ObservationNib = UINib(nibName:"BpOrangeFirstTimeObservationCell", bundle: nil)
                    self.observationTableview.register(ObservationNib, forCellReuseIdentifier: "BpOrangeFirstTimeObservationCell")
                    let current = tableView.dequeueReusableCell(withIdentifier: "BpOrangeFirstTimeObservationCell", for: indexPath) as! BpOrangeFirstTimeObservationCell
                    current.backgroundColor = .clear
                        current.bpOrangeLastCreatedLabel.text = "\(self.bpCreatedString!) Hrs"
                        current.bpOrangeNextCheckupLabel.text = "Your next Bp Check is at: "
                        current.bpOrangeNextCheckupDateLabel.text = self.nextBpCheckupString!
                    current.bpOrangeNextBpCheckupLabelTwo.text = " Your next Bp Check is at: \(self.nextBpCheckupString!)"
                        current.bpOrangeMagneticProgressView.lineWidth = 12
                        current.bpOrangeMagneticProgressView.percentLabelFormat = "\(self.currentSystolicBp!)/\(self.currentDiastolicBp!)"
                    current.bpOrangeMagneticProgressView.percentColor = .orange
                    current.bpOrangeMagneticProgressView.progressShapeColor = .orange
                        current.bpOrangeMagneticProgressView.setProgress(progress: 1.0, animated: true)
                    if self.bpType == BpType.HYPER {
                        current.bpOrangeDescriptionLabel.text = BpDescriptionType.bpHyperDescription
                    }else{
                        current.bpOrangeDescriptionLabel.text = BpDescriptionType.bpHypoDescription
                    }
                    cell = current
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if segmentControl.selectedSegmentIndex == 0 {
            if showWeightInsights == true {
                return 1300
            }else{
                return 800
            }
        }else {
            //return CGFloat(self.bpRowSetup())
            if showBpInsights == true {
                return 1000
            }else{
                return 800
            }
            
        }
        
    }
    
    func bpSectionSetUp() -> Int {
        if self.bpZoneValue == 3 {
            return 2
        }else if  self.bpZoneValue == 1{
            if isBpInputGiven == true {
                return 2
            }else{
                return 2
            }
        }else{
            return 1
        }
    }
    func bpRowSetup() -> Int {
        if self.bpZoneValue == 3 {
            return 372
        }else if  self.bpZoneValue == 1{
            if isBpInputGiven == true {
                if self.insightRowHeight == true {
                    return 700
                }else{
                    self.insightRowHeight = false
                    return 372
                }
            }else{
                if self.insightRowHeight == true {
                    return 700
                }else{
                    return 372
                }
            }
        }else{
            return 600
        }
    }
}
