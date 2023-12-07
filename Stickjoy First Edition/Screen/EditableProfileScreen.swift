//
//  EditableProfileScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Nombre en Lista de Requerimientos: 5. Pantalla de Edición de Perfil
//  Paulo: Esta pantalla es para editar el perfil. En este caso, hay álbumes, en otros caso
// ¿Qué falta?: falta que el botón de "x" en álbums abran el popover menu file: Menu/DeleteAlbumMenu.swift y que el sistema agregue cuales si se pueden eliminar y cuales no.

import SwiftUI

@available(iOS 16.0, *)
struct EditableProfileScreen: View {
    //DeleteAlbumMenu
    @State private var isDeleteAlbumMenuPresented = false

    //Encabezado que ignore las safe areas de arriba
    @StateObject var homeData = EditableProfileViewModel()
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
                        Image(ProfileInfo.profileImage)
                        //En file: Model/ProfileInfo/ProfileInfo.swift
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        //Este esfecto es para indicar que se puede editar
                            .overlay(Color.white.opacity(0.5))
                        //Esto es para fijar solo el encabezado y no la imagen
                            .frame(width: UIScreen.main.bounds.width, height: 250 + (offset > 0 ? offset: 0))
                            .cornerRadius(2)
                        //Esto es para que la imagen no se salga del header cuando se de scroll hacia arriba y tope. para eso es el "-" en offset
                            .offset(y:(offset > 0 ? -offset: 0))
                    )
                }
                .frame(height: 250)
                
                
                // Albums
                Section(header: EditableProfileHeader()) {
                    //For each para que aparezcan los álbumes del usuario
                    ForEach(albumsinfo){albums in
                        // El albums se repite aquí:
                        EditableProfileBody(albumsinfo: albums)
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

@available(iOS 16.0, *)
struct EditableProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditableProfileScreen()
    }
}
