//
//  AdminPanelScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 11/08/23.
//  Nombre en Lista de Requerimientos: 14. Pop Up Menu - Panel de Admin
//  Paulo: Se convierte en pantalla en vez de Pop Up Menu. En este file, como tiene varias secciones, las puse aquí para no hacer muchos files. Recordar que esta pantalla solo es para los administradores del álbum.
//  ¿Qué falta?: Falta conectar con información real. La información que se necesita conectar está separada y ahí se indica en cada una. Borrar colaborador, y botón de invitar colaboradores que te lleve a InviteCollaboratorsScreen.swift.
//  Nota Importante: recomiendo que toda la info del álbum, esté guardada en el File Model/Album Info/AlbumContent.swift.

import SwiftUI
import SDWebImageSwiftUI

struct AdminPanelScreen: View {
    @Environment (\.dismiss) var dismiss
    @ObservedObject var avm:AlbumViewModel
    @ObservedObject var uvm:UsuariosViewModel
    @State var showColaboradores = false
    @Binding var id_album:String
    @Binding var lenguaje:String
    @State var album_info = AlbumInfo(id: "", albumTitle: "", albumImage: "", albumAdministrator: "", albumCreation: "", albumUpdate: "", albumType: "", albumParticipants: "", albumPrivacy: 0, id_album: "", owner_id: "", description: "", userOwner: "", isCollap: false)
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.left.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title)
                })
                Spacer()
                Text(lenguaje == "es" ? "Panel de administrador" : "Admin Panel")
                    .font(.title)
                    .bold()
                .padding(.horizontal)
                Spacer()
            }.padding()
            
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    
                    //Este VStack es para que esto esté leading y el título centered.
                    VStack(alignment: .leading){
                        
                        //Esto está en este mismo código, abajo.
                        AlbumInfoSection(albumInfo: $album_info, lenguaje: $lenguaje)
                        
                        Divider()
                        
                        //Esto está en este mismo código, abajo.
                        CollaboratorsSection(uvm: uvm, colaboradores: $avm.colaboradores, lenguaje: $lenguaje, album_id: $id_album)
                        
                        Spacer()
                    }
                        
                        VStack(alignment: .center) {
                            Button(action: {
                                //Añadir acción, te lleva a InviteCollaboratorsScreen para añadir colaboradores.
                                showColaboradores = true
                            }) {
                                Text(lenguaje == "es" ? "Invitar colaboradores" : "Invite new collaborators")
                                    .foregroundColor(.black)
                                    .frame(width: 250)
                                    .padding()
                                    .background(Color.customYellow)
                                    .cornerRadius(32)
                            }
                            .padding()
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showColaboradores, content: {
                InviteCollaboratorsScreen(id_album: $id_album, uvm:uvm, avm: avm, lenguaje: $lenguaje, colaboradores: $avm.colaboradores)
            })
        }.onAppear{
            avm.getInfoAlbumPanel(id_album: id_album, albumInfo: { resp in
                album_info = resp
            })
        }
    }
}

struct AdminPanelScreen_Previews: PreviewProvider {
    static var previews: some View {
        AdminPanelScreen(avm:AlbumViewModel(), uvm: UsuariosViewModel(), id_album: .constant(""), lenguaje: .constant(""))
    }
}

