//
//  BpOrangeQuestionnaireViewContoller.swift
//  Care365-iPhone
//
//  Created by Apple on 07/05/21.
//

import UIKit
protocol BpRedSymptomDelegateFromOrange : AnyObject{
    func BpRedSymptomDelegateFromOrange()
}
class BpOrangeQuestionnaireViewContoller: UIViewController {
    
    @IBOutlet weak var yesButton: UIButton!
   // weak var BpRedSymptomDelegateFromOrange : BpRedSymptomDelegateFromOrange?
    weak var bpRedSymptomDelegate : BpRedSymptomDelegate?
    let bpRedViewModel = BpRedObservationViewModel()
    var bptype = ""
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
    @IBOutlet weak var submitAction: UIButton!
    @IBOutlet weak var questionnaireTableView: UITableView!
    @IBOutlet weak var noButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.yesButton.isHidden = false
        self.noButton.isHidden = false
        self.submitAction.isHidden = true
        self.questionnaireTableView.delegate = self
        self.questionnaireTableView.dataSource = self
        self.questionnaireTableView.separatorStyle = .none
        let url = Bundle.main.url(forResource: "survey", withExtension: "json")!
        do{
            let jsonData = try Data(contentsOf: url) as  Any
            let mainData = try JSONDecoder().decode(Symptom.self, from: jsonData as! Data)
            if self.bptype == BpType.HYPER && self.zoneValue == 2 {
                guard let secArr = mainData.Hypertension?.orange?.survey else { return }
                print(secArr)
                self.surveyArr = secArr
                self.statusUpdateArr.append(secArr[0])
                //self.symptomArray.append((secArr[0].options?[0])!)
            }
            if self.bptype == BpType.HYPO && self.zoneValue == 2 {
                guard let secArr = mainData.Hypotension?.orange?.survey else { return }
                print(secArr)
                self.surveyArr = secArr
                self.statusUpdateArr.append(secArr[0])
                //self.symptomArray.append((secArr[0].options?[0])!)
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
            self.questionnaireTableView.reloadData()
        }else if optionalObj.trigger == "nil" && optionalObj.show == "insights"{
            self.QuestionnaireFlowCondition(status: status)
            if optionalObj.imgUrl != "NA" {
                self.selectedSymptomArr.insert(optionalObj.symptom ?? "", at: self.selectedSymptomArr.count)
                self.selectedImagesArr.insert(optionalObj.imgUrl ?? "", at: self.selectedImagesArr.count)
            }
            self.questionnaireTableView.reloadData()
            self.submitActionVc = SubmitActionVc.insightsVc.rawValue
        }else {
            print("Dismiss VC")
            if optionalObj.imgUrl != "NA" {
                self.selectedSymptomArr.insert(optionalObj.symptom ?? "", at: self.selectedSymptomArr.count)
                self.selectedImagesArr.insert(optionalObj.imgUrl ?? "", at: self.selectedImagesArr.count)
            }
            self.submitActionVc = SubmitActionVc.emergencyVc.rawValue
            isBpEmergency = true
            self.postOservations()
            bpMngmtSymptomType = self.selectedSymptomArr[0]
            self.dismiss(animated: true, completion: nil)
        }
        print(self.selectedImagesArr)
        print(self.selectedSymptomArr)
        PrintLog.print(self.statusUpdateArr.count, self.surveyArr.count)
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.statusUpdateArr.count-1, section: 0)
            self.questionnaireTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        if self.LastIndexCount == self.surveyArr.count {
            self.yesButton.isHidden = true
            self.noButton.isHidden = true
            self.submitAction.isHidden = false
        }
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
                if self.submitActionVc == SubmitActionVc.emergencyVc.rawValue{
                    self.dismiss(animated: true) {
                        isBpEmergency = true
                        self.postOservations()
                    }
                }else if self.submitActionVc == SubmitActionVc.insightsVc.rawValue{
                    showBpInsights = true
                    self.postOservations()
                    weak var pvc = self.presentingViewController
                     self.dismiss(animated: false) {
                         let minorVc = StoryBoards.homeStoryBoard.instantiateViewController(identifier: "InsightViewController") as InsightViewController
                        minorVc.modalPresentationStyle = .fullScreen
                         minorVc.insightType = InsightType.bp
                        minorVc.bpType = self.bptype
                        minorVc.zoneValue = self.zoneValue
                         pvc?.present(UINavigationController(rootViewController: minorVc), animated: false, completion: nil)
                     }
                }
        
    }
    
    
    func postOservations()  {
        self.bpRedSymptomDelegate?.bpRedSymptomSelected()
        var symNameArr = [[String:Any]]()
        for i in 0..<self.selectedSymptomArr.count {
            PrintLog.print(self.selectedSymptomArr[i])
            let dic = ["symptomName":self.selectedSymptomArr[i],"symptomUrl":self.selectedImagesArr[i]]
            symNameArr.append(dic)
            PrintLog.print(symNameArr)
        }
        let  jsonSymptomBp = self.convertingArrayToString(inputArray: symNameArr)
        PrintLog.print(jsonSymptomBp)
        self.bpRedViewModel.postBpRedObservation(presentBp: "\(bpMngmtSys!)/\(bpMngmtDia!)", bpResult: bpMngmtType!, symptomsBp: jsonSymptomBp, zoneOfPat: bpMngmtZone!, createdAt: bpMngmtCreatedAt!, patientId: patientId, bpMngmntId: bpMngmtId!, success: { (BpObservations, statusCode) in
            PrintLog.print(BpObservations.id!)
            PrintLog.print(statusCode)
            if statusCode == 200{
                if self.submitActionVc == SubmitActionVc.emergencyVc.rawValue {
                    
                }else {
                }
            }else{
                self.showAlert(title: "", message: "Internal Server Error")
            }
            
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

extension BpOrangeQuestionnaireViewContoller:UITableViewDelegate,UITableViewDataSource{
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
        let  surveycell = tableView.dequeueReusableCell(withIdentifier: "BpOrangeQuestionnaireTableCell") as! BpOrangeQuestionnaireTableCell
        let surveyObj = self.statusUpdateArr[indexPath.row ]
        surveycell.questionLabel.text = surveyObj.message ?? ""
        surveycell.yesAnsButton.setTitle(surveyObj.status ?? "", for: .normal)
        return surveycell
    }
    
}

