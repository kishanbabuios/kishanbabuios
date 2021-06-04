//
//  PostWeightObservations.swift
//  Care365-iPhone
//
//  Created by Apple on 18/05/21.
//

import Foundation
class WeightObservationViewModel{
    func postWeightObservation(presentWt:String, wtGained : String, upperPermittedWtGain : String, lowerPermittedWtGain:String,zoneOfPat:Int,createdAt:String,patientId:String,wtMngmntId:String,timepostdialysis:String,symptomsWt:String,dryweight:String, success:@escaping(WeightObservations,Int)->(),alertController : UIViewController)  {
        let params  = ["presentWt": presentWt,"wtResult":wtGained,"permittedWeighthgr":upperPermittedWtGain,"permittedWeightlwr":lowerPermittedWtGain,"zoneOfPat":zoneOfPat,"createdAt":createdAt,"patientId":patientId,"status":"1","readingId":wtMngmntId,"timepostdialysis":timepostdialysis,"symptomsWt":symptomsWt,"dryweight":dryweight,"patientRequested":nil,"called_911":"1","symptom":"NA"] as [String:AnyObject]
        PrintLog.print(params)
        APIManager.instance.postDataToServerHeadersMethod(url:DevelopmentServer.baseUrl+PostObservations.postWeightObser+"wtmgntId=\(wtMngmntId)&wtzone=\(zoneOfPat)&called_911=1&symptom=NA", parameters: params) { (response,statusCode)  in
            do{
                let jsonDecoder = JSONDecoder()
                let mainData = try jsonDecoder.decode(WeightObservations.self, from: response as! Data)
                success(mainData,statusCode)
            }catch let jsonErr {
                PrintLog.print("Error decoding Json Questons", jsonErr)
                //(jsonErr.localizedDescription)
            }
        } failure: { (error) in
            DispatchQueue.main.async {
                alertController.showAlert(title: "", message: error.description)
            }
        }
    }
}
