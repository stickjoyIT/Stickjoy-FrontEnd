//
//  ElsesProfileScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Nombre en Lista de Requerimientos: 15. Pantalla de Perfil Ajeno
//  Paulo: Esta pantalla es igual que perfil, solo cambian los botones de atrás, pin profile y agregar a amigos. El botón de add tiene 3 estados: Add, Pending, y Friend. La variante Friend está en ElseProfileHeader.swift en forma de comentario.
//  ¿Qué falta?: Conectar botón de regresar, el de anclar, el de Add, Pending, Friend. Falta conectar info. Las imagenes de los álbumes ya son botones, falta conectar para ingresar a cada álbum. 

import SwiftUI

struct ElsesProfileScreen: View {
    //Esto se manda a llamar para que la imagen del encabezado ignore las safe areas de arriba
    @StateObject var homeData = ElsesProfileViewModel()
    
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
                        Image(ElsesProfileInfo.profileImage) //En documento: ProfileInfo
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
                Section(header: ElsesProfileHeader()) {
                    //For each para que aparezcan los álbumes del usuario
                    ForEach(elsesalbumsinfo){elsesalbums in
                        // El albums se repite aquí:
                        ElsesProfileBody(elsesalbumsinfo: elsesalbums)
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

struct ElsesProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ElsesProfileScreen()
    }
}
