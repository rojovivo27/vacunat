//
//  Utilities.swift
//  VacunaT
//
//  Created by Aldo on 11/01/18.
//  Copyright © 2018 Aldo. All rights reserved.
//

import Foundation

enum VaccinateCategory {
    case baby
    case teen
    case pregnant
    case elder
    case none
}

class User: SQLTable {
    var id = -1
    var name = ""
    var bDay = Date()
    var gender = ""
    var pregnancy = false
    var gestationalAge = 0
}

class Notification: SQLTable {
    var id = -1
    var idUser = 0
    var name = ""
    var category = ""
    var months = 0
    var isAnual = false
    var application = ""
    var sideEffects = ""
    var done = false
    var estimatedDate = Date()
    var receivedOn = Date()
}

class InfoVaccinate {
    var name = ""
    var details = ""
    var age = ""
    
    init(name: String, details: String, age: String){
        self.name = name
        self.details = details
        self.age = age
    }
}

class Utilities  {
    static let sharedInstance = Utilities()
    
}
