//
//  InformationViewController.swift
//  Care365-iPhone
//
//  Created by Apple on 06/04/21.
//

import UIKit

class InformationViewController: UIViewController {
    var infoArray = [String]()
    let infoImageArray = ["lastNextDialysis","postDialysis" , "baselineBp" ,"lastNextDialysis"]
    
    @IBOutlet weak var infoTableView: UITableView!
    
    @IBOutlet weak var infoTitleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.infoTableView.separatorStyle = .singleLine
        self.infoTableView.delegate = self
        self.infoTableView.dataSource = self
        let baseLineBp = "\(systolicBp)/\(diastolicBp)"
        self.infoArray = [lastDialysisDate,postDialysisWeight,baseLineBp,nextDialysisDate]
    }
    
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension InformationViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dialysisStatus {
        case "closed":
            return self.infoArray.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InformationTableCell
        if dialysisStatus == "closed" {
            cell.infoImageView.image = UIImage(named: self.infoImageArray[indexPath.row])
            switch indexPath.row {
            case 0:
                cell.infoLabel.text = "Last Dialysis Date : \(self.infoArray[indexPath.row]) Hrs"
                let textToFind = "Last Dialysis Date :"
                let attrsString =  NSMutableAttributedString(string:cell.infoLabel.text!);
                // search for word occurrence
                let range = (cell.infoLabel.text! as NSString).range(of: textToFind)
                if (range.length > 0) {
                    attrsString.addAttributes([NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Bold", size: 14.0)!], range: range)
                }
                cell.infoLabel.attributedText = attrsString
            case 1:
                cell.infoLabel.text = "Post Dialysis Weight : \(self.infoArray[indexPath.row]) (PST \(lastDialysisDate) Hrs)"
                let textToFind = "Post Dialysis Weight :"
                let attrsString =  NSMutableAttributedString(string:cell.infoLabel.text!);
                // search for word occurrence
                let range = (cell.infoLabel.text! as NSString).range(of: textToFind)
                if (range.length > 0) {
                    attrsString.addAttributes([NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Bold", size: 14.0)!], range: range)
                }
                cell.infoLabel.attributedText = attrsString
            case 2:
                cell.infoLabel.text = "Baseline Blood Pressure : \(self.infoArray[indexPath.row]) mmHg"
                let textToFind = "Baseline Blood Pressure :"
                let attrsString =  NSMutableAttributedString(string:cell.infoLabel.text!);
                // search for word occurrence
                let range = (cell.infoLabel.text! as NSString).range(of: textToFind)
                if (range.length > 0) {
                    attrsString.addAttributes([NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Bold", size: 14.0)!], range: range)
                }
                cell.infoLabel.attributedText = attrsString
            default:
                cell.infoLabel.text = "Next dialysis date : \(self.infoArray[indexPath.row]) Hrs"
                let textToFind = "Next dialysis date :"
                let attrsString =  NSMutableAttributedString(string:cell.infoLabel.text!);
                // search for word occurrence
                let range = (cell.infoLabel.text! as NSString).range(of: textToFind)
                if (range.length > 0) {
                    attrsString.addAttributes([NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Bold", size: 14.0)!], range: range)
                }
                cell.infoLabel.attributedText = attrsString
            }
        }else{
            cell.infoLabel.text = "Records not updated"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dialysisStatus {
        case "closed":
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
}
