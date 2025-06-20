//
//  ProfileView.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 05/05/25.
//

import SwiftUI


struct ProfileView: View {
    
    @ObservedObject var viewModel: UserViewModel
    @State var showNewUserView: Bool = false
    @State var isEdition: Bool = false
    
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                if viewModel.selectedUser == nil {
                    Text("Primero debe crear un perfil. Agregue un nuevo perfil presionando el botón de 'Agregar nuevo perfil'.")
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                } else {
                    VStack {
                        let years = Calendar.current.dateComponents([.year], from: viewModel.selectedUser?.dateOfBirth ?? Date.now, to: Date.now).year ?? 0
                        let imageName = (viewModel.selectedUser?.gender ?? 0) == 0 ? years < 3 ? "006-baby" : years < 15 ? "004-boy" : years < 60 ? "007-man" : "002-old-man" : years < 3 ? "005-baby-1" : years < 15 ? "003-girl" : years < 60 ? "008-girl-1" : "001-old-woman"
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
                        
                        if viewModel.selectedUser != nil {
                            Text(viewModel.selectedUser?.dateOfBirth.formatted(date: .abbreviated, time: .omitted) ?? "")
                                .fontWeight(.semibold)
                            if let dob = viewModel.selectedUser?.dateOfBirth {
                                let components = Calendar.current.dateComponents([.year, .month, .day], from: dob, to: Date.now)
                                Text("\(components.year ?? 0) años, \(components.month ?? 0) meses y \(components.day ?? 0) días")
                                    .fontWeight(.medium)
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
                            Button {
                                selectedTab = 3
                            } label: {
                                Text("Ver vacunas")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)
                            .frame(width: 200)
                            
                            Button {
                                isEdition = true
                            } label: {
                                Text("Editar perfil")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .frame(width: 200)
                            
                            Button(role: .destructive) {
                                if let id = viewModel.selectedUser?.id {
                                    Task {
                                        viewModel.deleteUser(id: id)
                                        await viewModel.saveUsers()
                                        viewModel.deleteVaccines(id: id)
                                        await viewModel.saveVaccines()
                                        viewModel.selectedUser = viewModel.users.first
                                    }
                                }
                            } label: {
                                Text("Eliminar perfil")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .frame(width: 200)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 32)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Perfiles")
            .padding()
            .onAppear {
                viewModel.loadUsers()
                viewModel.loadVaccines()
                if viewModel.selectedUser == nil {
                    viewModel.selectedUser = viewModel.users.first
                }
            }
            .toolbar {
                Button {
                    showNewUserView = true
                } label: {
                    Text("Agregar")
                }
            }
            .sheet(isPresented: $showNewUserView) {
                NewProfileView(vm: viewModel)
            }
            .sheet(isPresented: $isEdition) {
                NewProfileView(
                    vm: viewModel,
                    dob: viewModel.selectedUser?.dateOfBirth ?? Date.now,
                    name: viewModel.selectedUser?.name ?? "",
                    gender: viewModel.selectedUser?.gender ?? 0,
                    isPregnant: viewModel.selectedUser?.isPregnant ?? false,
                    pregnancyMonths: viewModel.selectedUser?.pregnancyMonths ?? 0,
                    id: viewModel.selectedUser?.id ?? UUID()
                )
            }
        }
    }
}

#Preview {
    ProfileView(viewModel: UserViewModel(), selectedTab: .constant(1))
}
