//
//  ElsesProfileBody.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Paulo: este archivo manda a llamar al mismo file que ProfileScreen, en caso de que se requiera separar, copiar información y cambiar de nombres.

import SwiftUI

struct ElsesProfileBody: View {
    var elsesalbumsinfo: ElsesAlbumInfo
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 16, content: {
                
                Text(elsesalbumsinfo.albumTitle)
                    .font(.title)
                    .bold()
                
                //Botón de álbum para abrir la pantalla de álbum
                Button(action: {
                    
                    //Añadir acción de ir al álbum
                    
                }) {
                    Image(elsesalbumsinfo.albumImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 350, height: 250)
                        .cornerRadius(24)
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
                    
                    Text(elsesalbumsinfo.albumPrivacy)
                        .font(.footnote)
                }
            })
        }
        .frame(maxWidth: .infinity)
    }
}

struct ElsesProfileBody_Previews: PreviewProvider {
    static var previews: some View {
        ElsesProfileScreen()
    }
}
