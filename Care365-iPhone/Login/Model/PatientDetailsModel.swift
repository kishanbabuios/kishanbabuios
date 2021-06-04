//
//  PatientDetailsModel.swift
//  Care365-iPhone
//
//  Created by Apple on 31/03/21.
//

import Foundation

struct Patient: Codable {
    let id: String?
    let firstName : String?
    let lastName : String?
    let age : Int?
    let gender : String?
    let emrPatientId : String?
    let care365Email : String?
    let cellNumber : String?
    let address : Address?
    let primaryDiagnosis : String?
    let secondaryDiagnosis : String?
    let height : String?
    let weight : String?
    let duration :  String?
    let dryWeight : String?
    let systolicBloodPressure : String?
    let diastolicBloodPressure : String?
    let branch : Branch?
    let primaryPhysician : PrimaryPhysician?
    let insuranceData : InsuranceData?
    let bpDeviceId : String?
    let wtDeviceId : String?
}


struct Address: Codable {
    let addressLine : String?
    let city : String?
    let state : String?
    let zipCode : Int?
}

struct Branch : Codable {
    let name : String?
}
struct PrimaryPhysician : Codable {
    let name : String?
}
struct InsuranceData: Codable {
    let medicareNumber : String?
    let medicareAdvantageInsurer : String?
}

/*firstName,lastName, age,gender,emrPatientId,care365Email,cellNumber,address-->addressLine,city,state,zipCode*/
/*primaryDiagnosis,secondaryDiagnosis,height,dryWeight,systolicBloodPressure/diastolicBloodPressure,*/
/* branch-->name*/
/* primaryPhysician-->name*/
/* medicareNumber,medicareAdvantageInsurer*/
/* dev-120,dev-119*/
