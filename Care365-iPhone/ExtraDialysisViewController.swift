//
//  ExtraDialysisViewController.swift
//  Care365-iPhone
//
//  Created by Apple on 03/05/21.
//

import UIKit
import Alamofire
class ExtraDialysisViewController: UIViewController {

    @IBOutlet weak var extraDialysisQueView: UIView!
    @IBOutlet weak var extraDialysisQueLabel: UILabel!
    @IBOutlet weak var chatProfileImage: UIImageView!
    @IBOutlet weak var extraDiaYesOrNoButton: UIButton!
    @IBOutlet weak var caregiverView: UIView!
    @IBOutlet weak var careGiverQuestionView: UIView!
    @IBOutlet weak var actionableInsightsButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    var insightType = ""
    var zoneValue = 0
    let extraDiaViewModel = ExtraDialysisViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    

    @IBAction func yesOrNoAction(_ sender: UIButton) {
        PrintLog.print(sender.titleLabel?.text! as Any)
        self.extraDiaYesOrNoButton.isHidden = false
        if sender.titleLabel?.text == "No" {
            self.extraDiaYesOrNoButton.titleLabel?.text = "No"
        }else{
            self.extraDiaYesOrNoButton.titleLabel?.text = "Yes"
        }
        
        self.extraDiaYesOrNoButton.titleLabel?.text = sender.titleLabel?.text!
        self.chatProfileImage.isHidden = false
        self.caregiverView.isHidden = false
        self.actionableInsightsButton.isHidden = false
        self.yesButton.isHidden = true
        self.noButton.isHidden = true
        let currentDate = self.postDateAndTime()
        var patientReques = ""
        var extraStatus = ""
        
        if sender.titleLabel?.text == "Yes" {
            patientReques = "YES"
            extraStatus = "0"
        }else{
            patientReques = "No"
            extraStatus = "2"
        }
        if Utility.isConnectedToInternet(){
            self.extraDiaViewModel.postBpRedObservation(appointmentRequestDate: currentDate, patientRequested: patientReques, weightMngmtId: wtMngmtId!, patientId: patientId, status: extraStatus, success: { (extraDiaResponse, statusCode) in
                if statusCode == 200{
                    PrintLog.print(extraDiaResponse.patientRequested ?? "")
                }else if statusCode == 401{
                    PrintLog.print("Token Expired")
                }
            }, alertController: self)
        }else{
            self.showAlert(title: InternetConnectivity.noInternet, message: InternetConnectivity.internetMessage )
        }
        
    }
    
    @IBAction func moveToInsights(_ sender: UIButton) {
        weak var pvc = self.presentingViewController
        self.dismiss(animated: true) {
            let minorVc = StoryBoards.homeStoryBoard.instantiateViewController(identifier: "InsightViewController") as InsightViewController
            minorVc.insightType = InsightType.weight
           minorVc.zoneValue = self.zoneValue
            pvc?.modalPresentationStyle = .overFullScreen
            pvc?.present(UINavigationController(rootViewController: minorVc), animated: false, completion: nil)
        }
        
    }
   
    func initialSetup() {
        self.navigationController?.isNavigationBarHidden = true
        self.extraDiaYesOrNoButton.isHidden = true
        self.chatProfileImage.isHidden = true
        self.caregiverView.isHidden = true
        self.actionableInsightsButton.isHidden = true
        self.yesButton.isHidden = false
        self.yesButton.isHidden = false
        self.viewAlignment(queView: extraDialysisQueView)
        self.viewAlignment(queView: careGiverQuestionView)
    }
    
    
    func viewAlignment(queView:UIView)  {
        let rectShape = CAShapeLayer()
        rectShape.bounds = queView.frame
        rectShape.position = queView.center
        rectShape.path = UIBezierPath(roundedRect: queView.bounds, byRoundingCorners: [ .bottomLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
       queView.layer.backgroundColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0).cgColor
        queView.layer.mask = rectShape
    }
}
