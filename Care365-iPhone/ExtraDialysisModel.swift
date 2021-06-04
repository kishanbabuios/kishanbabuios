//
//  ExtraDialysisModel.swift
//  Care365-iPhone
//
//  Created by Apple on 02/06/21.
//

import Foundation

struct ExtraDialysisModel:Codable {
    var id : String?
    var patientId : String?
    var observationId : String?
    var appointmentRequestDate : String?
    var status : String?
    var patientRequested : String?
}


/*
 {"id":"APR_1HbzBvO172","patientId":"PAT_FwuGdGa335","observationId":"PWM_UVKhnPm991","appointmentRequestDate":"2021-06-02T22:33:21.000+05:30","status":"0","patientRequested":"YES"}
 */
