//
//  Vaccine.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 29/04/25.
//

import Foundation

struct InfoVaccine: Decodable {
    let nombre: String
    let descripcion: String
    let edad: String
    let categorias: String
}

struct ExpertVaccine: Codable {
    let nombre: String
    let categoria: String
    let edad: Int
    let anual: Bool
    let limite: Int?
    let contraindicaciones: String
    let indicaciones: String
}

struct VaccineContainer: Decodable {
    let informativas: [InfoVaccine]
    let experto: [ExpertVaccine]
}

struct VaccineRoot: Decodable {
    let vacunas: VaccineContainer
}

struct CalculatedVaccination: Codable {
    let toDate: Date
    let vaccine: ExpertVaccine
}
