//
//  AppTabView.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 10/04/25.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Inicio")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Perfil")
                }
            CategoriesView()
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("Cartilla")
                }
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Notificaciones")
                }
            InfoView()
                .tabItem {
                    Image(systemName: "info.bubble.fill")
                    Text("Info")
                }
        }
    }
}

#Preview {
    AppTabView()
}
