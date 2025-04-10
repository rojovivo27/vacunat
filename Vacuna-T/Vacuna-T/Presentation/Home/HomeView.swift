//
//  HomeView.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 10/04/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    HStack(spacing: 20) {
                        Button {
                            
                        } label: {
                            Image(systemName: "figure.fall")
                                .font(.system(size: 100))
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.3)
                        .background(.blue)
                        .buttonStyle(.borderedProminent)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "figure.archery")
                                .font(.system(size: 100))
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.3)
                        .background(.blue)
                        .buttonStyle(.borderedProminent)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(8)
                    
                    
                    HStack(spacing: 20) {
                        Button {
                            
                        } label: {
                            Image(systemName: "figure.2")
                                .font(.system(size: 100))
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.3)
                        .background(.blue)
                        .buttonStyle(.borderedProminent)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "figure.child")
                                .font(.system(size: 100))
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.3)
                        .background(.blue)
                        .buttonStyle(.borderedProminent)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .navigationTitle("Vacunas")
            }
        }
    }
}

#Preview {
    HomeView()
}
