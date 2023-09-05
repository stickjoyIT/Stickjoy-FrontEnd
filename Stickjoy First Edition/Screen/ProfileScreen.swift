//
//  DefaultProfileScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Nombre de Lista de Requerimientos: 6. Pantalla de Perfil de Usuario
//  Paulo: scroll de albums. la info está conectada a carpeta: Model/Profile Info y su respectivo archivo.
//  ¿Qué falta?: Imagen de album te lleve a álbum, conectar botón de editar perfil, te debe llevar al AlbumScreen de ese album.


import SwiftUI
import SDWebImageSwiftUI

struct ProfileScreen: View {
    //Esto se manda a llamar para que la imagen del encabezado ignore las safe areas de arriba
    @StateObject var homeData = ProfileViewModel()
    @State var isActive = false
    @State var editorP = false
    @State var id_album = ""
    @State var changeUpdates = false
    @State var Albums = [AlbumInfo]()
    @ObservedObject var avm = AlbumViewModel()
    @ObservedObject var editorB = SetEditor()
    @Environment (\.colorScheme) var scheme
    @Environment (\.dismiss) var dismiss
    @Binding var lenguaje:String
    @State var pickturesList = [String]()
    var body: some View {
        
        ScrollView {
            //Header pinneado
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders], content: {
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
                        
                        ZStack(alignment:.top) {
                            Image(ProfileInfo.profileImage) //En documento: ProfileInfo
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        //Esto es para que al dar scroll se vaya la imagen y se quede el encabezado
                            .frame(width: UIScreen.main.bounds.width, height: 250 + (offset > 0 ? offset: 0))
                            .cornerRadius(2)
                        //Esto es para que la imagen no se salga del header cuando se de scroll hacia arriba y tope. para eso es el "-" en offset
                        .offset(y:(offset > 0 ? -offset: 0))

                        }
                    )
                }
                .frame(height: 250)
              // Albums
                Section(header: ProfileHeader(editor: $editorP)) {
                    //For each para que aparezcan los álbumes del usuario
                    if Albums.count > 0 {
                        ForEach(Albums){albums in
                            // El albums se repite aquí:
                            ProfileBody(albumsinfo: albums, albumName: $editorB.nameAlbum, albumDecripcion: $editorB.descripAlbum, imgPortada: $editorB.imgPortada, editor: $editorB.editor, albums: $Albums ).padding(.all, 10)
                        }
                    } else {
                        HStack {
                            Spacer()
                            VStack(alignment: .center, spacing: 10) {
                                Text(lenguaje == "es" ? "Crear un álbum" : "Create an Album")
                                Button(action: {
                                    editorB.editor = true
                                    editorB.nameAlbum = lenguaje == "es" ? "Nombre del Álbum" : "Album name"
                                    editorB.descripAlbum = lenguaje == "es" ? "Bienvenid@ a mi nuevo álbum" : "Welcome to my new album"
                                    isActive = true
                                }, label: {
                                   Text("+")
                                        .navigationBarBackButtonHidden(true)
                                            .frame(width: 150,height: 150)
                                            .background(.gray)
                                            .opacity(0.2)
                                            .cornerRadius(10)
                                })
                                .fullScreenCover(isPresented: $isActive, onDismiss: {
                                    print("Obten la lista de albums perfil")
                                }, content: {
                                    NewAlbumScreen(isEdit: .constant(false), editor: $editorB.editor, nameAlbum: $editorB.nameAlbum, descripAlbum: $editorB.descripAlbum, id_albumSelected: $id_album, imgPortadaBind: $editorB.imgPortada, pickturesList: $pickturesList)
                                })
                            }
                            Spacer()
                        }.padding(50)
                        
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
        ).onAppear{
            avm.getAlbumList(){
                result in
                Albums = result
            }
        }
    }
    
    
    
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(lenguaje:.constant("es"))
    }
}
