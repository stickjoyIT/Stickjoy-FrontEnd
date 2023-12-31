//
//  ElsesProfileBody.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Paulo: este archivo manda a llamar al mismo file que ProfileScreen, en caso de que se requiera separar, copiar información y cambiar de nombres.

import SwiftUI
import SDWebImageSwiftUI

struct ElsesProfileBody: View {
    var elsesalbumsinfo: ElsesAlbumInfo
    @Binding var isActive:Bool
    @Binding var id_album:String
    @Binding var nameAlbum:String
    @Binding var descrip:String
    @Binding var imgPortada:String
    @Binding var lenguaje:String
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16, content: {
                
                Text(elsesalbumsinfo.albumTitle)
                    .font(.title)
                    .bold()
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                //Botón de álbum para abrir la pantalla de álbum
                Button(action: {
                    //Añadir acción de ir al álbum
                    
                    isActive = true
                    id_album = elsesalbumsinfo.id_album
                    nameAlbum = elsesalbumsinfo.albumTitle
                    descrip = elsesalbumsinfo.description
                    imgPortada = elsesalbumsinfo.albumImage
                    
                }) {
                    if elsesalbumsinfo.albumImage.isEmpty {
                        Image("stickjoyLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350, height: 250)
                            .cornerRadius(24)
                    } else {
                        AnimatedImage(url: URL(string: elsesalbumsinfo.albumImage))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350, height: 250)
                            .cornerRadius(24)
                    }
                    
                }
                
                Text(elsesalbumsinfo.albumAdministrator)
                    .font(.headline)
                
                //Creación y Actualización de Álbum
                HStack {
                    Text(elsesalbumsinfo.albumCreation)
                        .font(.callout)
                    
                    Text(elsesalbumsinfo.albumUpdate)
                        .font(.callout)
                }
                
                //Tipo, Participantes y Privacidad del álbum
                HStack {
                    
                    Text(elsesalbumsinfo.albumType)
                        .font(.footnote)
                    
                    Text("|")
                        .foregroundColor(.secondary)
                    
                    Text(elsesalbumsinfo.albumParticipants)
                        .font(.footnote)
                    
                    Text("|")
                        .foregroundColor(.secondary)
                    
                    switch elsesalbumsinfo.albumPrivacy {
                    case 0:
                        Text(lenguaje == "es" ? "Privado" : "Private")
                            .font(.footnote)
                    case 1:
                        Text(lenguaje == "es" ? "Amigos" : "Friends")
                            .font(.footnote)
                    case 2:
                        Text(lenguaje == "es" ? "Publico" : "Public")
                            .font(.footnote)
                    default:
                        Text("")
                            .font(.footnote)
                    }
                }
            })
        }
        .frame(maxWidth: .infinity)
    }
}
/*struct ElsesProfileBody_Previews: PreviewProvider {
    static var previews: some View {
       // ElsesProfileScreen(uvm: UsuariosViewModel(), id_usuario: .constant(""), isPinet: .constant(false), isFriend: .constant(false), pend: .constant(false), name: .constant(""), username: .constant(""), descrip: .constant(""), FriendAlbums: .constant([]), imgPortada: .constant(""))
    }
}*/
