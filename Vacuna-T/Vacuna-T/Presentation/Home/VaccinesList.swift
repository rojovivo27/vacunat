//
//  VaccinesList.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 30/04/25.
//

import SwiftUI

struct VaccinesList: View {
    var title: String
    var vaccines: [InfoVaccine]
    
    @State var showVaccine: Bool = false
    @State var selectedVaccine: InfoVaccine? = nil
    
    var body: some View {
        List {
            ForEach(vaccines, id: \.nombre) { vaccine in
                vaccineButton(name: vaccine.nombre) {
                    selectedVaccine = vaccine
                    showVaccine = true
                }
            }
        }
        .navigationTitle(title)
        .navigationDestination(isPresented: $showVaccine) {
            if let vaccine = selectedVaccine {
                VaccineInfo(vaccine: vaccine)
            }
        }
        
    }
    
    func vaccineButton(
        name: String,
        action: (() -> ())?
    ) -> some View {
        Button {
            action?()
        } label: {
            HStack {
                Text(name)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
                Spacer()
                Image(systemName: "chevron.right")
                        .font(.body)
            }
        }
    }
}

#Preview {
    VaccinesList(
        title: "Vacunas para Rojos",
        vaccines: [
            .init(nombre: "Rabia", descripcion: "Rabiosidad", edad: "0 años", categorias: "Rojos")
        ]
    )
}
