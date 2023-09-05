//
//  ProfileBody.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 15/08/23.

import SwiftUI
import SDWebImageSwiftUI

struct ProfileBody: View {
    var albumsinfo: AlbumInfo
    
    @ObservedObject var avm = AlbumViewModel()
    
    @Binding var albumName:String
    @Binding var albumDecripcion:String
    @Binding var imgPortada:String
    
    @Binding var editor:Bool
    @Binding var albums:[AlbumInfo]
    
    @State var isActive = false
    @State var pickturesList = [String]()
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 16, content: {
                
                Text(albumsinfo.albumTitle)
                    .font(.title)
                    .bold()
                
                //Botón de álbum para abrir la pantalla de álbum
                Button(action: {
                    avm.getAlbumDetail(idAlbum: albumsinfo.id_album, imagenes: { images in
                        pickturesList = images
                        //Añadir acción de ir al álbum
                        albumDecripcion = albumsinfo.description
                        albumName = albumsinfo.albumTitle
                        imgPortada = albumsinfo.albumImage
                        isActive = true
                    })
                }) {
                    if !albumsinfo.albumImage.isEmpty {
                        AnimatedImage(url: URL(string: albumsinfo.albumImage))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350, height: 250)
                            .cornerRadius(24)
                    } else {
                        Image("stickjoyLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350, height: 250)
                            .cornerRadius(24)
                    }
                    
                    /**/
                }
                
                Text(albumsinfo.albumAdministrator)
                    .font(.headline)
                //Creación y Actualización de Álbum
                HStack {
                    Text(albumsinfo.albumCreation)
                        .font(.callout)
                    
                    Text(albumsinfo.albumUpdate)
                        .font(.callout)
                }
                //Tipo, Participantes y Privacidad del álbum
                HStack {
                    Text(albumsinfo.albumType)
                        .font(.footnote)
                    
                    Text("|")
                        .foregroundColor(.secondary)
                    
                    Text(albumsinfo.albumParticipants)
                        .font(.footnote)
                    
                    Text("|")
                        .foregroundColor(.secondary)
                    switch albumsinfo.albumPrivacy {
                    case 0:
                        Text("Privado")
                            .font(.footnote)
                    case 1:
                        Text("Amigos")
                            .font(.footnote)
                    case 2:
                        Text("Publico")
                            .font(.footnote)
                    default:
                        Text("")
                            .font(.footnote)
                    }
                    
                }
            })
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 4)
        .fullScreenCover(isPresented: $isActive, onDismiss: {
            avm.getAlbumList(){ result in
                albums = result
            }
        }, content: {
            NewAlbumScreen(imgPortada:albumsinfo.albumImage ,id_album: albumsinfo.id_album, isEdit: .constant(true), editor: $editor, nameAlbum: $albumName,descripAlbum: $albumDecripcion, id_albumSelected: .constant(albumsinfo.id_album), imgPortadaBind: $imgPortada, pickturesList: $pickturesList)
        })
    }
}

struct ProfileBody_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(lenguaje: .constant("es"))
    }
}
