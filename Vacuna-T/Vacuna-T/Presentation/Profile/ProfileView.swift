//
//  ProfileView.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 05/05/25.
//

import SwiftUI


struct ProfileView: View {
    
    @StateObject var vm = UserViewModel()
    @State var showNewUserView: Bool = false
    @State var isEdition: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            if vm.selectedUser == nil {
                Text("Primero debe crear un perfil. Agregue un nuevo perfil presionando el botón de 'Agregar nuevo perfil'.")
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            } else {
                VStack {
                    let years = Calendar.current.dateComponents([.year], from: vm.selectedUser?.dateOfBirth ?? Date.now, to: Date.now).year ?? 0
                    let imageName = (vm.selectedUser?.gender ?? 0) == 0 ? years < 3 ? "006-baby" : years < 15 ? "004-boy" : years < 60 ? "007-man" : "002-old-man" : years < 3 ? "005-baby-1" : years < 15 ? "003-girl" : years < 60 ? "008-girl-1" : "001-old-woman"
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
                    
                    Button {
                        isEdition = true
                    } label: {
                        Text("Editar perfil")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button(role: .destructive) {
                        if let id = vm.selectedUser?.id {
                            Task {
                                vm.deleteUser(id: id)
                                await vm.saveUsers()
                                vm.deleteVaccines(id: id)
                                await vm.saveVaccines()
                                vm.selectedUser = vm.users.first
                            }
                        }
                    } label: {
                        Text("Eliminar perfil")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom, 32)
                    
                    if vm.selectedUser != nil {
                        Text(vm.selectedUser?.dateOfBirth.formatted(date: .abbreviated, time: .omitted) ?? "")
                        if let dob = vm.selectedUser?.dateOfBirth {
                            let components = Calendar.current.dateComponents([.year, .month, .day], from: dob, to: Date.now)
                            Text("\(components.year ?? 0) años, \(components.month ?? 0) meses y \(components.day ?? 0) días")
                        }
                    }
                }
            }
            Spacer()
            
            Button {
                showNewUserView = true
            } label: {
                Text("Agregar nuevo perfil")
            }
        }
        .padding()
        .onAppear {
            vm.loadUsers()
            vm.selectedUser = vm.users.first
        }
        .sheet(isPresented: $showNewUserView) {
            NewProfileView(vm: vm)
        }
        .sheet(isPresented: $isEdition) {
            NewProfileView(
                vm: vm,
                dob: vm.selectedUser?.dateOfBirth ?? Date.now,
                name: vm.selectedUser?.name ?? "",
                gender: vm.selectedUser?.gender ?? 0,
                isPregnant: vm.selectedUser?.isPregnant ?? false,
                pregnancyMonths: vm.selectedUser?.pregnancyMonths ?? 0,
                id: vm.selectedUser?.id ?? UUID()
            )
        }
    }
}

#Preview {
    ProfileView()
}
