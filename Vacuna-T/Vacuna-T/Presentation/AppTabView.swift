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
            Text("Perfil")
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Perfil")
                }
            Text("Cartilla")
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("Cartilla")
                }
            Text("Notificaciones")
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Notificaciones")
                }
            Text("Info")
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
