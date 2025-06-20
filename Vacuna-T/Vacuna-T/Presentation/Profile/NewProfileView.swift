//
//  NewProfileView.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 05/05/25.
//

import SwiftUI

struct NewProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var vm: UserViewModel
    
    @State var dob: Date = Date.now
    @State var name: String = ""
    @State var gender: Int = 0
    @State var isPregnant: Bool = false
    @State var pregnancyMonths: Int = 1
    @State var id: UUID? = nil
    
    var body: some View {
        
        VStack {
            let years = Calendar.current.dateComponents([.year], from: dob, to: Date.now).year ?? 0
            let imageName = gender == 0 ? years < 3 ? "006-baby" : years < 15 ? "004-boy" : years < 60 ? "007-man" : "002-old-man" : years < 3 ? "005-baby-1" : years < 15 ? "003-girl" : years < 60 ? "008-girl-1" : "001-old-woman"
            Image(imageName)
                .resizable()
                .clipShape(.rect(cornerRadius: 8))
                .frame(width: 80, height: 80)
                .padding()
            
            TextField("Nombre o Alias", text: $name)
            
            DatePicker(selection: $dob, displayedComponents: .date) {
            }
            .datePickerStyle(.wheel)
            
            VStack {
                HStack {
                    Text("Sexo")
                    Picker(
                        "Sexo",
                        selection: $gender) {
                            Text("M").tag(0)
                            Text("F").tag(1)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 100)
                    
                }
                
                if gender == 1 {
                    Toggle("Embarazada?", isOn: $isPregnant)
                        .frame(width: 160)
                }
                
                if isPregnant {
                    Stepper("Meses de embarazo: \(pregnancyMonths)", value: $pregnancyMonths, in: 1...9)
                        .frame(width: 300)
                }
            }
            
            Button {
                let user = UserModel(
                    id: id ?? UUID(),
                    name: name,
                    dateOfBirth: dob,
                    gender: gender,
                    isPregnant: isPregnant,
                    pregnancyMonths: isPregnant ?  pregnancyMonths : nil
                )
                if id != nil {
                    Task {
                        vm.updateUser(user: user)
                        await vm.saveUsers()
                        vm.deleteVaccines(id: user.id)
                        await vm.addVaccines(for: user)
                        await vm.saveVaccines()
                        if vm.selectedUser?.notificationsScheduled ?? false {
                                vm.scheduleVaccines(for: vm.selectedUser!.id.uuidString)
                                await vm.saveUsers()
                        }
                        
                    }
                } else {
                    Task {
                        await vm.addUser(newUser: user)
                        await vm.saveUsers()
                        await vm.addVaccines(for: user)
                        await vm.saveVaccines()
                        vm.selectedUser = vm.users.first
                    }
                }
                dismiss()
            } label: {
                Text("Guardar")
            }
            .buttonStyle(.borderedProminent)
            .disabled(name.isEmpty)
            
            Button(role: .destructive) {
                dismiss()
            } label: {
                Text("Cancelar")
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 32)
        }
        .padding()
    }
}

#Preview {
    NewProfileView(vm: UserViewModel())
}
