//
//  DeleteCollaboratorMenu.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//  Paulo: Este NO ESTÁ EN LISTA DE REQUERIMIENTOS. Sin embargo, al eliminar un colaborador no te pide confirmar la acción. si se puede conectar, adelante, si no, que lo elimine directamente. 

import SwiftUI

struct DeleteCollaboratorMenu: View {
    @Binding var isPresented: Bool // Binding to control the popover presentation
    
    var body: some View {
        VStack {
            Text("Delete Collaborator")
                .font(.headline)
                .padding(.vertical, 16)
            
            Text("Are you sure you want to delete @username from your album?")
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

struct DeleteCollaboratorMenu_Previews: PreviewProvider {
    static var previews: some View {
        DeleteCollaboratorMenu(isPresented: .constant(true))
            .frame(width: 300, height: 300)
    }
}
