//
//  TermsAndConditionsMenu.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Nombre en Lista de Requerimientos: 1. Pop Up Menu - Términos y Condiciones
//  Paulo: Este es el menú PopUp que tendrá los Términos, Condiciones de Uso y Políticas de Privacidad.
//  Paulo: La información que jalará este Menu, estará en el file: Model/TermsAndConditions

import SwiftUI

struct TermsAndConditionsMenu: View {
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
            
            // Añadir contenido
            
            Spacer()
        }
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}

struct TermsAndConditionsMenu_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditionsMenu(isPresented: .constant(true))
    }
}

