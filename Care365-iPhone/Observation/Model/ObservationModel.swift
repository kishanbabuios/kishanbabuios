//
//  ObservationModel.swift
//  Care365-iPhone
//
//  Created by Apple on 07/04/21.
//

import Foundation

struct PatientWtRecords : Codable {
    let patientWtMngt : PatientWeight?
    
    
}

struct PatientWeight : Codable{
    let id : String?
    let weight : String?
    let createdAt :  String?
    let status: String?
    let deviceId : String?
    let patientRequested : String?
}

struct PatientBpRecords : Codable{
    let patientBpMngt : PatientBp?
}
struct PatientBp : Codable {
    let id : String?
    let sys : String?
    let dia : String?
    let created_at :  String?
    let status: String?
    let devid:String?
}

