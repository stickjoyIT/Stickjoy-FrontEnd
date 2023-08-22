//
//  UploadPictureOrVideoScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//  Nombre de Lista de Requerimientos: 10. Pop Up Menu - Subir Foto/Vídeo
//  Paulo: este pop up se hizo pantalla por cuestiones de navegación.
//  Falta añadir acciones a los botones (vienen en cada botón) y poner límite a los textfields. Además, que la foto que se muestra es la que el usuario eligió en el ImagePicker de IOS.
//  Opcional: si se puede hacer que el textfield de descripción sea de másd de 1 linea como en figma, estaría genial. Si no, dejar así y corregir en 2da versión.

import SwiftUI

struct UploadPictureOrVideoScreen: View {
    @State private var elementName = ""
    @State private var elementDescription = ""
    
    var body: some View {
        VStack {
            // Navigation Bar
            HStack {
                Button(action: {
                    // Añadir acción de regresar
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.title)
                }
                Spacer()
            }
            .padding()
            
            Text("Upload Picture or Video")
                .font(.title)
                .bold()
                .padding(.horizontal)
            
            //Aquí debe de ir la foto que se seleccionó en el ImagePicker de IOS.
            Image("uploadedPicture")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 200)
                .padding()
            //Nombre de elemento, falta poner descripción de 22 caractéres
            TextField("Name", text: $elementName)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 8)
            
            //Parrafo para descripción, falta poner límite de 250 caractéres.
            TextField("Description", text: $elementDescription)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 8)
            
            Button(action: {
                // Añadir acción de subir al álbum y llevarte a esa pantalla de álbum para verlo.
            }) {
                Text("Upload to my album")
                .foregroundColor(Color.white)
                .frame(width: 250)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(32)
            }
            
            Spacer()
        }
    }
}

struct UploadPictureOrVideoScreen_Previews: PreviewProvider {
    static var previews: some View {
        UploadPictureOrVideoScreen()
    }
}
