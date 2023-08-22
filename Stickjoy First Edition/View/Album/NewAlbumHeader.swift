//
//  NewAlbumHeader.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//

import SwiftUI

struct NewAlbumHeader: View {
    //Adopción de Modo claro oscuro
    @Environment (\.colorScheme) var scheme
    

    
    var body: some View {
        ZStack(alignment: .top) {
            (scheme == .dark ? Color.black : Color.white)
            
            VStack(alignment: .leading, spacing: 8) {
                
                Image(ProfileInfo.profileImage) //En documento: ProfileInfo
                .resizable()
                .aspectRatio(contentMode: .fill)
            //Esto es para que al dar scroll se vaya la imagen y se quede el encabezado
                .frame(width: UIScreen.main.bounds.width, height: 250)
                .cornerRadius(2)
            //Esto es para que la imagen no se salga del header cuando se de scroll hacia arriba y tope. para eso es el "-" en offset
                
                //Layout de botones de regresar y editar
                HStack {
                    //Botón de regresar
                    Button(action: {
                        
                        // Add your action here
                        
                    }) {
                        Image(systemName: "arrow.backward.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    //Añadí este frame para que el nombre de album quepa
                    .frame(width: 20, height: 20)
                    
                    Spacer()
                    
                    //Botón para entrar a editor de album
                    Button(action: {
                        
                        // Add your action here
                        
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title)
                    }
                    //Añadí este frame para que el nombre de album quepa
                    .frame(width: 20, height: 20)
                }
                
                //Título de álbum
                
                HStack {
                    //Busca el título default del álbum
                    Text(DefaultAlbumContent.albumTitle)
                        .font(.title)
                        .bold()
                    Spacer()
                }
                
                //Muestra administrador del álbum
                Text("\(DefaultAlbumContent.albumAdministrator) is administrator")
                    .font(.headline)
                
                Text(DefaultAlbumContent.albumDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(24)
        }
        .edgesIgnoringSafeArea(.horizontal) // Extend the header to the screen edges
    }
}

struct NewAlbumHeader_Previews: PreviewProvider {
    static var previews: some View {
        NewAlbumHeader()
    }
}
