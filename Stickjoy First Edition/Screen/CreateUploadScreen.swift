//
//  CreateUploadScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 10/08/23.
//  Nombre en Lista de Requerimientos: 6. Pop Up Menu - Crear/Subir
//  Paulo: Este pop up se convirtió en pantalla por temas de tiempos y navegación.
//  ¿Qué falta?: Falta conectar para una navegación correcta, y que al dar click en el botón de crear album, se cree un album que se vea reflejado en perfil.

import SwiftUI

struct CreateUploadScreen: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 24) {
                Text("Create / Upload")
                    .font(.largeTitle)
                    .padding(32)
                    .bold()
                
                Spacer()
                
                //Botón de subir foto o video
                
                Button(action: {
                    // Debe mandar a pantalla ChooseAlbumScreen para elegir en qué álbum quiere subirlo
                }) {
                    Text("Upload picture/video")
                        .font(.headline)
                        .frame(width: 250)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.yellow)
                        .cornerRadius(8)
                }
                
                //Botón de crear álbum
                Button(action: {
                    //Debe crear un álbum y enviarte a esa pantalla.
                }) {
                    Text("Create new album")
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


struct CreateUploadScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateUploadScreen()
    }
}
