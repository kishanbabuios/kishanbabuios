//
//  ExtraDialysisViewModel.swift
//  Care365-iPhone
//
//  Created by Apple on 02/06/21.
//

import Foundation
class ExtraDialysisViewModel{
    func postBpRedObservation(appointmentRequestDate : String, patientRequested : String, weightMngmtId : String,patientId:String,status:String, success:@escaping(ExtraDialysisModel,Int)->(),alertController : UIViewController)  {
        let params  = ["appointmentRequestDate":appointmentRequestDate,"patientRequested":patientRequested,"observationId":weightMngmtId,"patientId":patientId,"status":status] as [String:AnyObject]
        APIManager.instance.postDataToServerHeadersMethod(url:DevelopmentServer.baseUrl + ExtraDialysis.postExtraDialysisUrl, parameters: params) { (response,statusCode)  in
            do{
                let jsonDecoder = JSONDecoder()
                let mainData = try jsonDecoder.decode(ExtraDialysisModel.self, from: response as! Data)
                success(mainData,statusCode)
            }catch let jsonErr {
                PrintLog.print("Error decoding Json Questons", jsonErr)
            }
        } failure: { (error) in
            DispatchQueue.main.async {
                alertController.showAlert(title: "", message: error.description)
            }
        }
    }
}
