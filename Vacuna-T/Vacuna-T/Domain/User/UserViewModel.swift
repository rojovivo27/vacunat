//
//  UserViewModel.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 05/05/25.
//

import Foundation

@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var selectedUser: UserModel? = nil
    @Published var vaccines: [String: [CalculatedVaccination]] = [:]

    private let userKey = "savedUsers"
    private let vaccinesKey = "savedVaccines"
    
    func addUser(newUser: UserModel) async {
        users.append(newUser)
        await addVaccines(for: newUser)
    }
    
    func addVaccines(for user: UserModel) async {
        var vaccines = [CalculatedVaccination]()
        let vm = HomeViewModel()
        await vm.loadInfo()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: user.dateOfBirth, to: Date.now)
        let months = components.month ?? 0
    
        for vaccine in vm.expert {
            if vaccine.categoria == "Embarazada" {
                if user.isPregnant && vaccine.edad >= user.pregnancyMonths ?? 9 {
                    let toDateMonths = vaccine.edad - (user.pregnancyMonths ?? 9)
                    let toDate = calendar.date(byAdding: .month, value: toDateMonths, to: Date.now)
                    vaccines.append(.init(toDate: toDate ?? Date(), vaccine: vaccine))
                }
            } else if vaccine.anual {
                if (vaccine.limite ?? 9999) >= months {
                    vaccines.append(.init(toDate: Date(), vaccine: vaccine))
                }
            } else {
                if vaccine.edad >= months {
                    let toDateMonths = vaccine.edad - months
                    let toDate = calendar.date(byAdding: .month, value: toDateMonths, to: user.dateOfBirth)
                    vaccines.append(.init(toDate: toDate ?? Date(), vaccine: vaccine))
                }
            }
        }
        self.vaccines[user.id.uuidString] = vaccines.sorted { $0.toDate < $1.toDate }
        print(vaccines.count)
    }
    
    func deleteUser(id: UUID) {
        users.removeAll { user in
            user.id == id
        }
    }
    
    func deleteVaccines(id: UUID) {
        vaccines.removeValue(forKey: id.uuidString)
    }
    
    func updateUser(user: UserModel) {
        if let index = users.firstIndex(where: { u in
            u.id == user.id
        }) {
            users[index] = user
        }
    }
    
    func saveUsers() async {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: userKey)
        }
        await saveVaccines()
    }
    
    func saveVaccines() async {
        if let data = try? JSONEncoder().encode(vaccines) {
            UserDefaults.standard.set(data, forKey: vaccinesKey)
        }
    }

    func loadUsers() {
        if let data = UserDefaults.standard.data(forKey: userKey),
           let savedUsers = try? JSONDecoder().decode([UserModel].self, from: data) {
            users = savedUsers
        }
    }
}
