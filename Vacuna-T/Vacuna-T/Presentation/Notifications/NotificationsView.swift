//
//  NotificationsView.swift
//  Vacuna-T
//
//  Created by Demo on 18/06/25.
//

import SwiftUI

struct NotificationsView: View {
    
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.selectedUser == nil {
                    Spacer()
                    Text("Primero debe crear un perfil. Agregue un nuevo perfil presionando el botón de 'Agregar nuevo perfil' del apartado de Perfil.")
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    VStack {
                        let years = Calendar.current.dateComponents([.year], from: viewModel.selectedUser?.dateOfBirth ?? Date.now, to: Date.now).year ?? 0
                        let imageName = (viewModel.selectedUser?.gender ?? 0) == 0 ? years < 3 ? "006-baby" : years < 15 ? "004-boy" : years < 60 ? "007-man" : "002-old-man" : years < 3 ? "005-baby-1" : years < 15 ? "003-girl" : years < 60 ? "008-girl-1" : "001-old-woman"
                        HStack {
                            Image(imageName)
                                .resizable()
                                .clipShape(.rect(cornerRadius: 8))
                                .frame(width: 80, height: 80)
                                .padding()
                            
                            Picker("Select User", selection: $viewModel.selectedUser) {
                                ForEach(viewModel.users) { user in
                                    Text(user.name).tag(user.self)
                                }
                            }
                            .pickerStyle(.wheel)
                        }
                        VaccinationListSectionView(viewModel: viewModel)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Notificaciones")
            .padding()
            .onAppear {
                viewModel.loadUsers()
                viewModel.loadVaccines()
                if viewModel.selectedUser == nil {
                    viewModel.selectedUser = viewModel.users.first
                }
            }
        }
    }
}


#Preview {
    NotificationsView(viewModel: UserViewModel())
}
