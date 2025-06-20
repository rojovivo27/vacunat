//
//  UserViewModel.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 05/05/25.
//

import Foundation
import UserNotifications

@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var selectedUser: UserModel? = nil
    @Published var vaccines: [String: [CalculatedVaccination]] = [:]
    @Published var permissionRequested = false

    private let userKey = "savedUsers"
    private let vaccinesKey = "savedVaccines"
    private let permissionKey = "notifications"
    
    init(){
        permissionRequested = UserDefaults.standard.bool(forKey: permissionKey)
    }
    
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
                    let toDate = calendar.date(byAdding: .month, value: toDateMonths, to: Date.now)
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
        deleteAlerts(for: id)
    }
    
    func deleteAlerts(for userId: UUID) {
        let ids = getVaccinesIDs(for: userId.uuidString)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ids)
    }
    
    private func getVaccinesIDs(for userId: String) -> [String] {
        var ids = [String]()
        let vaccines = self.vaccines[userId] ?? []
        for vaccine in vaccines {
            ids.append(vaccine.id.uuidString)
            if vaccine.vaccine.anual, let limit = vaccine.vaccine.limite {
                let calendar = Calendar.current
                
                let startDate = vaccine.toDate
                var date = startDate
                let endDate = calendar.date(byAdding: .month, value: limit, to: selectedUser?.dateOfBirth ?? Date()) ?? startDate
                
                var ocurrences = 1
                
                while date <= endDate {
                    
                    let id = "\(vaccine.id.uuidString)-\(ocurrences)"
                    ids.append(id)

                    // Move to next repetition
                    date = calendar.date(byAdding: .year, value: 1, to: date) ?? endDate
                    ocurrences = ocurrences + 1
                }
            }
        }
        return ids
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
    
    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.permissionRequested = true
                }
                UserDefaults.standard.set(true, forKey: self.permissionKey)
            } else if let error {
                DispatchQueue.main.async {
                    self.permissionRequested = false
                }
                UserDefaults.standard.set(false, forKey: self.permissionKey)
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleVaccines(for userId: String) {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: -1, to: Date.now) ?? Date.now
        let vaccines = self.vaccines[userId]?.filter { $0.appliedOn == nil && $0.toDate >= date } ?? []
        for vaccine in vaccines {
            createAlert(info: vaccine)
        }
        if let index = users.firstIndex(where: {$0.id.uuidString == userId}) {
            users[index].notificationsScheduled = true
            selectedUser = users[index]
        }
    }
    
    private func createAlert(info: CalculatedVaccination) {
        
        let calendar = Calendar.current
        
        let content = UNMutableNotificationContent()
        content.title = "Alerta de vacuna \(info.vaccine.nombre) para \(selectedUser?.name ?? "")"
        content.subtitle = "Estimada para el dia \(dateFormatter.string(from: info.toDate))"
        content.sound = UNNotificationSound.default
        
        var trigger: UNNotificationTrigger?
        
        if info.vaccine.anual {
            if let limit = info.vaccine.limite {
                //Schedule anual notifications manually
                
                let startDate = info.toDate
                var date = startDate
                let endDate = calendar.date(byAdding: .month, value: limit, to: selectedUser?.dateOfBirth ?? Date()) ?? startDate
                
                var ocurrences = 1
                
                while date <= endDate {
                    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)

                    let content2 = UNMutableNotificationContent()
                    content2.title = content.title
                    content2.body = "Estimada para el dia \(dateFormatter.string(from: date))"
                    content2.sound = .default

                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    let id = "\(info.id.uuidString)-\(ocurrences)"

                    let request = UNNotificationRequest(identifier: id, content: content2, trigger: trigger)

                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error scheduling notification: \(error)")
                        }
                    }
                    print("Alert created: \(content2.title) , \(content2.subtitle)")

                    // Move to next repetition
                    date = calendar.date(byAdding: .year, value: 1, to: date) ?? endDate
                    ocurrences = ocurrences + 1
                }
                return
                
            } else {
                //Schedule repeatable time based notification
                let triggerDate = Calendar.current.dateComponents(
                    [.year, .month, .day, .hour, .minute],
                    from: info.toDate
                )
                trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
            }
        } else {
            //One time vaccination
            let triggerDate = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: info.toDate
            )
            trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        }
        guard let trigger = trigger else { return }
        let request = UNNotificationRequest(identifier: info.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        print("Alert created: \(content.title) , \(content.subtitle)")
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
