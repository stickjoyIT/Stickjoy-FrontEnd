//
//  InviteCollaboratorsScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Nombre en Lista de Requerimientos: 16. Pop Up Menu - Invitiar Colaboradores
//  Paulo: Esta pantalla, la info esta conectada a ProfileInfo.Swift que es un archivo Foundation. 
//  ¿Qué falta?: Acción de botón de regresar. Conectar Search Bar con info. Acciones de invitar y cancelar. Que al invitar, el usuario pase a pendientes.
//  Nota Importante: recomiendo que toda la info del álbum, esté guardada en el File Model/Profile Info/ProfileInfo.swift.

import SwiftUI

struct InviteCollaboratorsScreen: View {
    
    @Binding var id_album:String
    @Environment (\.dismiss) var dismiss
    
    @ObservedObject var uvm = UsuariosViewModel()
    @State var amigosList = [Amigo]()
    @State var inviteUser = [String]()
    @State var showSnackBar = false
    @State var mensaje = ""
    @State var id_user = ""
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading, spacing: 16) {
                    Button(action: {
                        // Añadir ir hacia atrás. Te lleva de vuelta al AdminPanelScreen.
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.title)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        Spacer()
                    }
                    HStack(alignment: .center){
                        
                        Text("Invite Collaborators")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                    }
                    
                    SearchBarView(amigos: $amigosList)
                        .padding(.horizontal)
                    
                    if inviteUser.count > 0 {
                        Spacer()
                        Divider()
                        //Sección de Solicitudes pendientes.
                        Section(header: Text("Pending Requests")
                            .font(.title2)
                            .bold()
                                
                        ) {
                            //Este texto manda a llamar el archivo ProfileInfo.Swift
                            ForEach(ProfileFriendsAndRequests.pendingCollabRequests, id: \.self) { request in
                                InviteCollaboratorRow(name: request, isRequest: true, id_user: $id_user, id_album:$id_album ,showSnackBar: $showSnackBar, mensaje: $mensaje )
                            }
                        }
                        Divider()
                    }
                    
                    //Sección de Lista de amigos.
                    Section(header: Text("Friends List")
                        .font(.title2)
                        .bold()
                    ) {
                        //Este texto manda a llamar el archivo ProfileInfo.Swift
                        ForEach(amigosList, id: \.id) { friend in
                            InviteCollaboratorRow(name: friend.name, isRequest: false, id_user: .constant(friend.user_id), id_album: $id_album, showSnackBar: $showSnackBar, mensaje: $mensaje)
                        }
                    }
                    Spacer()
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .onAppear{
                    
                }
                .snackbar(isShowing: $showSnackBar, title: mensaje, style: .default)
            }
        }
    }
}

struct InviteCollaboratorsScreen_Previews: PreviewProvider {
    static var previews: some View {
        InviteCollaboratorsScreen(id_album: .constant(""))
    }
}

struct SearchBarView: View {
    @ObservedObject var uvm = UsuariosViewModel()
    @State private var searchText: String = ""
    @Binding var amigos:[Amigo]
    var body: some View {
        HStack {
            Image(systemName: "stickjoyLogoBlue")
                .foregroundColor(.gray)
            
            TextField("Search", text: $searchText, onCommit: {
                uvm.searchUser(search: searchText, compation:  { amiList in
                    amigos = amiList
                })
            })
                .foregroundColor(.black)
                
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct InviteCollaboratorRow: View {
    @ObservedObject var avm = AlbumViewModel()
    var name: String
    var isRequest: Bool
    @Binding var id_user:String
    @Binding var id_album:String
    @Binding var showSnackBar:Bool
    @Binding var mensaje:String
    var body: some View {
        HStack {
            Image("profilePicture")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                //Este texto manda a llamar el archivo ProfileInfo.Swift
                Text(name)
                    .font(.headline)
                //Este texto manda a llamar el archivo ProfileInfo.Swift
                Text("@"+(name.replacingOccurrences(of: " ", with: "")))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                avm.sendAlbumRequest(id_album:id_album , user: id_user, responseData: { resp in
                    
                    showSnackBar = true
                    mensaje = resp.message
                })
            }) {
                Text("Invite")
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(isRequest ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 8)
    }
}
