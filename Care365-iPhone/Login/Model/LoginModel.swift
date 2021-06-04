//
//  LoginModel.swift
//  Care365-iPhone
//
//  Created by Apple on 30/03/21.
//

import Foundation

struct User: Codable {
    let jwtToken: String?
    let sessionId: String?
    let userDetails: UserDetail?
    let baseResourcePath: String?
}

struct UserDetail: Codable {
    let id: String?
    let userName: String?
    let userRole: String?
    let userStatus: String?
}


