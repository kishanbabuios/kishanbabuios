//
//  LoginViewModel.swift
//  Care365-iPhone
//
//  Created by Apple on 29/03/21.
//

import Foundation
import UIKit

class LoginViewModel {
    func loginAction(userName : String, password : String, deviceId : String, success:@escaping(User,Int)->())  {
         let params  = ["username": userName,
                                    "password": password,
                                    "uid":"flVuSmXNQmq9S34sctUG1o:APA91bGUh0fDK7YvzSvNmFT39Ar5sNFimEqiHMOXT9aiC_jQc-99_VnOFIOg_olAlCyrM9JgIA3h92JaHxsahWs7u4ztxDQE_MgWsF_UM8y6NMph-VXsvc6ML2JDZ7JZZ7ugYR4P-W8e","deviceId":deviceId] as [String:AnyObject]
        APIManager.instance.postDataToServerWithoutHeadersMethod(url:DevelopmentServer.baseUrl+Login.loginUrl, parameters: params) { (response,statusCode)  in
            do{
                let jsonDecoder = JSONDecoder()
                let mainData = try jsonDecoder.decode(User.self, from: response as! Data)
                success(mainData,statusCode)
            }catch let jsonErr {
                PrintLog.print("Error decoding Json Questons", jsonErr)
                //(jsonErr.localizedDescription)
            }
        } failure: { (error) in
        }
    }
    
    func getPatientDetails(success:@escaping(Patient,Int)->())  {
        let url = DevelopmentServer.baseUrl + PatientDetails.patientDetailUrl
        APIManager.instance.getUrlSessionHeaderDetailsFromServerMethod(url: url) { (response, statuscode) in
            PrintLog.print(response,statuscode)
            do{
                let jsonDecoder = JSONDecoder()
                let mainData = try jsonDecoder.decode(Patient.self, from: response as! Data)
                success(mainData,statuscode)
            }catch let jsonErr {
                PrintLog.print("Error decoding Json Questons", jsonErr)
                //(jsonErr.localizedDescription)
            }
            
        } failure: { (error) in
            print(error)
        }


    }
    
    func getDialysisInformationForPatient(success:@escaping(DialysisInformation,Int)->())  {
        let url = DevelopmentServer.baseUrl + PatientDetails.patientDialysisInfoUrl + patientId
        APIManager.instance.getUrlSessionHeaderDetailsFromServerMethod(url: url) { (response, statuscode) in
            PrintLog.print(response,statuscode)
            do{
                let jsonDecoder = JSONDecoder()
                let mainData = try jsonDecoder.decode(DialysisInformation.self, from: response as! Data)
                success(mainData,statuscode)
            }catch let jsonErr {
                PrintLog.print("Error decoding Json Questons", jsonErr)
                //(jsonErr.localizedDescription)
            }
        } failure: { (error) in
            print(error)
        }
    }
}
