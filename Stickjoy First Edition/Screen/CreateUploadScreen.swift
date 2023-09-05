//
//  CreateUploadScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 10/08/23.
//  Nombre en Lista de Requerimientos: 6. Pop Up Menu - Crear/Subir
//  Paulo: Este pop up se convirtió en pantalla por temas de tiempos y navegación.
//  ¿Qué falta?: Falta conectar para una navegación correcta, y que al dar click en el botón de crear album, se cree un album que se vea reflejado en perfil.

import SwiftUI

@available(iOS 16.0, *)
struct CreateUploadScreen: View {
    @ObservedObject var editorB = SetEditor()
    @ObservedObject var avm = AlbumViewModel()
    @State var isActive = false
    @State var isUploadPick = false
    @State var pickturesList = [String]()
    @State var id_album = ""
    @Binding var lenguaje:String
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 24) {
                Text(lenguaje == "es" ? "Crear / Subir" : "Create / Upload")
                    .font(.largeTitle)
                    .padding(32)
                    .bold()
                
                Spacer()
                
                //Botón de subir foto o video
                
                Button(action: {
                    // Debe mandar a pantalla ChooseAlbumScreen para elegir en qué álbum quiere subirlo
                    isUploadPick = true
                }) {
                    Text(lenguaje == "es" ? "Subir foto/video" : "Upload picture/video")
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
                    editorB.editor = true
                    editorB.nameAlbum = lenguaje == "es" ? "Nombre del Álbum" : "Album name"
                    editorB.descripAlbum = lenguaje == "es" ? "Bienvenid@ a mi nuevo álbum" : "Welcome to mi new album"
                    isActive = true
                }) {
                    Text(lenguaje == "es" ? "Crear un nuevo álbum" : "Create new album")
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
            .fullScreenCover(isPresented: $isActive, content: {
                NewAlbumScreen(isEdit: .constant(false), editor: $editorB.editor, nameAlbum: $editorB.nameAlbum, descripAlbum: $editorB.descripAlbum, id_albumSelected: $id_album, imgPortadaBind: $editorB.imgPortada, pickturesList: $avm.urlImagesAlbum)
            })
            .fullScreenCover(isPresented: $isUploadPick, onDismiss: {
                
            },content: {
                ChooseAlbumScreen(lenguaje: $lenguaje)
            })
        }
    }
}


struct CreateUploadScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateUploadScreen(lenguaje: .constant("es"))
    }
}
