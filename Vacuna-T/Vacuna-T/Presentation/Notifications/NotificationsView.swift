//
//  NotificationsView.swift
//  Vacuna-T
//
//  Created by Demo on 18/06/25.
//

import SwiftUI

struct NotificationsView: View {
    
    @StateObject var vm = UserViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if vm.selectedUser == nil {
                    Spacer()
                    Text("Primero debe crear un perfil. Agregue un nuevo perfil presionando el botón de 'Agregar nuevo perfil' del apartado de Perfil.")
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    VStack {
                        let years = Calendar.current.dateComponents([.year], from: vm.selectedUser?.dateOfBirth ?? Date.now, to: Date.now).year ?? 0
                        let imageName = (vm.selectedUser?.gender ?? 0) == 0 ? years < 3 ? "006-baby" : years < 15 ? "004-boy" : years < 60 ? "007-man" : "002-old-man" : years < 3 ? "005-baby-1" : years < 15 ? "003-girl" : years < 60 ? "008-girl-1" : "001-old-woman"
                        HStack {
                            Image(imageName)
                                .resizable()
                                .clipShape(.rect(cornerRadius: 8))
                                .frame(width: 80, height: 80)
                                .padding()
                            
                            Picker("Select User", selection: $vm.selectedUser) {
                                ForEach(vm.users) { user in
                                    Text(user.name).tag(user.self)
                                }
                            }
                            .pickerStyle(.wheel)
                        }
                        VaccinationListSectionView(viewModel: vm)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Notificaciones")
            .padding()
            .onAppear {
                vm.loadUsers()
                vm.loadVaccines()
                vm.selectedUser = vm.users.first
            }
        }
    }
}


#Preview {
    NotificationsView()
}
