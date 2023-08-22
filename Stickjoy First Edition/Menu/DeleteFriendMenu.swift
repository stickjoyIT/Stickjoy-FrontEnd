//
//  DeleteFriendMenu.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//  Nombre en Lista de Requerimientos: 17. Pop Up Menu - Eliminar Amigo
//  Paulo: Puede llamarse desde varios lados, lista de amigos, o perfiles de usuario ajenos.
//  ¿Qué falta?: Faltan las acciones del popover, y falta que pueda abrirse desde las pantallas.

import SwiftUI

struct DeleteFriendMenu: View {
    @Binding var isPresented: Bool // Binding to control the popover presentation
    
    var body: some View {
        VStack {
            Text("Delete Friend")
                .font(.headline)
                .padding(.vertical, 16)
            
            Text("Are you sure you want to delete @username?")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            HStack {
                Button("Delete", action: {
                    // Elimina amigo y cierra pop over 
                })
                .foregroundColor(.red)
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

struct DeleteFriendMenu_Previews: PreviewProvider {
    static var previews: some View {
        DeleteFriendMenu(isPresented: .constant(true))
            .frame(width: 300, height: 200)
    }
}
