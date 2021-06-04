//
//  HomeViewController.swift
//  Care365-iPhone
//
//  Created by Apple on 02/04/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var weightButton: UIButton!
    @IBOutlet weak var checkWeightView: UIView!
    @IBOutlet weak var checkBpView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    let homeViewModel = HomeViewModel()
    
    @IBOutlet weak var BpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkWeightView.layer.borderColor = UIColor(red: 0.129, green: 0.588, blue: 0.953, alpha: 1).cgColor
        self.checkBpView.layer.borderColor = UIColor(red: 0.129, green: 0.588, blue: 0.953, alpha: 1).cgColor
        self.BpButton.layer.cornerRadius = self.BpButton.frame.height / 2
        self.weightButton.layer.cornerRadius = self.weightButton.frame.height / 2
        self.getDialysisInfo()
    }
    
    @IBAction func weightInputAction(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
       // let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addTextField { (texField) in
            texField.placeholder = "Enter Weight"
        }
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
            let text = alertController.textFields?.first?.text
            let currentDate = self.postDateAndTime()
            self.homeViewModel.createWeight(weight: text!, weightDeviceId: weightDeviceId, currentDate: currentDate, success: { (response, statusCode) in
                if statusCode == 200{
                    isWeightInputGiven = true
                    DispatchQueue.main.async {
                        self.tabBarController?.selectedIndex = 1
                    }
                }else{
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: "Something went wrong")
                    }
                }
            }, alertController: self)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func bpInputAction(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.addTextField { (texField) in
            texField.placeholder = "Enter Systolic"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Diastolic"
        }
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
            let text1 = alertController.textFields?.first?.text
            let text2 = alertController.textFields?[1].text
            PrintLog.print(text2!)
            let currentDate = self.postDateAndTime()
            self.homeViewModel.createBp(systolic: text1!, diastolic: text2!, bpDeviceId: bpDeviceId,currentDate:"\(currentDate)", success: { (response, statusCode) in
                PrintLog.print(response)
                if statusCode == 200{
                    isBpInputGiven = true
                    DispatchQueue.main.async {
                        self.tabBarController?.selectedIndex = 1
                    }
                }else{
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: "Something went wrong")
                    }
               }
            }, alertController: self)
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    @IBAction func sideMenuAction(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    @IBAction func infoAction(_ sender: Any) {
        guard let vc = StoryBoards.homeStoryBoard.instantiateViewController(identifier: "InformationViewController") as? InformationViewController else {return}
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    func getDialysisInfo()  {
        if Utility.isConnectedToInternet() {
            
            
        }else{
            self.showAlert(title: InternetConnectivity.noInternet, message: InternetConnectivity.internetMessage )
        }
    }

}
