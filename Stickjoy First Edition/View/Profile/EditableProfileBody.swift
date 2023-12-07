//
//  EditableProfileBody.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 15/08/23.
//

import SwiftUI

struct EditableProfileBody: View {
    
    var albumsinfo: AlbumInfo
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 16, content: {
                
                Text(albumsinfo.albumTitle)
                    .font(.title)
                    .bold()
                
                ZStack(alignment: .topTrailing) {
                    Image(albumsinfo.albumImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 350, height: 250)
                        .cornerRadius(24)
                    
                    Button(action: {
                        // Este botón debe abrir el Pop Up Menu - Eliminar Album
                    }) {
                        Image(systemName: "x.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    .padding(8)
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
    }
}

@available(iOS 16.0, *)
struct EditableProfileBody_Previews: PreviewProvider {
    static var previews: some View {
        EditableProfileScreen()
    }
}
