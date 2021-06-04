//
//  HistoryModel.swift
//  Care365-iPhone
//
//  Created by Apple on 30/03/21.
//

import Foundation
import UIKit

struct WeightHistoryModel : Codable {
    let weight : String?
    let zoneofpatient : String?
    let createdAt : String?
}

struct BpHistoryModel : Codable {
    let zoneofpatient : String?
    let created_at : String?
    let sys : String?
    let dia : String?
}

