//
//  UserViewModel.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 05/05/25.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var selectedUser: UserModel? = nil

    private let userKey = "savedUsers"
    
    func addUser(newUser: UserModel) {
        users.append(newUser)
    }
    
    func deleteUser(id: UUID) {
        users.removeAll { user in
            user.id == id
        }
    }
    
    func updateUser(user: UserModel) {
        if let index = users.firstIndex(where: { u in
            u.id == user.id
        }) {
            users[index] = user
        }
    }
    
    func saveUsers() {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: userKey)
        }
    }

    func loadUsers() {
        if let data = UserDefaults.standard.data(forKey: userKey),
           let savedUsers = try? JSONDecoder().decode([UserModel].self, from: data) {
            users = savedUsers
        }
    }
}
