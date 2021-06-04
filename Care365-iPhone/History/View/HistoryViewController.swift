//
//  HistoryViewController.swift
//  Care365-iPhone
//
//  Created by Apple on 30/03/21.
//

import UIKit
import Foundation
import SideMenuSwift
import Alamofire
class HistoryViewController: UIViewController {

    @IBOutlet weak var segmentedViewControl: UISegmentedControl!
    @IBOutlet weak var vitalLabel: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    let historyViewModel = HistoryViewModel()
    var weightStatusArray = [String]()
    var weightArray = [String]()
    var weightCreatedArray = [String]()
    var bpStatusArray = [String]()
    var bPCreatedArray = [String]()
    var bpSysArray = [String]()
    var bpDiaArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.historyTableView.delegate = self
        self.historyTableView.dataSource = self
        self.vitalLabel.text = "Vitals Data - Weight"
       // self.getPatientWeightAndBpHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getPatientWeightAndBpHistory()
    }
    func getPatientWeightAndBpHistory()  {
        if Utility.isConnectedToInternet() {
            self.showIndicator()
            historyViewModel.getPatientWeightHistory() { (response, statusCode) in
                PrintLog.print(response,statusCode)
                if statusCode == 200{
                    for i in 0..<response.count{
                        
                        let weight =   response[i].weight
                        if let status =    response[i].zoneofpatient {
                            self.weightStatusArray.append(status)
                        }else{
                            self.weightStatusArray.append("")
                        }
                        if let createdDate =  response[i].createdAt {
                           let formatedDate = self.responseDateFormatter(dateString: createdDate)
                            self.weightCreatedArray.append(formatedDate)
                        }else{
                            self.weightCreatedArray.append("")
                        }
                        if let weight = weight {
                            self.weightArray.append(weight)
                        }else{
                            self.weightArray.append(" ")
                        }
                        
                    }
                    
                    self.historyViewModel.getPatientBpHistory { (response, statusCode) in
                        DispatchQueue.main.async {
                            self.hideIndicator()
                        }
                        if statusCode == 200{
                            for i in 0..<response.count {
                                let sys = response[i].sys
                                let dia = response[i].dia
                                if let createdDate =  response[i].created_at {
                                    let formatedDate = self.responseDateFormatter(dateString: createdDate)
                                    self.bPCreatedArray.append(formatedDate)
                                }else{
                                    self.bPCreatedArray.append("")
                                }
                                if let status = response[i].zoneofpatient {
                                    self.bpStatusArray.append(status)
                                }else{
                                    self.bpStatusArray.append("")
                                }
                                self.bpSysArray.append(sys ?? "")
                                self.bpDiaArray.append(dia ?? "")
                            }
                            DispatchQueue.main.async {
                                self.historyTableView.reloadData()
                            }
                        }else if statusCode == 401{
                            print("token expired")
                        }
                    }
                    
                }else if statusCode == 401{
                    print("token expired")
                }
                
            }
        }else{
            self.showAlert(title: InternetConnectivity.noInternet, message: InternetConnectivity.internetMessage )
        }
    }
    @IBAction func weightAndBpSegmentAction(_ sender: Any) {
        switch segmentedViewControl.selectedSegmentIndex {
        case 0:
            segmentedViewControl.setImage(CRImages.WeightWhiteIcon, forSegmentAt: 0)
            segmentedViewControl.setImage(CRImages.BpBlueIcon, forSegmentAt: 1)
            UISegmentedControl.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .normal)
            self.vitalLabel.text = "Vitals Data - Weight"
            self.historyTableView.reloadData()
        case 1:
            segmentedViewControl.setImage(CRImages.WeightBlueIcon, forSegmentAt: 0)
            segmentedViewControl.setImage(CRImages.BpWhiteIcon, forSegmentAt: 1)
            UISegmentedControl.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .normal)
            self.vitalLabel.text = "Vitals Data - Blood Pressure"
            self.historyTableView.reloadData()
        default:
            break
        }
    }
    @IBAction func menuAction(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    @IBAction func getInfoAction(_ sender: UIButton) {
        guard let vc = StoryBoards.homeStoryBoard.instantiateViewController(identifier: "InformationViewController") as? InformationViewController else {return}
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}

extension HistoryViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.segmentedViewControl.selectedSegmentIndex {
        case 0:
            return weightStatusArray.count
        case 1:
            return bpStatusArray.count
        default:
            break
        }
        return weightStatusArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.historyTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableCell
        if self.segmentedViewControl.selectedSegmentIndex == 0 {
            cell.systolicLabel.isHidden = true
            cell.diastolicLabel.text = "Body Weight: \(weightArray[indexPath.row]) kg"
            cell.recordedLabel.text = "Recorded on: \(self.weightCreatedArray[indexPath.row]) Hrs"
            switch weightStatusArray[indexPath.row] {
            case "1":
                cell.statusLabel.text = "Status: High Alert"
                let textToFind = "High Alert"
                let attrsString =  NSMutableAttributedString(string:cell.statusLabel.text!);
                // search for word occurrence
                let range = (cell.statusLabel.text! as NSString).range(of: textToFind)
                if (range.length > 0) {
                    attrsString.addAttribute(NSAttributedString.Key.foregroundColor,value:UIColor.red,range:range)
                }
                cell.statusLabel.attributedText = attrsString
            case "2":
                cell.statusLabel.text = "Status: Alert"
                let textToFind = "Alert"
                let attrsString =  NSMutableAttributedString(string:cell.statusLabel.text!);
                // search for word occurrence
                let range = (cell.statusLabel.text! as NSString).range(of: textToFind)
                if (range.length > 0) {
                    attrsString.addAttribute(NSAttributedString.Key.foregroundColor,value:UIColor.orange,range:range)
                }
                cell.statusLabel.attributedText = attrsString
            case "3":
                cell.statusLabel.text = "Status: Normal"
                let textToFind = "Normal"
                let attrsString =  NSMutableAttributedString(string:cell.statusLabel.text!);
                // search for word occurrence
                let range = (cell.statusLabel.text! as NSString).range(of: textToFind)
                if (range.length > 0) {
                    attrsString.addAttribute(NSAttributedString.Key.foregroundColor,value:Colors.WeightObservationGreenColor,range:range)
                }
                cell.statusLabel.attributedText = attrsString
            default:
                cell.statusLabel.text = "Status: Non-Adherence"
                let textToFind = "Non-Adherence"
                let attrsString =  NSMutableAttributedString(string:cell.statusLabel.text!);
                // search for word occurrence
                let range = (cell.statusLabel.text! as NSString).range(of: textToFind)
                if (range.length > 0) {
                    attrsString.addAttribute(NSAttributedString.Key.foregroundColor,value:UIColor.gray,range:range)
                }
                cell.statusLabel.attributedText = attrsString

            }
        }else{
            cell.systolicLabel.isHidden = false
            cell.recordedLabel.text = "Recorded on: \(self.bPCreatedArray[indexPath.row]) Hrs"
            cell.systolicLabel.text = "Systolic: \(self.bpSysArray[indexPath.row]) mmHg"
            cell.diastolicLabel.text = "Diastolic: \(self.bpDiaArray[indexPath.row]) mmHg"
            switch self.bpStatusArray[indexPath.row] {
            case "1":
                cell.statusLabel.text = "Status: High Alert"
                let textToFind = "High Alert"
                let attrsString =  NSMutableAttributedString(string:cell.statusLabel.text!);
                // search for word occurrence
                let range = (cell.statusLabel.text! as NSString).range(of: textToFind)
                if (range.length > 0) {
                    attrsString.addAttribute(NSAttributedString.Key.foregroundColor,value:UIColor.red,range:range)
                }
                cell.statusLabel.attributedText = attrsString
            case "2":
                cell.statusLabel.text = "Status: Alert"
                let textToFind = "Alert"
                let attrsString =  NSMutableAttributedString(string:cell.statusLabel.text!);
                // search for word occurrence
                let range = (cell.statusLabel.text! as NSString).range(of: textToFind)
                if (range.length > 0) {
                    attrsString.addAttribute(NSAttributedString.Key.foregroundColor,value:UIColor.orange,range:range)
                }
                cell.statusLabel.attributedText = attrsString
            case "3":
                cell.statusLabel.text = "Status: Normal"
                let textToFind = "Normal"
                let attrsString =  NSMutableAttributedString(string:cell.statusLabel.text!);
                // search for word occurrence
                let range = (cell.statusLabel.text! as NSString).range(of: textToFind)
                if (range.length > 0) {
                    attrsString.addAttribute(NSAttributedString.Key.foregroundColor,value:Colors.WeightObservationGreenColor,range:range)
                }
                cell.statusLabel.attributedText = attrsString
            default:
                cell.statusLabel.text = "Status: Non-Adherence"
                let textToFind = "Non-Adherence"
                let attrsString =  NSMutableAttributedString(string:cell.statusLabel.text!);
                // search for word occurrence
                let range = (cell.statusLabel.text! as NSString).range(of: textToFind)
                if (range.length > 0) {
                    attrsString.addAttribute(NSAttributedString.Key.foregroundColor,value:UIColor.gray,range:range)
                }
                cell.statusLabel.attributedText = attrsString
            }
        }
   
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 144
    }
}
