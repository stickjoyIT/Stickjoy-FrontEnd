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
import UIKit

struct ChooseAlbumScreen: View {
    @Binding var rootIsActive:Bool
    @Environment (\.dismiss) var dismiss
    @State var lenguaje = "es"
    @State var listaAlbums = [AlbumInfo]()
    @State var listAlbumsPrivate = [AlbumInfo]()
    @State var listAlbumsFriend = [AlbumInfo]()
    @State var listAlbumsPublic = [AlbumInfo]()
    @StateObject var stm = StorageManager()
    @State var isShowingMediaPicker = false
    @State var isActiveSnack = false
    @State var id_album = ""
    @State var nameAlbum = ""
    @State var isUpload = false
    //@Binding var listElementsSelected:[ElementItem]
    @State var albumSelection = AlbumSelectView(id_album: "", name: "", descrip: "", url: "", userName: "")
    @Binding var proceso:Bool
    @Binding var porcentaje:Float
    @State var album_up = ""
    @State var items_up = 0
    @Binding var isActive:Bool
    @Environment (\.colorScheme) var scheme
    @Environment (\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            if scheme == .dark {
                Color.black.ignoresSafeArea()
            } else {
                Color(hex: "f0f3f3").ignoresSafeArea()
            }
            VStack {
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 16) {
                        //Título
                        if listAlbumsPrivate.count > 0 {
                            Text(lenguaje == "es" ? "Privados" : "Private")
                                .font(.title)
                                .foregroundColor(Color(hex: "#7c7c7c"))
                            Text(lenguaje == "es" ? "Solo tú y tus colaboradores pueden verlo" : "Just you and your collaboratos can see it")
                                .font(.body)
                                .foregroundColor(Color(hex: "919191"))
                            //Este elemento está en este mismo documento
                            AlbumItemList(/*stm: stm,*/ listaAlbums: listAlbumsPrivate, isShowingMediaPicker: $isShowingMediaPicker, isActiveSnack: $isActiveSnack, nameAlbum: $nameAlbum, id: $id_album, isUpload: $isUpload, albumSelection: $albumSelection)
                        }
                        if listAlbumsFriend.count > 0 {
                            Text(lenguaje == "es" ? "Solo amigos" : "Just friends")
                                .font(.title)
                                .foregroundColor(Color(hex: "#7c7c7c"))
                            Text(lenguaje == "es" ? "Tú, tus amigos, tus colaboradores y sus amigos pueden verlo" : "You, your friends, your collaborators and their friends can see it")
                                .font(.body)
                                .foregroundColor(Color(hex: "919191"))
                            //Este elemento está en este mismo documento
                            AlbumItemList(/*stm: stm,*/ listaAlbums: listAlbumsFriend, isShowingMediaPicker: $isShowingMediaPicker, isActiveSnack: $isActiveSnack, nameAlbum: $nameAlbum, id: $id_album, isUpload: $isUpload, albumSelection: $albumSelection)
                        }
                        if listAlbumsPublic.count > 0 {
                            Text(lenguaje == "es" ? "Públicos" : "Public")
                                .font(.title)
                                .foregroundColor(Color(hex: "#7c7c7c"))
                            Text(lenguaje == "es" ? "Quien sea puede verlo" : "Anyone can see it")
                                .font(.body)
                                .foregroundColor(Color(hex: "919191"))
                            //Este elemento está en este mismo documento
                            AlbumItemList(/*stm: stm,*/ listaAlbums: listAlbumsPublic, isShowingMediaPicker: $isShowingMediaPicker, isActiveSnack: $isActiveSnack, nameAlbum: $nameAlbum, id: $id_album, isUpload: $isUpload, albumSelection: $albumSelection)
                        }
                    }
                    .padding()
                }
                .navigationBarTitleDisplayMode(.inline)
                .onAppear{
                    rootIsActive = true
                    stm.getAlbumList(compation: { resp in
                        print("albumes: \(resp)")
                        for info in resp {
                            if info.albumPrivacy == 0 {
                                listAlbumsPrivate.append(info)
                            }
                            if info.albumPrivacy == 1 {
                                listAlbumsFriend.append(info)
                            }
                            if info.albumPrivacy == 2 {
                                listAlbumsPublic.append(info)
                            }
                            
                        }
                    }, responseData: { rep in
                        
                    })
                }
                .snackbar(isShowing: $isActiveSnack, title: "La imagen se agrego con exito al Álbum", style: .default)
                .onDisappear {
                    listAlbumsPrivate = []
                    listAlbumsFriend = []
                    listAlbumsPublic = []
                }
                if stm.listaImagenes.count == 0 {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        isActive = true
                    }, label: {
                        HStack {
                            Image(systemName: "photo")
                            Text(lenguaje == "es" ? "Crea nuevo álbum" : "Create new album")
                                .padding()
                            
                        }
                        .foregroundColor(scheme == .dark ? .black : .black)
                    })
                    .frame(maxWidth: 250)
                    .background(Color(hex: "#9dc3e6"))
                    .cornerRadius(18)
                    .padding(10)
                }
                
                NavigationLink(destination: MySelectionScreen(stm: stm, shouldPopToRootView: $rootIsActive, isAlbumRoot: .constant(false), albumSelected: albumSelection, proceso: $proceso, porcentaje: $porcentaje, album_up: $album_up, items_up: $items_up, isUpload: $isUpload), isActive: $isUpload) {
                    EmptyView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(lenguaje == "es" ? "¿Dónde?" : "Where?")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
               Button(action: {
                   presentationMode.wrappedValue.dismiss()
               }, label: {
                   HStack {
                       Image(systemName: "chevron.left")
                       Text(lenguaje == "es" ? "Atras" : "Back")
                   }
               })
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Image("stickjoyLogo")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(32)
            }
        }
        .onAppear{
            lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
        }
    }
}



//Esta es la lista, hace la llamada desde el file: AlbumInfo en la carpeta Model.
struct AlbumItemList: View {
    var listaAlbums:[AlbumInfo]
    @Binding var isShowingMediaPicker:Bool
    @Binding var isActiveSnack:Bool
    @Binding var nameAlbum:String
    @Binding var id:String
    @Binding var isUpload:Bool
    @Binding var albumSelection:AlbumSelectView
    @Environment (\.colorScheme) var scheme
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(listaAlbums) { album in
                AlbumItemRow(album: album, isUpload: $isUpload, isShowingMediaPicker: $isShowingMediaPicker, snack: $isActiveSnack, nameAlbum: $nameAlbum, id: $id, albumSelection: $albumSelection)
                    .background(scheme == .dark ? .gray : .white)
                    .cornerRadius(18)
            }
        }
        //.padding(.horizontal)
    }
}

//Este es el Item de cada álbum o miniatura de álbum con su CheckBox Toggle
//Paulo: falta que al seleccionar un checkbox se deseleccione otro, solo puede ser uno.
struct AlbumItemRow: View {
    var  album: AlbumInfo
    @Binding var isUpload:Bool
    @State private var isSelected = false
    @Binding var isShowingMediaPicker:Bool
    @Binding var snack:Bool
    @Binding var nameAlbum:String
    @Binding var id:String
    @State var urlsIV = ""
    @Binding var albumSelection:AlbumSelectView
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
            Image(systemName: "chevron.right")
        }
        .padding(.all, 8)
        .foregroundColor(.black)
        .onTapGesture {
            albumSelection = AlbumSelectView(id_album: album.id_album, name: album.albumTitle, descrip: album.description, url: album.albumImage, userName: album.userOwner)
            nameAlbum = album.albumTitle
            id = album.id_album
            isUpload = true
        }
        
    }
}
