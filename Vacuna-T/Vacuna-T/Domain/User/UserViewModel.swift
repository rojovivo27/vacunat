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
                    vaccines.append(.init(id: UUID(), toDate: toDate ?? Date(), vaccine: vaccine))
                }
            } else if vaccine.anual {
                if (vaccine.limite ?? 9999) >= months {
                    vaccines.append(.init(id: UUID(), toDate: Date(), vaccine: vaccine))
                }
            } else {
                if vaccine.edad >= months {
                    let toDateMonths = vaccine.edad - months
                    let toDate = calendar.date(byAdding: .month, value: toDateMonths, to: user.dateOfBirth)
                    vaccines.append(.init(id: UUID(), toDate: toDate ?? Date(), vaccine: vaccine))
                }
            }
        }
        self.vaccines[user.id.uuidString] = vaccines.sorted { $0.toDate < $1.toDate }
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
    
    func loadVaccines() {
        if let data = UserDefaults.standard.data(forKey: vaccinesKey),
           let savedVaccines = try? JSONDecoder().decode([String: [CalculatedVaccination]].self, from: data) {
            vaccines = savedVaccines
        }
    }
    
    func markAsDone(vaccination: CalculatedVaccination, for user: UserModel) {
        if let index = vaccines[user.id.uuidString]?.firstIndex(where: {$0.id == vaccination.id}) {
            vaccines[user.id.uuidString]?[index].appliedOn = Date.now
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
