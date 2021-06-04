//
//  HomeViewModel.swift
//  Care365-iPhone
//
//  Created by Apple on 06/04/21.
//

import Foundation
import UIKit

class HomeViewModel {
    func createBp(systolic : String, diastolic : String, bpDeviceId : String,currentDate:String, success:@escaping(CreateBp,Int)->(),alertController : UIViewController)  {
        let params  = ["created_at":currentDate,"devid":bpDeviceId,"sys":systolic,"dia":diastolic] as [String:AnyObject]
        APIManager.instance.postDataToServerHeadersMethod(url:DevelopmentServer.baseUrl+CreateBpAndWeight.createBpUrl, parameters: params) { (response,statusCode)  in
            do{
                let jsonDecoder = JSONDecoder()
                let mainData = try jsonDecoder.decode(CreateBp.self, from: response as! Data)
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
    
    func createWeight(weight : String, weightDeviceId : String,currentDate:String, success:@escaping(CreateWeight,Int)->(),alertController : UIViewController)  {
        let params  = ["createdAt":currentDate,"deviceId":weightDeviceId,"weight":weight] as [String:AnyObject]
        PrintLog.print(weightDeviceId)
        APIManager.instance.postDataToServerHeadersMethod(url:DevelopmentServer.baseUrl+CreateBpAndWeight.createWeightUrl, parameters: params) { (response,statusCode)  in
            do{
                let jsonDecoder = JSONDecoder()
                let mainData = try jsonDecoder.decode(CreateWeight.self, from: response as! Data)
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
