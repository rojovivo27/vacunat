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
                    vm.deleteUser(id: id)
                    vm.saveUsers()
                    vm.selectedUser = vm.users.first
                }
            } label: {
                Text("Eliminar perfil")
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 32)
            
            if vm.selectedUser != nil {
                Text(vm.selectedUser?.dateOfBirth.formatted(date: .abbreviated, time: .omitted) ?? "")
                Text("\(Calendar.current.dateComponents([.year], from: vm.selectedUser?.dateOfBirth ?? Date.now, to: Date.now).year ?? 0) años")
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
