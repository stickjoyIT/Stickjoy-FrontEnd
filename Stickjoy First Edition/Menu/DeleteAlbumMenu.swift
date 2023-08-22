//
//  DeleteAlbumMenu.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 15/08/23.
//  Nombre en Lista de Requerimientos: 18. Pop Up Menu - Eliminar Álbum
//  Paulo: el popover debe verse encima de la pantalla en que se abra.
//  ¿Qué falta?: acciones de borrar o cerrar. Abrir desde pantallas correspondientes.

import SwiftUI

struct DeleteAlbumMenu: View {
    @Binding var isPresented: Bool // Binding to control the popover presentation
    
    //Esto es de donde agarrará el nombre del álbum. Cómo conectarlo a back?
    var albumTitle: String
    
    var body: some View {
        VStack {
            Text("Delete Album")
                .font(.headline)
                .padding(.vertical, 16)
            
            //Aquí se ve el "albumTitle" que es donde va el título real
            Text("Are you sure you want to delete the album '\(albumTitle)'?")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
            
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .padding()
                
                Button("Delete", action: {
                    // Añadir acción de eliminar el álbum y cerrar menu
                })
                .padding(8)
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}

struct DeleteAlbumMenu_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAlbumMenu(isPresented: .constant(true), albumTitle: "Sample Album")
            .frame(width: 300, height: 200)
    }
}
