//
//  DefaultProfileScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 15/08/23.
//  Nombre en Lista de Requerimientos: 4. Pantalla de Perfil Default
//  Paulo: Así se vería la pantalla de Perfil con info default.
//  ¿Qué falta?: conexión a editor, y de botón de crear álbum que se encuentra en el file View/Profile/DefaultProfileBody.swift. 

import SwiftUI

struct DefaultProfileScreen: View {
    //Esto se manda a llamar para que la imagen del encabezado ignore las safe areas de arriba
    @StateObject var homeData = DefaultProfileViewModel()
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
                        Image(DefaultProfileInfo.profileImage)
                    //En file: Model/ProfileInfo/ProfileInfo.swift
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
                Section(header: DefaultProfileHeader()) {
                    //For each para que aparezcan los álbumes del usuario
                        DefaultProfileBody()
                    }
                })
        }
        .overlay(
            (scheme == .dark ? Color.black : Color.white)
            //Eliminé lo de windows que ya está deprecated en esta porque esta no lo necesita al parecer, porque no tiene scroll.
                .ignoresSafeArea(.container, edges: .top)
            //Esto es para que ignore la parte de arriba de la pantalla.
                .opacity(homeData.offset > 250 ? 1 : 0)
            , alignment: .top
        )
    }
}

struct DefaultProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        DefaultProfileScreen()
    }
}
