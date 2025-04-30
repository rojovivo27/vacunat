//
//  HomeViewModel.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 29/04/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    var info: [String: [InfoVaccine]] = [:]
    var loaded: Bool = false
    
    func loadInfo() async {
        if let path = Bundle.main.path(forResource: "vaccines", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            info = loadVaccinesGroupedByCategory(from: data)
//            for (category, vaccines) in info {
//                print("Category: \(category)")
//                for vaccine in vaccines {
//                    print("- \(vaccine.nombre): \(vaccine.edad)")
//                }
//            }
        }
    }
    
    private func loadVaccinesGroupedByCategory(from jsonData: Data) -> [String: [InfoVaccine]] {
        do {
            let root = try JSONDecoder().decode(VaccineRoot.self, from: jsonData)
            var groupedVaccines: [String: [InfoVaccine]] = [:]
            
            for vaccine in root.vacunas.informativas {
                groupedVaccines[vaccine.categorias, default: []].append(vaccine)
            }
            
            return groupedVaccines
        } catch {
            print("Failed to decode JSON:", error)
            return [:]
        }
    }
}
