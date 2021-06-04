//
//  PostBpRedObservationViewModel.swift
//  Care365-iPhone
//
//  Created by Apple on 06/05/21.
//

import Foundation

class BpRedObservationViewModel{
    func postBpRedObservation(presentBp : String, bpResult : String, symptomsBp : String,zoneOfPat:Int,createdAt:String,patientId:String,bpMngmntId:String, success:@escaping(BpObservations,Int)->(),alertController : UIViewController)  {
        let params  = ["presentBp":presentBp,"bpResult":bpResult,"symptomsBp":symptomsBp,"zoneOfPat":zoneOfPat,"createdAt":createdAt,"patientId":patientId,"status":"1","readingId":bpMngmntId,"called_911":"1","symptom":"NA"] as [String:AnyObject]
        APIManager.instance.postDataToServerHeadersMethod(url:DevelopmentServer.baseUrl+PostObservations.postBpObser+"bpmgntId=\(bpMngmntId)&bpzone=\(zoneOfPat)&called_911=1&symptom=NA", parameters: params) { (response,statusCode)  in
            do{
                let jsonDecoder = JSONDecoder()
                let mainData = try jsonDecoder.decode(BpObservations.self, from: response as! Data)
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
