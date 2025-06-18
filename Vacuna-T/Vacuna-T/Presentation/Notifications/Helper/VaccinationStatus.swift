//
//  VaccinationStatus.swift
//  Vacuna-T
//
//  Created by Demo on 18/06/25.
//

import Foundation
import SwiftUI

enum VaccinationStatus {
    case overdue
    case dueSoon
    case upcoming
    case taken

    static func from(vaccination: CalculatedVaccination) -> VaccinationStatus {
        if let _ = vaccination.appliedOn {
            return .taken
        }

        let now = Date()
        if vaccination.toDate < now {
            return .overdue
        } else if Calendar.current.dateComponents([.day], from: now, to: vaccination.toDate).day ?? 0 <= 60 {
            return .dueSoon
        } else {
            return .upcoming
        }
    }

    var color: Color {
        switch self {
        case .overdue:
            return .red.opacity(0.1)
        case .dueSoon:
            return .yellow.opacity(0.1)
        case .upcoming:
            return .green.opacity(0.1)
        case .taken:
            return .blue.opacity(0.1)
        }
    }
}
