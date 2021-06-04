//
//  DialysisInfoModel.swift
//  Care365-iPhone
//
//  Created by Apple on 07/04/21.
//

import Foundation

struct DialysisInformation:Codable {
    let status : String?
    let pre_wt : String?
    let pre_bp : String?
    let post_wt : String?
    let post_bp : String?
    let next_dialysis_date : String?
    let last_dialysis_date : String?
    let closeDate : String?
}
