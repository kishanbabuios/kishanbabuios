//
//  ObsevationViewModel.swift
//  Care365-iPhone
//
//  Created by Apple on 07/04/21.
//

import Foundation

class ObsevationViewModel {
    func getPatientWtRecord(success:@escaping(PatientWtRecords,Int)->())  {
        let url = DevelopmentServer.baseUrl + PatientDetails.pateintBpandWeightRecUrl + patientId
        APIManager.instance.getUrlSessionHeaderDetailsFromServerMethod(url: url) { (response, statuscode) in
            PrintLog.print(response,statuscode)
            do{
                let jsonDecoder = JSONDecoder()
                let mainData = try jsonDecoder.decode(PatientWtRecords.self, from: response as! Data)
                success(mainData,statuscode)
            }catch let jsonErr {
                PrintLog.print("Error decoding Json Questons", jsonErr)
                //(jsonErr.localizedDescription)
            }
        } failure: { (error) in
            print(error)
        }
    }
    
    func getPatientBpRecord(success:@escaping(PatientBpRecords,Int)->())  {
        let url = DevelopmentServer.baseUrl + PatientDetails.pateintBpandWeightRecUrl + patientId
        APIManager.instance.getUrlSessionHeaderDetailsFromServerMethod(url: url) { (response, statuscode) in
            PrintLog.print(response,statuscode)
            do{
                let jsonDecoder = JSONDecoder()
                let mainData = try jsonDecoder.decode(PatientBpRecords.self, from: response as! Data)
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
