//
//  HistoryModelController.swift
//  Care365-iPhone
//
//  Created by Apple on 30/03/21.
//

import Foundation
import UIKit

class HistoryViewModel  {
    func getPatientWeightHistory(success:@escaping([WeightHistoryModel],Int)->())  {
        PrintLog.print(patientId)
        let url = DevelopmentServer.baseUrl + PatientHistory.weightHistory + patientId
        APIManager.instance.getUrlSessionHeaderDetailsFromServerMethod(url: url) { (response, statuscode) in
            PrintLog.print(response,statuscode)
            do{
                let jsonDecoder = JSONDecoder()
                let mainData = try jsonDecoder.decode([WeightHistoryModel].self, from: response as! Data)
                PrintLog.print(mainData)
                success(mainData,statuscode)
            }catch let jsonErr {
                PrintLog.print("Error decoding Json Questons", jsonErr)
                //(jsonErr.localizedDescription)
            }
        } failure: { (error) in
            print(error)
        }
    }
    
    func getPatientBpHistory( success:@escaping([BpHistoryModel],Int)->())  {
        let url = DevelopmentServer.baseUrl + PatientHistory.bloodPressHistory + patientId
        APIManager.instance.getUrlSessionHeaderDetailsFromServerMethod(url: url) { (response, statuscode) in
            PrintLog.print(response,statuscode)
            do{
                let jsonDecoder = JSONDecoder()
                let mainData = try jsonDecoder.decode([BpHistoryModel].self, from: response as! Data)
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
