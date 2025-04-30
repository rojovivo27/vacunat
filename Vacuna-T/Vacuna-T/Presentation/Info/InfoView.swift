//
//  InfoView.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 30/04/25.
//

import SwiftUI
import MessageUI

struct InfoView: View {
    
    @Environment(\.openURL) var openURL
    
    @State var selectedEmail: String = ""
    @State private var showMailView = false
    @State private var showMailError = false
    @State var info: String =
"""
Información Vacuna-T

Vacuna-T es una aplicación diseñada para la población mexicana en general, la cual ayuda al usuario a recordar las vacunas que próximamente se tienen que administrar de acuerdo con su edad, sexo y estado fisiológico.
La información proporcionada en la aplicación está de acuerdo con las diferentes guías de práctica clínica mexicanas elaboradas por la Secretaria de Salud, así como la cartilla de vacunación nacional para las diferentes edades.

Bibliografía:
1.    Control y seguimiento de la nutrición, el crecimiento y desarrollo de la niña y del niño menor de 5 años. México: Instituto Mexicano del Seguro Social; 2 de diciembre de 2015.
•    Esta guía puede ser descargada en: http://www.cenetec.salud.gob.mx/descargas/gpc/CatalogoMaestro/029_GPC_NinoSano/IMSS_029_08_EyR.pdf
2.    Hinojosa, I., Gutiérrez, A., Urrutia, L. & Saltigeral, P. (Enero 2008). Vacunación en la adolescencia. Revista mexicana de pediatría, Volumen 75, pp. 22-28.
3.    Vacunación en la Embarazada. México: Secretaria de Salud, 2010
•    Esta guía puede ser descargada en: http://www.cenetec.salud.gob.mx/descargas/gpc/CatalogoMaestro/580_GPC_Vacunacixnenlaembarazada/580GER.pdf
4.    Uso de la vacuna antiinfluenza en la prevención de la neumonía en el adulto mayor. México: Secretaría de Salud; 12/ Diciembre/ 2013.
•    Esta guía puede ser descargada en: http://www.cenetec-difusion.com/CMGPC/SS-203-09/ER.pdf
5.    Uso de la vacuna antineumocócica en la prevención de neumonía por Streptococus pneumoniae en el adulto. México: Secretaría de Salud; 12 / diciembre / 2013.
•    Esta guía puede ser descargada en: http://www.cenetec-difusion.com/CMGPC/SS-204-09/ER.pdf

"""
    
    var body: some View {
        ZStack {
            Image("wall")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Image("logo")
                    .resizable()
                    .clipShape(.rect(cornerRadius: 8))
                    .frame(width: 64, height: 64)
                    .padding()
                CustomEditor(text: $info)
                    .background(.white.opacity(0.15))
                    .clipShape(.rect(cornerRadius: 16))
                    .padding(8)
                VStack {
                    Text("E.M.C.P Yair Alejandro Hernández Rea")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    mailButton(email: "yairhernandez96@gmail.com") {
                        selectedEmail = "yairhernandez96@gmail.com"
                        if MFMailComposeViewController.canSendMail() {
                            showMailView = true
                        } else {
                            showMailError = true
                        }
                    }
                    .padding(.bottom, 8)
                    Text("M.T.I. Aldo Roldán Hernández Rea")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    mailButton(email: "aldoroldan.hr@gmail.com") {
                        selectedEmail = "aldoroldan.hr@gmail.com"
                        if MFMailComposeViewController.canSendMail() {
                            showMailView = true
                        } else {
                            showMailError = true
                        }
                    }
                }
                .sheet(isPresented: $showMailView) {
                    MailView(subject: "Hola", messageBody: "", recipients: [selectedEmail])
                }
                .alert(isPresented: $showMailError) {
                    Alert(title: Text("Error al intentar enviar el correo"),
                          message: Text("Asegúrese de tener una cuenta de correo configurada en el dispositivo."),
                          dismissButton: .default(Text("OK")))
                }
            }
            .padding()
        }
    }
    
    func mailto(_ email: String) {
        let mailto = "mailto:\(email)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(mailto ?? "")
        if let url = URL(string: mailto!) {
            openURL(url)
        }
    }
    
    func mailButton(
        email: String,
        action: (() -> ())?
    ) -> some View {
        Button {
            action?()
        } label: {
            Label(email, systemImage: "envelope.fill")
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    InfoView()
}


struct CustomEditor: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        UITextView()
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.isEditable = false
        uiView.font = .systemFont(ofSize: 16)
        uiView.dataDetectorTypes = .link
        uiView.backgroundColor = .clear
        uiView.textColor = .white
    }
}
