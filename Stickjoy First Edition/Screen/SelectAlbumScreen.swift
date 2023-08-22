//
//  SelectAlbumScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//  Nombre de Lista de Requerimientos: 7. Pop Up Menu - Elegir Álbum
//  Paulo: Este pop up, se convierte en pantalla por temas de navegación. Aquí el usuario elige en qué álbum subir su foto, y este file jala la información de AlbumInfo.swift en el folder Model.
//  ¿Qué falta?: llamar los álbumes reales. Fijar título, que se pueda seleccionar solo un álbum.


import SwiftUI

struct ChooseAlbumScreen: View {
    var body: some View {
        ScrollView {
            
            HStack{
                
                // Botón de regresar
                Button(action: {
                    //Añadir acción de regresar a CreateUploadScreen
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                .padding()
                Spacer()
            }
            
            VStack(alignment: .center, spacing: 16) {
                    
                //Título
                Text("Choose an Album")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                
                //Este elemento está en este mismo documento
                AlbumItemList()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChooseAlbumScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChooseAlbumScreen()
    }
}


//Esta es la lista, hace la llamada desde el file: AlbumInfo en la carpeta Model.
struct AlbumItemList: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(albumsinfo) { album in
                AlbumItemRow(album: album)
            }
        }
        .padding(.horizontal)
    }
}

//Este es el Item de cada álbum o miniatura de álbum con su CheckBox Toggle
//Paulo: falta que al seleccionar un checkbox se deseleccione otro, solo puede ser uno.
struct AlbumItemRow: View {
    var album: AlbumInfo
    
    @State private var isSelected = false
    
    var body: some View {
        HStack {
            Image(album.albumImage)
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(12)
            
            Text(album.albumTitle)
                .font(.headline)
            
            Spacer()
            
            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .onTapGesture {
                    isSelected.toggle()
                }
        }
        .padding(.vertical, 8)
    }
}
