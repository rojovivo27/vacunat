//
//  UserModel.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 05/05/25.
//

import Foundation

struct UserModel: Codable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var dateOfBirth: Date
    var gender: Int // 0: Male - 1: Female
    var isPregnant: Bool
    var pregnancyMonths: Int?
}
