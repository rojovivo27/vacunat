//
//  VaccineInfo.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 30/04/25.
//

import SwiftUI

struct VaccineInfo: View {
    
    var vaccine: InfoVaccine
    @State var texts: [String] = []
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Aplicar en: ")
                        Text(vaccine.edad)
                            .fontWeight(.semibold)
                    }
                    .padding(.bottom, 4)
                    ForEach(Array(texts.enumerated()), id: \.element.self) { index, text in
                        if index % 2 == 0 {
                            Text(text)
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                                .foregroundStyle(.blue)
                        } else {
                            Text(text)
                                .padding(.bottom, 4)
                        }
                    }
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .onAppear {
            let lines = vaccine.descripcion.split(whereSeparator: \.isNewline)
            texts = lines.map { String($0) }
        }
        .navigationTitle(vaccine.nombre)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 4))
                    .frame(width: 40, height: 40)
            }
        }

    }
}

#Preview {
    VaccineInfo(
        vaccine: .init(nombre: "Rabia con un Título muy largo", descripcion: "¿Pregunta?\nRespuesta\n¿Pregunta?\nRespuesta más larga para ver que pasa con los límites laterales", edad: "0 años", categorias: "Rojos")
    )
}
