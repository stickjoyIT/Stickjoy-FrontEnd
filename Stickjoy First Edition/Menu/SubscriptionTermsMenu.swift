//
//  SubscriptionTermsMenu.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Nombre en Lista de Requerimientos: 20. Pop Up Menu - Términos de Suscripción
//  Paulo: este si se pudo quedar como pop over.
//  ¿Qué falta?: Escribir terminos de suscricpión dentro que jala el archivo: Model/SubscriptionTerms.swift

import SwiftUI

struct SubscriptionTermsMenu: View {
    @Binding var isPresented: Bool // Add this binding
    @State var lenguaje = "es"
    var body: some View {
        VStack {
            HStack {
                Button {
                    isPresented = false
                } label : {
                    Image(systemName: "arrow.left.circle.fill")
                }
                .font(.title)
                .foregroundColor(.gray)
                //.padding(.horizontal, 10)
                //.padding(.top, 10)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Text(lenguaje == "es" ? "Términos de Suscripción" : "Subscription Terms")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            // Add your content here
            if lenguaje == "es" {
                SubscriptionTermsEspaniol().edgesIgnoringSafeArea(.all)
            } else {
                SubscriptionTermsIngles().edgesIgnoringSafeArea(.all)
            }
            
        }
        .padding(.vertical, 20)
        //.background(Color.white)
        .cornerRadius(12)
        //.shadow(radius: 10)
        .onAppear {
            lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
        }
    }
}

struct SubscriptionTermsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionTermsMenu(isPresented: .constant(true))
    }
}

struct SubscriptionTermsEspaniol:UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let story = UIStoryboard(name: "Politicas", bundle: Bundle.main)
        let controller = story.instantiateViewController(identifier: "politicasSuscrip")
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
//suscripEng

struct SubscriptionTermsIngles:UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let story = UIStoryboard(name: "Politicas", bundle: Bundle.main)
        let controller = story.instantiateViewController(identifier: "suscripEng")
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
