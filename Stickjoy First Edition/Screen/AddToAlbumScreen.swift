//
//  AddToAlbumScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Nombre en Lista de Requerimientos: 12. Pop Up Menu - Agregar Al Album
//  Paulo: Este pop up menu se convierte en pantalla por temas de navegación.
//  ¿Qué falta?: Falta navegación de botones.

import SwiftUI

struct AddToAlbumScreen: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 24) {
                Text("Add / Upload")
                    .font(.largeTitle)
                
                Spacer()
                
                //Botón de subir foto o video
                Button(action: {
                    // Debe abrir un Image Picker de IOS para ver la biblioteca del dispositivo.
                }) {
                    Text("Upload picture/video")
                        .font(.headline)
                        .frame(width: 250)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.yellow)
                        .cornerRadius(8)
                }
                
                //Botón de agregar colaborador
                Button(action: {
                    //Debe llevarte a la pantalla "InviteCollaboratorsScreen.swift
                }) {
                    Text("Add Collaborators")
                        .font(.headline)
                        .frame(width: 250)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}


struct AddToAlbumScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddToAlbumScreen()
    }
}
