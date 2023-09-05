//
//  SelectAlbumScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//  Nombre de Lista de Requerimientos: 7. Pop Up Menu - Elegir Álbum
//  Paulo: Este pop up, se convierte en pantalla por temas de navegación. Aquí el usuario elige en qué álbum subir su foto, y este file jala la información de AlbumInfo.swift en el folder Model.
//  ¿Qué falta?: llamar los álbumes reales. Fijar título, que se pueda seleccionar solo un álbum.


import SwiftUI
import SDWebImageSwiftUI
import MediaPicker

struct ChooseAlbumScreen: View {
    @Environment (\.dismiss) var dismiss
    @Binding var lenguaje:String
    @State var listaAlbums = [AlbumInfo]()
    @ObservedObject var avm = AlbumViewModel()
    @State var isShowingMediaPicker = false
    @State var isActiveSnack = false
    @State var id_album = ""
    @State var nameAlbum = ""
    
    var body: some View {
        ScrollView {
            
            HStack{
                
                // Botón de regresar
                Button(action: {
                    //Añadir acción de regresar a CreateUploadScreen
                    dismiss()
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
                Text(lenguaje == "es" ? "Selecciona un Álbum" : "Choose an Album")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                
                //Este elemento está en este mismo documento
                AlbumItemList(listaAlbums: $listaAlbums, isShowingMediaPicker: $isShowingMediaPicker, isActiveSnack: $isActiveSnack, nameAlbum: $nameAlbum, id: $id_album)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            avm.getAlbumList(compation: { resp in
                listaAlbums = resp
            })
        }.snackbar(isShowing: $isActiveSnack, title: "La imagen se agrego con exito al Álbum", style: .default)
    }
}

struct ChooseAlbumScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChooseAlbumScreen(lenguaje: .constant("es"))
    }
}


//Esta es la lista, hace la llamada desde el file: AlbumInfo en la carpeta Model.
struct AlbumItemList: View {
    @Binding var listaAlbums:[AlbumInfo]
    @Binding var isShowingMediaPicker:Bool
    @Binding var isActiveSnack:Bool
    @Binding var nameAlbum:String
    @Binding var id:String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach($listaAlbums) { album in
                AlbumItemRow(album: album, isShowingMediaPicker: $isShowingMediaPicker, snack: $isActiveSnack, nameAlbum: $nameAlbum, id: $id)
            }
        }
        .padding(.horizontal)
    }
}

//Este es el Item de cada álbum o miniatura de álbum con su CheckBox Toggle
//Paulo: falta que al seleccionar un checkbox se deseleccione otro, solo puede ser uno.
struct AlbumItemRow: View {
    @Binding var  album: AlbumInfo
    
    var storageManager = StorageManager()
    @ObservedObject var avm = AlbumViewModel()
    @State private var isSelected = false
    @Binding var isShowingMediaPicker:Bool
    @Binding var snack:Bool
    @Binding var nameAlbum:String
    @Binding var id:String
    var body: some View {
        HStack {
            if album.albumImage.isEmpty {
                Image("stickjoyLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .cornerRadius(12)
            } else {
                AnimatedImage(url: URL(string: album.albumImage))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .cornerRadius(12)
            }
            Text(album.albumTitle)
                .font(.headline)
            Spacer()
            Button(action: {
                isShowingMediaPicker = true
                nameAlbum = album.albumTitle
                id = album.id_album
            }, label: {
                Image(systemName: "plus")
            })
        }
        .padding(.vertical, 8)
        .mediaImporter(isPresented: $isShowingMediaPicker,
                       allowedMediaTypes: .all,
                       allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                print(nameAlbum, id)
                storageManager.upload(urls: urls, nameAlbum: nameAlbum){ success in
                    if success != "" {
                        avm.addMedia(urlImg: success, id_album: id, responseSuccess: { success in
                            
                        })
                        snack = true
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
