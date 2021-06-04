//
//  ViewModel.swift
//  ChatBoxSwift
//
//  Created by Apple on 20/04/21.
//

import Foundation

struct Symptom : Codable {
    var weight : weight?
    var Hypertension : Hypertension?
    var Hypotension : Hypotension?
}
struct weight : Codable {
    var orange : orange?
    var red : red?
    
}

struct Hypertension: Codable {
    var orange : Survey?
    var red : Survey?
}

struct Hypotension: Codable {
    var orange : Survey?
    var red : Survey?
}

struct orange : Codable {
    var survey : [arr]?
}
struct red : Codable {
    var red : Survey?
    var survey : [arr]?
}
struct Survey : Codable {
    var survey : [arr]?
    
}
struct arr : Codable {
    var id : String?
    var message : String?
    var options : [Options]?
    var type : String?
    //local 
    var status: String?
    var symptom : String?
    var imgUrl : String?
}

struct Options : Codable {
    var label : String?
    var trigger : String?
    var show : String?
    var symptom : String?
    var imgUrl : String?
    //var value : String?
    
}


