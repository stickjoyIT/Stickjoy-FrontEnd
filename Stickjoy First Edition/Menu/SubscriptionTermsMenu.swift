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
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Close") {
                    isPresented = false
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Text("Terms and Conditions")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            // Add your content here
            
            Spacer()
        }
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}

struct SubscriptionTermsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionTermsMenu(isPresented: .constant(true))
    }
}

