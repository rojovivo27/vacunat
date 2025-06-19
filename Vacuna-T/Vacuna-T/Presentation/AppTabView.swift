//
//  AppTabView.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 10/04/25.
//

import SwiftUI

struct AppTabView: View {
    
    @StateObject private var userVM = UserViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Inicio")
                }
                .tag(0)
            ProfileView(viewModel: userVM, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Perfil")
                }
                .tag(1)
            CategoriesView()
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("Cartilla")
                }
                .tag(2)
            NotificationsView(viewModel: userVM)
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Notificaciones")
                }
                .tag(3)
            InfoView()
                .tabItem {
                    Image(systemName: "info.bubble.fill")
                    Text("Info")
                }
                .tag(4)
        }
    }
}

#Preview {
    AppTabView()
}
