//
//  HomeView.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 10/04/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    
    @State var loading: Bool = false
    @State var showVaccines: Bool = false
    @State var title: String = ""
    @State var vaccines: [InfoVaccine] = []
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    HStack(spacing: 20) {
                        homeButton(
                            imageName: "004-baby-with-diaper") {
                                title = "Vacunas para Bebés"
                                vaccines = vm.info["Bebe"] ?? []
                                showVaccines = true
                            }
                        
                        homeButton(imageName: "003-standing-up-man") {
                            title = "Vacunas para Adolescentes"
                            vaccines = vm.info["Adolescente"] ?? []
                            showVaccines = true
                        }
                    }
                    .padding(8)
                    
                    
                    HStack(spacing: 20) {
                        homeButton(imageName: "002-people") {
                            title = "Vacunas para Embarazo"
                            vaccines = vm.info["Embarazada"] ?? []
                            showVaccines = true
                        }
                        
                        homeButton(imageName: "001-old-couple") {
                            title = "Vacunas para 3ra Edad"
                            vaccines = vm.info["Adulto"] ?? []
                            showVaccines = true
                        }
                    }
                }
                .navigationTitle("Vacunas")
                .navigationDestination(isPresented: $showVaccines) {
                    VaccinesList(title: title, vaccines: vaccines)
                }
            }
            
            if !loading {
                ProgressView()
            }
        }
        .onAppear {
            Task {
                await vm.loadInfo()
                loading.toggle()
            }
        }
    }
    
    func homeButton(
        imageName: String,
        action: (() -> ())?
    ) -> some View {
        Button {
            action?()
        } label: {
            Image(imageName)
                .resizable()
                .scaledToFit()
        }
        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.3)
        .background(.blue)
        .buttonStyle(.borderedProminent)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    HomeView()
}
