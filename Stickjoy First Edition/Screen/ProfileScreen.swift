//
//  DefaultProfileScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Nombre de Lista de Requerimientos: 6. Pantalla de Perfil de Usuario
//  Paulo: scroll de albums. la info está conectada a carpeta: Model/Profile Info y su respectivo archivo.
//  ¿Qué falta?: Imagen de album te lleve a álbum, conectar botón de editar perfil, te debe llevar al AlbumScreen de ese album.


import SwiftUI

struct ProfileScreen: View {
    //Esto se manda a llamar para que la imagen del encabezado ignore las safe areas de arriba
    @StateObject var homeData = ProfileViewModel()
    @Environment (\.colorScheme) var scheme
    
    var body: some View {
        ScrollView {
            
            //Header pinneado
            LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [.sectionHeaders], content: {
                
                //Imagen de Encabezado retractil al dar scroll
                GeometryReader{reader -> AnyView in
                    
                    let offset = reader.frame(in: .global).minY
                    
                    //Esto es para que ignore la parte de arriba de la pantalla.
                    if -offset >= 0{
                        DispatchQueue.main.async {
                            self.homeData.offset = -offset //Este "-" es para que cuando la imagen desaparezca, el header tome toda la parte posterior de la pantalla ignorando las safe areas.
                        }
                    }
                    
                    //Imagen de encabezado
                    return AnyView(
                        Image(ProfileInfo.profileImage) //En documento: ProfileInfo
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    //Esto es para que al dar scroll se vaya la imagen y se quede el encabezado
                        .frame(width: UIScreen.main.bounds.width, height: 250 + (offset > 0 ? offset: 0))
                        .cornerRadius(2)
                    //Esto es para que la imagen no se salga del header cuando se de scroll hacia arriba y tope. para eso es el "-" en offset
                        .offset(y:(offset > 0 ? -offset: 0))
                    )
                }
                .frame(height: 250)
                
                
              // Albums
                Section(header: ProfileHeader()) {
                    //For each para que aparezcan los álbumes del usuario
                    ForEach(albumsinfo){albums in
                        // El albums se repite aquí:
                        ProfileBody(albumsinfo: albums)
                    }
                }
                
                
            })
        }
        .overlay(
            (scheme == .dark ? Color.black : Color.white)
            //Esta parte no sé como cambiarla para que funcione igual
                .frame(height:UIApplication.shared.windows.first?.safeAreaInsets.top)
                .ignoresSafeArea(.container, edges: .top)
            //Esto es para que ignore la parte de arriba de la pantalla.
                .opacity(homeData.offset > 250 ? 1 : 0)
            , alignment: .top
        )
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
