//
//  ForgotMyPasswordMenu.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Nombre en Lista de Requerimientos: 2. Pop Up Menu - Olvidé mi Contraseña
//  Paulo: Aquí se despliega el proceso de recuperación de contraseña que no ha quedado concretado aún.
//  ¿Qué sigue?: Sigue colocar el proceso. 

import SwiftUI

struct ForgotMyPasswordMenu: View {
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
            
            Text("Forgot My Password")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            Spacer()
        }
        .padding(.vertical, 20)
        .background(.white)
        .cornerRadius(12)
        .shadow(radius: 10)
        
        //Aquí va proceso de recuperación de contraseña.
    }
}

struct ForgotMyPasswordMenu_Previews: PreviewProvider {
    static var previews: some View {
        ForgotMyPasswordMenu(isPresented: .constant(true))
    }
}
