//
//  LogOutMenu.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//  Nombre en Lista de Requerimientos: 4. Pop Up Menub - Cerrar Sesión
//  Paulo: Este popover si se pudo quedar como pop over.
//  ¿Qué falta?: que los botones realicen sus respectivas acciones. 

import SwiftUI

struct LogOutMenu: View {
    @Binding var isPresented: Bool // Binding to control the popover presentation
    
    var body: some View {
        VStack {
            Text("Log Out")
                .font(.headline)
                .padding(.vertical, 16)
            
            Text("Are you sure you want to log out?")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            HStack {
                Button("Confirm") {
                    // Cierra sesión y te lleva a LaunchScreen
                    isPresented = false
                }
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

struct LogOutMenu_Previews: PreviewProvider {
    static var previews: some View {
        LogOutMenu(isPresented: .constant(true))
            .frame(width: 300, height: 200)
    }
}
