//
//  DeletePictureOrVideoMenu.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//  Nombre en Lista de Requerimientos: 19. Pop Up Menu - Eliminar Foto/Video
//  Paulo: Este si se pudo dejar como pop over.
//  ¿Qué falta?: Acciones de los botones, como cerrar o borrar el elemento.

import SwiftUI

struct DeletePictureOrVideoMenu: View {
    @Binding var isPresented: Bool // Binding to control the popover presentation
    
    var body: some View {
        VStack {
            Text("Delete element")
                .font(.headline)
                .padding(.vertical, 16)
            
            Text("Are you sure you want to delete it?")
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

struct DeletePictureOrVideoMenu_Previews: PreviewProvider {
    static var previews: some View {
        DeletePictureOrVideoMenu(isPresented: .constant(true))
            .frame(width: 300, height: 200)
    }
}