// Sección de Información de Álbum
struct AlbumInfoSection: View {
    @Binding var albumInfo:AlbumInfo
    @Binding var lenguaje:String
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(lenguaje == "es" ? "Nombre del álbum:" : "Album Name:")
                //Aquí va nombre original del album
                Text(albumInfo.albumTitle)
                    .bold()
            }
            HStack {
                Text(lenguaje == "es" ? "Administrador del álbum:" : "Album Administrator:")
                //Aquí va nombre original del username
                Text(albumInfo.albumAdministrator)
                    .bold()
            }
            HStack{
                Text(lenguaje == "es" ? "Fecha de creación:" : "Album Creation:")
                //Aquí va fecha original de creación
                Text(albumInfo.albumCreation)
                    .bold()
            }
            HStack{
                Text(lenguaje == "es" ? "Última actualización:" : "Album Last Update:")
                //Aquí va la cantidad original de elementos
                Text(albumInfo.albumUpdate)
                    .bold()
            }
            HStack{
                Text(lenguaje == "es" ? "Tipo de álbum:" : "Album Type:")
                //Aquí va el tipo de privacidad real
                Text(albumInfo.albumType)
                    .bold()
            }
            HStack{
                Text(lenguaje == "es" ? "Privacidad de álbum:" : "Album Privacy:")
                //Aquí va el tipo de privacidad real
                switch albumInfo.albumPrivacy {
                case 0:
                    Text(lenguaje == "es" ? "Privado" : "Private")
                        .bold()
                case 1:
                    Text(lenguaje == "es" ? "Amigos" : "Friends")
                        .bold()
                case 2:
                    Text(lenguaje == "es" ? "Público" : "Public")
                        .bold()
                default:
                    Text("")
                        .bold()
                }
            }
            HStack{
                Text(lenguaje == "es" ? "Número de colaboradores:" : "Number of Collaborators:")
                //Aquí va el número real de colaboradores
                Text(albumInfo.albumParticipants)
                    .bold()
            }
        }
        .padding()
    }
}

//Sección de Colaboradores
struct CollaboratorsSection: View {
    @ObservedObject var uvm:UsuariosViewModel
    @Binding var colaboradores:[colaborador]
    @Binding var lenguaje:String
    @Binding var album_id:String
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(lenguaje == "es" ? "Colaboradores" : "Collaborators")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            // Este número de 5, es para datos dummies, debe llamar a los colaboradores reales.
            ForEach(colaboradores, id: \.id ) { colab in
                //Manda llamar a los colaboradores, está aquí abajo en el documento.
                CollaboratorRow(name: colab.name, url: colab.url, username: colab.username, user_id: colab.user_id, lenguaje: $lenguaje, uvm: uvm, album_id: $album_id, colaboradores: $colaboradores)
            }
        }
        .padding(.bottom)
    }
}




// Sección de colaboradores. Debe llamar de back, los colaboradores que son
struct CollaboratorRow: View {
    var name:String
    var url:String
    var username:String
    var user_id:String
    @Binding var lenguaje:String
    @State var leng = "es"
    @State var deleteA = false
    @ObservedObject var uvm:UsuariosViewModel
    @State var colab_id = ""
    @Binding var album_id:String
    @Binding var colaboradores:[colaborador]
    var body: some View {
        HStack {
            //Aquí debe llamar a la foto real del colaborador.
            WebImage(url: URL(string: url))
                .resizable()
                .placeholder(Image("stickjoyLogo"))
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                //Aquí debe llamar al colaborador real (Nombre de pila)
                Text(name)
                    .font(.headline)
                //Aquí debe llamar al colaborador real (Usuario)
                Text(username)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(leng == "es" ? "Eliminar" : "Delete") {
                colab_id = user_id
                deleteA = true
            }
            .padding(8)
            .background(.red)
            .foregroundColor(.white)
            .cornerRadius(32)
            .confirmationDialog(lenguaje == "es" ? "Eliminar colaborador" : "Delete", isPresented: $deleteA){
                Button(lenguaje == "es" ? "Eliminar" : "Delete", role: .destructive) {
                    uvm.deleteColaborator(album_id: album_id, colab_id: colab_id, responseData: { resp in
                        if resp.status == 200 {
                            if let index = colaboradores.firstIndex(where: {$0.user_id == colab_id}) {
                                colaboradores.remove(at: index)
                            }
                        }
                    })
                }
                Button(lenguaje == "es" ? "Cancelar" : "Cancel", role: .cancel) {
                }
            } message : {
                Text("¿Estás seguro de que quieres eliminar al colaborador?").font(.largeTitle)
            }
        }
        .padding(.horizontal)
        .onAppear{
            let lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
            leng = lenguaje
        }
    }
    
}



//Esta sección la pusp ChatGPT
struct FilledButtonStyle: ButtonStyle {
    
    let color: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
