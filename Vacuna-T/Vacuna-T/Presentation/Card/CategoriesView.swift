//
//  CategoriesView.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 05/05/25.
//

import SwiftUI

struct CategoriesView: View {
    
    @State var showCard: Bool = false
    @State var title: String = ""
    @State var cardName: String = ""
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack(alignment: .leading) {
                    
                    categoryButton(
                        imageName: "004-baby-with-diaper",
                        title: "Niños") {
                            title = "Niños"
                            cardName = "cartilla-de-vacunacion-ninos"
                            showCard = true
                        }
                    
                    categoryButton(
                        imageName: "002-child",
                        title: "Adolescentes") {
                            title = "Adolescentes"
                            cardName = "cartilla-de-vacunacion-ninos-1"
                            showCard = true
                        }
                    
                    categoryButton(
                        imageName: "003-standing-up-man",
                        title: "Hombres") {
                            title = "Hombres"
                            cardName = "cartilla-vacunacion-hombres"
                            showCard = true
                        }
                    
                    categoryButton(
                        imageName: "001-woman",
                        title: "Mujeres") {
                            title = "Mujeres"
                            cardName = "cartilla-vacunacion-mujeres"
                            showCard = true
                        }
                    
                    categoryButton(
                        imageName: "001-old-couple",
                        title: "Adultos Mayores") {
                            title = "Adultos Mayores"
                            cardName = "cartilla-vacunacion-adultos-mayores"
                            showCard = true
                        }
                }
                .navigationTitle("Cartilla")
                .navigationDestination(isPresented: $showCard) {
                    //CardView(cardName: cardName)
                    ZoomableImageView(imageName: cardName)
                        .navigationTitle(title)
                }
            }
        }
    }
    
    func categoryButton(
        imageName: String,
        title: String,
        action: (() -> ())?
    ) -> some View {
        HStack {
            Button {
                action?()
            } label: {
                Image(imageName)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                
            }
            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.1)
            .background(.blue)
            .buttonStyle(.borderedProminent)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            Button {
                action?()
            } label: {
                Text(title)
                    .font(.system(size: 28))
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    CategoriesView()
}
