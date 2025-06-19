//
//  VaccinationsListSectionView.swift
//  Vacuna-T
//
//  Created by Demo on 18/06/25.
//

import SwiftUI

struct VaccinationListSectionView: View {
    
    @StateObject var viewModel: UserViewModel

    var body: some View {
        List {
            // Next vaccinations
            if let vaccines = viewModel.vaccines[viewModel.selectedUser?.id.uuidString ?? ""] {
                Section(header: Text("Próximas Vacunas")) {
                    ForEach(vaccines.filter({ $0.appliedOn == nil})) { vaccination in
                        VStack(alignment: .leading) {
                            Text(vaccination.vaccine.nombre)
                            Text("Fecha estimada: \(viewModel.dateFormatter.string(from: vaccination.toDate))")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        .listRowBackground(VaccinationStatus.from(vaccination: vaccination).color)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                Task {
                                    viewModel.markAsDone(vaccination: vaccination, for: viewModel.selectedUser!)
                                    await viewModel.saveVaccines()
                                }
                            } label: {
                                Label("Realizada", systemImage: "checkmark")
                            }
                            .tint(.green)
                        }
                    }
                }
                
                Section(header: Text("Vacunas Recientes")) {
                    ForEach(vaccines.filter({ $0.appliedOn != nil})) { vaccination in
                        VStack(alignment: .leading) {
                            Text(vaccination.vaccine.nombre)
                            if let appliedOn = vaccination.appliedOn {
                                Text("Aplicada el: \(viewModel.dateFormatter.string(from: appliedOn))")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            }
                        }
                        .listRowBackground(VaccinationStatus.from(vaccination: vaccination).color)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    let vm = UserViewModel()
    VaccinationListSectionView(viewModel: vm)
}
