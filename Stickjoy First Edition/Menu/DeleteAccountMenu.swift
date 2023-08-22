//
//  DeleteAccountMenu.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//  Nombre en lista de Requerimientos: 5. Pop Up Menu - Eliminar mi Cuenta
//  Paulo: esto es un popover, debe aparecer encima de la pantalla desde donde se llamó. 
//  ¿Qué falta?: conectar los botones para que realicen la acción de eliminar cuenta o cerrar popover.

import SwiftUI

struct DeleteAccountMenu: View {
    @Binding var isPresented: Bool // Binding to control the popover presentation
    
    var body: some View {
        VStack {
            Text("Delete Account")
                .font(.headline)
                .padding(.vertical, 16)
            
            Text("All the content you created on Stickjoy will be deleted. ")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            HStack {
                Button("Confirm", action: {
                    // Elimina cuenta y te lleva a LaunchScreen
                    isPresented = false
                })
                .padding()
                
                Button("Cancel", action: {
                    // Cierra pop over
                    isPresented = false
                })
                .padding(8)
                .foregroundColor(.accentColor)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}

struct DeleteAccountMenu_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountMenu(isPresented: .constant(true))
            .frame(width: 300, height: 200)
    }
}
