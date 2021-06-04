//
//  LoginViewController.swift
//  Care365-iPhone
//
//  Created by Apple on 29/03/21.
//

import UIKit
import Alamofire
import SideMenuSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var showAndHideButton: UIButton!
    var isShown : Bool?
    let loginViewModel = LoginViewModel()
    var patientArray = [Patient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //self.emailTextField.text = "aswcare365@gmail.com"
        self.emailTextField.text = "ramcare365@gmail.com"
        self.passwordTextField.text = "Test@123#"
        self.emailErrorLabel.text = ""
        self.passwordErrorLabel.text = ""
        self.isShown = false
        self.showAndHideButton.setImage(UIImage(named: "show"), for: .normal)
    }
    
    @IBAction func showAndHideAction(_ sender: Any) {
        if isShown == false {
            self.showAndHideButton.setImage(UIImage(named: "hide"), for: .normal)
            self.passwordTextField.isSecureTextEntry = false
            isShown = true
        }else{
            self.showAndHideButton.setImage(UIImage(named: "show"), for: .normal)
            self.passwordTextField.isSecureTextEntry = true
            isShown = false
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        guard let name = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        if name.isValidEmail() {
                if Utility.isConnectedToInternet(){
                        self.showIndicator()
                    self.loginViewModel.loginAction(userName: name, password: password, deviceId: Login.deviceId!, success: { (response, statusCode) in
                        PrintLog.print(response,statusCode)
                        if statusCode == 200{
                            let token  = response.jwtToken
                            usrDefaults.setValue(token,forKey:"JwtToken")
                            jwtToken = usrDefaults.string(forKey: "JwtToken") ?? ""
                            PrintLog.print(jwtToken)
                            // getting patient details
                            self.loginViewModel.getPatientDetails { (response,statusCode) in
                                if statusCode == 200{
                                    //self.patientArray = [response]
                                    PrintLog.print(response.id!)
                                  
                                    usrDefaults.setValue(response.wtDeviceId, forKey: "weightDeviceId")
                                     weightDeviceId = usrDefaults.string(forKey: "weightDeviceId") ?? ""
                                   
                                    usrDefaults.setValue(response.bpDeviceId, forKey: "bpDeviceId")
                                    bpDeviceId = usrDefaults.string(forKey: "bpDeviceId") ?? ""
                                    
                                    usrDefaults.setValue(response.dryWeight, forKey: "dryWeight")
                                    dryWeight = usrDefaults.value(forKey: "dryWeight") as! String
                                   // usrDefaults.setValue(response.weight, forKey: "weight")
                                    usrDefaults.setValue(response.duration, forKey: "duration")
                                    interDialstolicPeriod = usrDefaults.value(forKey: "duration") as! String
                                    
                                    guard let sysBp = response.systolicBloodPressure else { return }
                                    usrDefaults.setValue(sysBp, forKey: "systolicBloodPressure")
                                    systolicBp = usrDefaults.value(forKey: "systolicBloodPressure") as! String
                                    guard let diasBp = response.diastolicBloodPressure else { return }
                                    usrDefaults.setValue(diasBp, forKey: "diastolicBloodPressure")
                                    diastolicBp = usrDefaults.value(forKey: "diastolicBloodPressure") as! String
                                    PrintLog.print(patientId)
                                   usrDefaults.setValue(response.id, forKey: "PatientId")
                                    patientId = usrDefaults.string(forKey: "PatientId") ?? ""
                                    PrintLog.print(patientId)
                                    //getting dialysis informaion
                                    self.loginViewModel.getDialysisInformationForPatient { (infoResponse, statusCode) in
                                       
                                            self.hideIndicator()
                                        
                                        if statusCode == 200{
                                            guard let status = infoResponse.status else { return  }
                                            if status == "closed" {
                                                usrDefaults.setValue(infoResponse.status, forKey: "status")
                                                usrDefaults.setValue(infoResponse.post_wt, forKey: "post_wt")
                                                guard let lastDate = infoResponse.last_dialysis_date else { return  }
                                                let lastDiadate = self.responseDateFormatter(dateString: lastDate)
                                                usrDefaults.setValue(lastDiadate, forKey: "last_dialysis_date")
                                                guard let nextDate = infoResponse.next_dialysis_date else { return  }
                                                let nextDiadate = self.responseDateFormatter(dateString: nextDate)
                                                usrDefaults.setValue(nextDiadate, forKey: "next_dialysis_date")
                                            }
                                            //assigning menu view controller
                                            DispatchQueue.main.async {
                                                let contentViewController = StoryBoards.homeStoryBoard.instantiateViewController(withIdentifier: "menuNavigationController")
                                                let menuViewController = StoryBoards.homeStoryBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
                                                menuViewController.patientInstance = response
                                                let sidemenu = SideMenuController(contentViewController: contentViewController,menuViewController: menuViewController)
                                                SideMenuController.preferences.basic.menuWidth = self.view.frame.width - 60
                                                SideMenuController.preferences.basic.position = .above
                                                SideMenuController.preferences.basic.direction = .left
                                                SideMenuController.preferences.basic.enablePanGesture = true
                                                SideMenuController.preferences.basic.supportedOrientations = .portrait
                                                SideMenuController.preferences.basic.shouldRespectLanguageDirection = true
                                                self.navigationController?.pushViewController(sidemenu, animated: true)
                                            }
                                        }else if statusCode == 401{
                                            PrintLog.print("error")
                                        }
                                    }
                                    
                                }else if statusCode == 404 || statusCode == 401{
                                    PrintLog.print("errror")
                                }
                            }
                            
                        }
                        else if statusCode == 404 || statusCode == 401{
                            self.hideIndicator()
                            DispatchQueue.main.async {
                                
                                self.showAlert(title: "", message: "Invalid Credentials")
                            }
                        }else if statusCode == 503{
                            self.hideIndicator()
                            DispatchQueue.main.async {
                                self.showAlert(title: "Internal Server Issue", message: "Please try after sometime")
                            }
                        }
                    })
                }else{
                    self.showAlert(title: InternetConnectivity.noInternet, message: InternetConnectivity.internetMessage )
                }
        }else{
            self.showAlert(title: "", message: "Please Enter Valid Email")
        }
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
    }
}

extension LoginViewController : UITextFieldDelegate{
    
}
