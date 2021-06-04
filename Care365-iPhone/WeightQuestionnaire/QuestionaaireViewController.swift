//
//  QuestionaaireViewController.swift
//  Care365-iPhone
//
//  Created by Apple on 03/05/21.
//

import UIKit
import SCLAlertView
protocol WeightQuestionnaireDelegate : AnyObject{
    func wtQuestionnaireDelegate()
}
class QuestionaaireViewController: UIViewController {

    @IBOutlet weak var questionaaireTableView: UITableView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    weak var wtQuestionnaireDelegate : WeightQuestionnaireDelegate?
    let wtObsViewModel = WeightObservationViewModel()
    var bptype = ""
    @IBOutlet weak var submitButton: UIButton!
    var zoneValue = 0
    var chatNameSize = CGSize()
    var surveyArr = [arr]()
    var statusUpdateArr = [arr]()
    var count = Int()
    var cellHeight = CGFloat()
    var selectedImagesArr = [String]()
    var selectedSymptomArr = [String]()
    var LastIndexCount = 0
    var submitActionVc = ""
    var statusObj = arr()
    var statusVal = arr()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.yesButton.isHidden = false
        self.noButton.isHidden = false
        self.submitButton.isHidden = true
        self.questionaaireTableView.delegate = self
        self.questionaaireTableView.dataSource = self
        self.questionaaireTableView.separatorStyle = .none
        let url = Bundle.main.url(forResource: "survey", withExtension: "json")!
        do{
            let jsonData = try Data(contentsOf: url) as  Any
            let mainData = try JSONDecoder().decode(Symptom.self, from: jsonData as! Data)
            if self.zoneValue == 2 {
                guard let secArr = mainData.weight?.orange?.survey else { return }
                print(secArr)
                self.surveyArr = secArr
                self.statusUpdateArr.append(secArr[0])
                //self.symptomArray.append((secArr[0].options?[0])!)
            }
            if  self.zoneValue == 1 {
                guard let secArr = mainData.weight?.red?.survey else { return }
                print(secArr)
                self.surveyArr = secArr
                self.statusUpdateArr.append(secArr[0])
            }
        }
        catch {
            print(error.localizedDescription)
        }
     
    }
    
    @IBAction func yesAction(_ sender: UIButton) {
        let yesObj = self.surveyArr[count].options?[0]
        yesOrNoMethod(optionalObj: yesObj!, status: "Yes")
    }
    
    @IBAction func noAction(_ sender: UIButton) {
        let noObj = self.surveyArr[count].options?[1]
        yesOrNoMethod(optionalObj: noObj!, status: "No")
    }
    
    func yesOrNoMethod(optionalObj: Options,status:String)  {
        self.LastIndexCount = self.LastIndexCount + 1
        if optionalObj.trigger != "nil" && optionalObj.show == "insights"{
            self.QuestionnaireFlowCondition(status: status)
            if optionalObj.imgUrl != "NA" {
                self.selectedSymptomArr.insert(optionalObj.symptom ?? "", at: self.selectedSymptomArr.count)
                self.selectedImagesArr.insert(optionalObj.imgUrl ?? "", at: self.selectedImagesArr.count)
            }
            self.questionaaireTableView.reloadData()
        }else if optionalObj.trigger == "nil" && optionalObj.show == "insights"{
            self.QuestionnaireFlowCondition(status: status)
            if optionalObj.imgUrl != "NA" {
                self.selectedSymptomArr.insert(optionalObj.symptom ?? "", at: self.selectedSymptomArr.count)
                self.selectedImagesArr.insert(optionalObj.imgUrl ?? "", at: self.selectedImagesArr.count)
            }
            self.questionaaireTableView.reloadData()
            self.submitActionVc = SubmitActionVc.insightsVc.rawValue
        }else {
            print("Dismiss VC")
            if optionalObj.imgUrl != "NA" {
                self.selectedSymptomArr.insert(optionalObj.symptom ?? "", at: self.selectedSymptomArr.count)
                self.selectedImagesArr.insert(optionalObj.imgUrl ?? "", at: self.selectedImagesArr.count)
            }
            
            //emergency
            self.submitActionVc = SubmitActionVc.emergencyVc.rawValue
            isWeightEmergency = true
            self.postOservations()
            wtMngmtSymptomType = self.selectedSymptomArr[0]
            self.dismiss(animated: true, completion: nil)
        }
        print(self.selectedImagesArr)
        print(self.selectedSymptomArr)
        PrintLog.print(self.statusUpdateArr.count, self.surveyArr.count)
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.statusUpdateArr.count-1, section: 0)
            self.questionaaireTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        if self.LastIndexCount == self.surveyArr.count {
            self.yesButton.isHidden = true
            self.noButton.isHidden = true
            self.submitButton.isHidden = false
        }
    }
    @IBAction func submitAction(_ sender: UIButton) {
        if self.submitActionVc == SubmitActionVc.emergencyVc.rawValue{
            self.dismiss(animated: true) {
                isWeightEmergency = true
                self.postOservations()
            }
        }else if self.submitActionVc == SubmitActionVc.insightsVc.rawValue{
            showWeightInsights = true
            self.postOservations()
            weak var pvc = self.presentingViewController
            if isExtraDialysis! {
                self.dismiss(animated: false) {
                    let minorVc = StoryBoards.homeStoryBoard.instantiateViewController(identifier: "ExtraDialysisViewController") as ExtraDialysisViewController
                   let nc = UINavigationController(rootViewController: minorVc)
                   nc.modalPresentationStyle = .fullScreen
                    minorVc.insightType = InsightType.weight
                   minorVc.zoneValue = self.zoneValue
                    pvc?.present(nc, animated: false, completion: nil)
                }
            }else{
                self.dismiss(animated: false) {
                    let minorVc = StoryBoards.homeStoryBoard.instantiateViewController(identifier: "InsightViewController") as InsightViewController
                   let nc = UINavigationController(rootViewController: minorVc)
                   nc.modalPresentationStyle = .fullScreen
                    minorVc.insightType = InsightType.weight
                   minorVc.zoneValue = self.zoneValue
                    pvc?.present(nc, animated: false, completion: nil)
                }
            }
        }

}
    func postOservations()  {
        self.wtQuestionnaireDelegate?.wtQuestionnaireDelegate()
        var symNameArr = [[String:Any]]()
        for i in 0..<self.selectedSymptomArr.count {
            PrintLog.print(self.selectedSymptomArr[i])
            let dic = ["symptomName":self.selectedSymptomArr[i],"symptomUrl":self.selectedImagesArr[i]]
            symNameArr.append(dic)
            PrintLog.print(symNameArr)
        }
        let jsonSymptomWt = self.convertingArrayToString(inputArray: symNameArr)
        PrintLog.print(jsonSymptomWt)
        self.wtObsViewModel.postWeightObservation(presentWt: wtMngmtCurrentWeight!, wtGained: String(weightGainedDefaults), upperPermittedWtGain: upperPermWtGain!, lowerPermittedWtGain: lowerPermWtGain!, zoneOfPat: self.zoneValue, createdAt: wtMngmtCreatedAt!, patientId: patientId, wtMngmntId: wtMngmtId!, timepostdialysis: timeLastDial, symptomsWt: jsonSymptomWt, dryweight: dryWeight, success: { (WeightObservations, statusCode) in
            PrintLog.print(WeightObservations, statusCode)
        }, alertController: self)
    }
    
    func convertingArrayToString(inputArray : Array<Any>) -> String{
        var result = ""
        do{
            let data =  try JSONSerialization.data(withJSONObject: inputArray, options: .prettyPrinted) as? Data
            if let data2 = data {
                let json = NSString(data: data2, encoding: String.Encoding.utf8.rawValue)
                if let json2 = json {
                    result = json2 as String
                    print(result)
                }
            }
        }catch{
            print(error)
        }
        return result
    }
    
    func QuestionnaireFlowCondition(status :  String)  {
        if count < self.surveyArr.count - 1 {
            if count == 0 {
                self.count = 1
                self.statusUpdateArr.removeAll()
                statusObj.message = self.surveyArr[0].message ?? ""
                statusObj.status = status
                self.statusUpdateArr.insert(statusObj, at: 0)
                statusVal.message = self.surveyArr[count].message ?? ""
                self.statusUpdateArr.append(statusVal)
            }else {
                statusObj.message = self.surveyArr[count].message ?? ""
                statusObj.status = status
                self.statusUpdateArr[count] = statusObj
                self.count += 1
                statusVal.message = self.surveyArr[count].message ?? ""
                self.statusUpdateArr.append(statusVal)
            }
        }else {
            statusObj.message = self.surveyArr[count].message ?? ""
            statusObj.status = status
            self.statusUpdateArr[count] = statusObj
        }
    }
}
extension QuestionaaireViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statusUpdateArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let statusHeight = self.statusUpdateArr[indexPath.row]
        if statusHeight.status != nil {
            return 180
        }else {
            return 110
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  surveycell = tableView.dequeueReusableCell(withIdentifier: "QuestionnaireTableCell") as! QuestionnaireTableCell
        let surveyObj = self.statusUpdateArr[indexPath.row ]
        surveycell.queLabel.text = surveyObj.message ?? ""
        surveycell.yesOrNoLabel.setTitle(surveyObj.status ?? "", for: .normal)
        return surveycell
    }
}
