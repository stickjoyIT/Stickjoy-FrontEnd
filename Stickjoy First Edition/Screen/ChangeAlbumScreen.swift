//
//  ChangeAlbumScreen.swift
//  Stickjoy First Edition
//
//  Created by admin on 04/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChangeAlbumScreen: View {
    @Binding var lenguaje: String
    @Environment (\.colorScheme) var scheme
    @State var listaAlbums = [AlbumInfo]()
    @State var listAlbumsPrivate = [AlbumInfo]()
    @State var listAlbumsFriend = [AlbumInfo]()
    @State var listAlbumsPublic = [AlbumInfo]()
    @StateObject var stm = StorageManager()
    @Binding var albumSelection : AlbumSelectView
    @Binding var changeAlb:Bool
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button(action: {
                        changeAlb = false
                    }, label: {
                        Image(systemName: "chevron.left")
                        Text(lenguaje == "es" ? "Atras" : "Back")
                    })
                    Spacer()
                    Text(lenguaje == "es" ? "¿Dónde?" : "Where?")
                    Spacer()
                    Image("stickjoyLogo")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(32)
                }
                
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
                            AlbumItemListC(listaAlbums: listAlbumsPrivate, albumSelection: $albumSelection, change_al: $changeAlb)
                        }
                        if listAlbumsFriend.count > 0 {
                            Text(lenguaje == "es" ? "Solo amigos" : "Just friends")
                                .font(.title)
                                .foregroundColor(Color(hex: "#7c7c7c"))
                            Text(lenguaje == "es" ? "Tú, tus amigos, tus colaboradores y sus amigos pueden verlo" : "You, your friends, your collaborators and their friends can see it")
                                .font(.body)
                                .foregroundColor(Color(hex: "919191"))
                            //Este elemento está en este mismo documento
                            AlbumItemListC(listaAlbums: listAlbumsFriend,albumSelection: $albumSelection, change_al: $changeAlb)
                                
                        }
                        if listAlbumsPublic.count > 0 {
                            Text(lenguaje == "es" ? "Públicos" : "Public")
                                .font(.title)
                                .foregroundColor(Color(hex: "#7c7c7c"))
                            Text(lenguaje == "es" ? "Quien sea puede verlo" : "Anyone can see it")
                                .font(.body)
                                .foregroundColor(Color(hex: "919191"))
                            //Este elemento está en este mismo documento
                            AlbumItemListC(listaAlbums: listAlbumsPublic, albumSelection: $albumSelection, change_al: $changeAlb)
                        }
                    }
                    .padding()
                }
            }.padding(16)
            Spacer()
        }
        .background(scheme == .dark ? .black : Color(hex: "f0f3f3"))
        .onAppear{
            stm.getAlbumList(compation: { resp in
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
        .onDisappear {
            listAlbumsPrivate = []
            listAlbumsFriend = []
            listAlbumsPublic = []
        }
    }
}

struct ChangeAlbumScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChangeAlbumScreen(lenguaje: .constant("en"), albumSelection: .constant(AlbumSelectView(id_album: "", name: "", descrip: "", url: "", userName: "")), changeAlb: .constant(false))
    }
}

//Esta es la lista, hace la llamada desde el file: AlbumInfo en la carpeta Model.
struct AlbumItemListC: View {
    var listaAlbums:[AlbumInfo]
    @Binding var albumSelection:AlbumSelectView
    @Binding var change_al:Bool
    @Environment (\.colorScheme) var scheme
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(listaAlbums) { album in
                AlbumItemRowC(album: album)
                    .background(scheme == .dark ? .gray : .white)
                    .cornerRadius(18)
                    .onTapGesture {
                        change_al = false
                        albumSelection = AlbumSelectView(id_album: album.id_album, name: album.albumTitle, descrip: album.description, url: album.albumImage, userName: album.userOwner)
                    }
            }
        }
        //.padding(.horizontal)
    }
}

struct AlbumItemRowC: View {
    var  album: AlbumInfo
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
        
    }
}
