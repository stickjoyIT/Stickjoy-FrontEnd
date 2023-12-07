//
//  ElsesProfileScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Nombre en Lista de Requerimientos: 15. Pantalla de Perfil Ajeno
//  Paulo: Esta pantalla es igual que perfil, solo cambian los botones de atrás, pin profile y agregar a amigos. El botón de add tiene 3 estados: Add, Pending, y Friend. La variante Friend está en ElseProfileHeader.swift en forma de comentario.
//  ¿Qué falta?: Conectar botón de regresar, el de anclar, el de Add, Pending, Friend. Falta conectar info. Las imagenes de los álbumes ya son botones, falta conectar para ingresar a cada álbum. 

import SwiftUI
import SDWebImageSwiftUI

struct ElsesProfileScreen: View {
    //Esto se manda a llamar para que la imagen del encabezado ignore las safe areas de arriba
    @StateObject var homeData = ElsesProfileViewModel()
    @ObservedObject var uvm:UsuariosViewModel
    @State var isActiveViewAlbum = false
    @Binding var id_usuario:String
    @Binding var isPinet:Bool
    @Binding var isFriend:Bool
    @Binding var pend:Bool
    @Binding var name:String
    @Binding var username:String
    @Binding var descrip:String
    @Binding var FriendAlbums:[ElsesAlbumInfo]
    @State var id_album = ""
    @State var nameAlbum = ""
    @State var descripAlbum = ""
    @Binding var imgPortada:String
    @State var imgPortadaAlbum = ""
    @State var devicesSend = [String]()
    
    @ObservedObject var avm = AlbumViewModel()
    
    @State var isActive = false
    
    @Environment (\.colorScheme) var scheme
    @Binding var proceso : Bool
    @Binding var album_up : String
    @Binding var porcentaje : Float
    @Binding var items_up:Int
    @State var lenguaje = "es"
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
                        WebImage(url: URL(string: imgPortada))
                            .resizable()
                            .placeholder(Image("stickjoyLogo"))
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height: 250 + (offset > 0 ? offset: 0))
                            .cornerRadius(2)
                            .offset(y:(offset > 0 ? -offset: 0))
                    )
                }
                .frame(height: 200)
              // Albums
                Section(header: ElsesProfileHeader(scheme: _scheme, isFriend: $isFriend, isPinned: $isPinet, pend: $pend, userInfo: $uvm.UserElse, id_usuario: $id_usuario, name: $name, descrip: $descrip, username: $username, devicesSend: $devicesSend)) {
                    //For each para que aparezcan los álbumes del usuario
                    ForEach(FriendAlbums, id: \.id){elsesalbums in
                        // El albums se repite aquí:
                        ElsesProfileBody(elsesalbumsinfo: elsesalbums, isActive: $isActiveViewAlbum, id_album: $id_album, nameAlbum: $nameAlbum, descrip: $descripAlbum, imgPortada: $imgPortadaAlbum, lenguaje: $lenguaje)
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
                .opacity(homeData.offset > 200 ? 1 : 0)
            , alignment: .top
        )
        .onAppear{
            lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
            uvm.getUserDetails(user_id: id_usuario, imgP: { img in })
            avm.getAlbumListFriend(id_user: id_usuario, lenguaje:lenguaje, result: {
                resp in
                FriendAlbums = resp
            })
            uvm.getDevicesUser(id_user: id_usuario, devices: { devices in
                print("devices: ", devices)
                devicesSend = devices
            })
            
        }
        .fullScreenCover(isPresented: $isActiveViewAlbum, content: {
            ElsesAlbumScreen(avm: avm, id_album: $id_album, nameAlbum: $nameAlbum, descripAlbum: $descripAlbum, username: $username, imgPortada: $imgPortadaAlbum, id_user: $id_usuario, pickturesList: $avm.picktureList, iColaborator: .constant(false), proceso: $proceso, album_up: $album_up, porcentaje: $porcentaje, items_up: $items_up, isCollaborator: $isActiveViewAlbum)
        })
    }
}

/*struct ElsesProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ElsesProfileScreen(uvm: UsuariosViewModel(), id_usuario: .constant(""), isPinet: .constant(false), isFriend: .constant(false), pend: .constant(false), name: .constant(""), username: .constant(""), descrip: .constant(""), FriendAlbums: .constant([]), imgPortada: .constant(""))
    }
}*/
