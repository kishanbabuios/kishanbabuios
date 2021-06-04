//
//  WeightMajorQuestionnaireVcViewController.swift
//  Care365-iPhone
//
//  Created by Apple on 18/05/21.
//

import UIKit
protocol WeightRedSymptomDelegate : AnyObject{
    func WeightRedSymptomDelegate()
}
class WeightMajorQuestionnaireVc: UIViewController {
/* @IBOutlet weak var questionView: UIView!
     @IBOutlet weak var questionLabel: UILabel!
     @IBOutlet weak var questionnaireCollectionView: UICollectionView!
     @IBOutlet weak var submitButton: UIButton!*/
    let wtObsViewModel = WeightObservationViewModel()
    weak var weightRedSymptomDelegate : WeightRedSymptomDelegate?
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionnaireCollectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!
    var zoneValue : Int?
    var optionArray = [Options]()
    var symptomArray = [String]()
    var imageArray = [String]()
    var flowLayout = FlowLayout()
    var syptomType : String?
    var indexPoint : Int?
    var triggerArray = [String]()
    var resultTriggerArray = [String]()
    var showArray = [String]()
    var resultShowArray = [String]()
    var valueArray = [String]()
    var symptom = [Symptom]()
    var symptomNameArray = [String]()
    var resultSymptomNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indexPoint = 0
        self.initialSetup()
    }
    

    func initialSetup()  {
        self.navigationController?.isNavigationBarHidden = true
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.questionView.frame
        rectShape.position = self.questionView.center
        rectShape.path = UIBezierPath(roundedRect: self.questionView.bounds, byRoundingCorners: [ .bottomLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        self.questionView.layer.backgroundColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0).cgColor
        self.questionView.layer.mask = rectShape
        self.submitButton.isEnabled = false
        self.submitButton.backgroundColor = .gray
        self.questionnaireCollectionView.allowsMultipleSelection = false
        self.questionnaireCollectionView.isMultipleTouchEnabled = false
    
            let url = Bundle.main.url(forResource: "Questionnaire", withExtension: "json")!
            do{
                let jsonData = try Data(contentsOf: url) as  Any
                let mainData = try JSONDecoder().decode(Symptom.self, from: jsonData as! Data)
                if self.zoneValue == 2 {
                    guard let secArr = mainData.weight?.orange?.survey?[self.indexPoint!].options else { return }
                    self.optionArray = secArr
                    guard let type = mainData.weight?.orange?.survey?[self.indexPoint!].type else { return  }
                    self.syptomType = type
                }else if self.zoneValue == 1{
                    guard let secArr = mainData.weight?.red?.survey?[self.indexPoint!].options  else { return }
                    self.optionArray = secArr
                    guard let type = mainData.weight?.red?.survey?[self.indexPoint!].type else { return  }
                    self.syptomType = type
                }
            }
                catch {
                print(error.localizedDescription)
            }
            
            PrintLog.print(self.optionArray)
      
        
        self.questionnaireCollectionView.delegate = self
        self.questionnaireCollectionView.dataSource = self
        flowLayout.alignment = .center
                flowLayout.estimatedItemSize = CGSize(width: 160, height: 50)
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        self.questionnaireCollectionView.collectionViewLayout = flowLayout
        if self.syptomType == "multiSelection" {
            self.questionnaireCollectionView.allowsMultipleSelection = true
        }else{
            self.questionnaireCollectionView.allowsMultipleSelection = false
        }
    }

    @IBAction func SubmitAction(_ sender: UIButton) {
        if resultTriggerArray.contains("nil") {
            if resultShowArray.contains("alert") {
                isWeightEmergency = true
                PrintLog.print("Emergency")
                self.postOservations()
                self.dismiss(animated: true, completion: nil)
            }else{
                showWeightInsights = true
                self.postOservations()
                weak var pvc = self.presentingViewController
                if isExtraDialysis! {
                    self.dismiss(animated: false) {
                        let minorVc = StoryBoards.homeStoryBoard.instantiateViewController(identifier: "ExtraDialysisViewController") as ExtraDialysisViewController
                       let nc = UINavigationController(rootViewController: minorVc)
                       nc.modalPresentationStyle = .fullScreen
                        minorVc.insightType = InsightType.weight
                        minorVc.zoneValue = self.zoneValue!
                        pvc?.present(nc, animated: false, completion: nil)
                    }}else{
                        self.dismiss(animated: false) {
                            let minorVc = StoryBoards.homeStoryBoard.instantiateViewController(identifier: "InsightViewController") as InsightViewController
                            minorVc.insightType = InsightType.weight
                           minorVc.zoneValue = self.zoneValue!
                           let nc = UINavigationController(rootViewController: minorVc)
                           nc.modalPresentationStyle = .fullScreen
                            pvc?.present(nc, animated: false, completion: nil)
                        }
                    }
            }
        }else{
            self.imageArray.removeAll()
            self.resultSymptomNameArray.removeAll()
            self.symptomNameArray.removeAll()
            self.resultTriggerArray.removeAll()
            self.resultShowArray.removeAll()
            self.indexPoint = indexPoint! + 1
            self.symptomArray.removeAll()
            self.triggerArray.removeAll()
            self.showArray.removeAll()
            self.symptom.removeAll()
            self.optionArray.removeAll()
            PrintLog.print(symptom)
            PrintLog.print(optionArray)
            weak var pvc = self.presentingViewController
             self.dismiss(animated: false) {
                 let minorVc = StoryBoards.homeStoryBoard.instantiateViewController(identifier: "QuestionaaireViewController") as! QuestionaaireViewController
                minorVc.zoneValue = self.zoneValue!
                let nc = UINavigationController(rootViewController: minorVc)
                nc.modalPresentationStyle = .fullScreen
                pvc?.present(nc, animated: true, completion: nil)
             }
        }
        
    }
    func postOservations()  {
        self.weightRedSymptomDelegate?.WeightRedSymptomDelegate()
        var symNameArr = [[String:Any]]()
        for i in 0..<self.resultSymptomNameArray.count {
           wtMngmtSymptomType = self.resultSymptomNameArray[i]
            PrintLog.print(self.resultSymptomNameArray[i])
            if self.resultSymptomNameArray[i] == "None of the above"{
                if self.resultSymptomNameArray.count == 1 {
                    symNameArr.append(["":""])
                }
            }else{
                let dic = ["symptomName":self.resultSymptomNameArray[i],"symptomUrl":self.imageArray[i]]
                symNameArr.append(dic)
                PrintLog.print(symNameArr)
            }
        }
      let  jsonSymptomWt = self.convertingArrayToString(inputArray: symNameArr)
        PrintLog.print(jsonSymptomWt)
        self.wtObsViewModel.postWeightObservation(presentWt: wtMngmtCurrentWeight!, wtGained: String(weightGainedDefaults), upperPermittedWtGain: upperPermWtGain!, lowerPermittedWtGain: lowerPermWtGain!, zoneOfPat: self.zoneValue!, createdAt: wtMngmtCreatedAt!, patientId: patientId, wtMngmntId: wtMngmtId!, timepostdialysis: timeLastDial, symptomsWt: jsonSymptomWt, dryweight: dryWeight, success: { (WeightObservations, statusCode) in
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
}

extension WeightMajorQuestionnaireVc: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.optionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeightMajorQuestionnaireCell", for: indexPath) as! WeightMajorQuestionnaireCell
        cell.backgroundColor = .systemBackground
        cell.symptomLabel.textColor = .black
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = Colors.symptomCellLayerColor.cgColor
        cell.symptomLabel.text = optionArray[indexPath.item].label
        PrintLog.print(optionArray[indexPath.item].label!)
        self.symptomNameArray.append(optionArray[indexPath.item].label!)
        self.symptomArray.append(optionArray[indexPath.item].imgUrl!)
        self.triggerArray.append(optionArray[indexPath.item].trigger!)
        self.showArray.append(optionArray[indexPath.item].show!)
       // self.valueArray.append(optionArray[indexPath.item].value!)
        
        PrintLog.print(self.symptomArray, self.triggerArray, self.showArray)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderColor = Colors.symptomCellLayerColor.cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 10
            cell.backgroundColor = Colors.symptomCellLayerColor
            self.resultSymptomNameArray.append(self.symptomNameArray[indexPath.item])
            self.imageArray.append(self.symptomArray[indexPath.item])
            self.resultTriggerArray.append(self.triggerArray[indexPath.item])
            self.resultShowArray.append(self.showArray [indexPath.item])
        } else {return}
        if imageArray.count == 0  {
            self.submitButton.isEnabled = false
            self.submitButton.backgroundColor = .gray
        }else{
            self.submitButton.isEnabled = true
            self.submitButton.backgroundColor = Colors.ActionButtonColor
        }
        PrintLog.print(self.resultTriggerArray , self.imageArray ,  self.resultShowArray)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = .systemBackground
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 10
            cell.layer.borderColor = Colors.symptomCellLayerColor.cgColor
            if resultSymptomNameArray.contains(symptomNameArray [indexPath.item]) {
                resultSymptomNameArray.remove(at: resultSymptomNameArray.firstIndex(of: symptomNameArray[indexPath.row])!)
            }
            if imageArray.contains(symptomArray[indexPath.item]) {
                imageArray.remove(at: imageArray.firstIndex(of: symptomArray[indexPath.row])!)
            }
            if resultTriggerArray.contains(triggerArray[indexPath.item]) {
                resultTriggerArray.remove(at: resultTriggerArray.firstIndex(of: triggerArray[indexPath.row])!)
            }
            if resultShowArray.contains(showArray [indexPath.item]) {
                resultShowArray.remove(at: resultShowArray.firstIndex(of: showArray[indexPath.row])!)
            }
        } else {return}
        if imageArray.count == 0 {
            self.submitButton.isEnabled = false
            self.submitButton.backgroundColor = .gray
        }else{
            self.submitButton.isEnabled = true
            self.submitButton.backgroundColor = Colors.ActionButtonColor
        }
        PrintLog.print(self.resultTriggerArray , self.imageArray, self.resultShowArray)
    }
    
    
   
}
