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
import SDWebImageSwiftUI
import Firebase

struct InviteCollaboratorsScreen: View {
    @Binding var id_album:String
    @Environment (\.dismiss) var dismiss
    @State var ref: DatabaseReference!
    @ObservedObject var uvm :UsuariosViewModel
    @ObservedObject var avm: AlbumViewModel
    @State var amigosList = [Amigo]()
    @State var inviteUser = [String]()
    @State var showSnackBar = false
    @State var mensaje = ""
    @State var id_user = ""
    @Binding var lenguaje:String
    @State var buscar = ""
    @Binding var colaboradores:[colaborador]
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Button(action: {
                    // Añadir ir hacia atrás. Te lleva de vuelta al AdminPanelScreen.
                    dismiss()
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                Text(lenguaje == "es" ? "Invitar colaboradores" : "Invite Collaborators")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    .onAppear{
                        
                    }
            }.padding()
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .padding(.leading, 8)
                TextField(lenguaje == "es" ? "Buscar" : "Search", text: $buscar, onCommit: {
                   
                })
                .foregroundColor(.primary)
                .padding(.horizontal, 8)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.search)
            }
            .textFieldStyle(.roundedBorder)
            .padding(8)
            ScrollView{
                VStack(alignment: .leading, spacing: 16) {
                    //if uvm.outList.count > 0 {
                        //Spacer()
                        Divider()
                        //Sección de Solicitudes pendientes.
                    Section(header: Text(lenguaje == "es" ? "Solicitudes pendientes" : "Pending requests")
                            .font(.title2)
                            .bold()
                        ) {
                            //Este texto manda a llamar el archivo ProfileInfo.Swift
                            ForEach(uvm.outList, id: \.id) { request in
                                InviteCollaboratorRow(avm:avm, uvm: uvm, name: request.name, isRequest: true, id_user: request.user_id, id_album:$id_album ,showSnackBar: $showSnackBar, mensaje: $mensaje, amigosList: $amigosList, urlImg: request.user_url, username: request.username )
                            }
                        }
                        Divider()
                    //}
                    //Sección de Lista de amigos.
                    Section(header: Text(lenguaje == "es" ? "Lista de amigos" : "Friends list")
                        .font(.title2)
                        .bold()
                    ) {
                        //Este texto manda a llamar el archivo ProfileInfo.Swift
                        ForEach(amigosList, id: \.id) { friend in
                            if !uvm.outList.contains(where: {$0.user_id == friend.user_id }) {
                                if !colaboradores.contains(where: {$0.user_id == friend.user_id}) {
                                    InviteCollaboratorRow(avm:avm, uvm: uvm, name: friend.name, isRequest: false, id_user: friend.user_id, id_album: $id_album, showSnackBar: $showSnackBar, mensaje: $mensaje, amigosList: $amigosList, urlImg: friend.user_url, username: friend.username)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .onAppear{
                    lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? ""
                }
                
            }.onAppear{
                self.ref = Database.database().reference()
                observedEvents()
            }.onDisappear{
                stopListening()
            }
        }.snackbar(isShowing: $showSnackBar, title: mensaje, style: .default)
    }
    func observedEvents(){
        stopListening()
        let user_id = UserDefaults.standard.string(forKey: "id") ?? ""
        ref.child(user_id).observe(.value){ snapshot in
            uvm.getUserOutList()
            uvm.getFriends(amigos: {fri in
                amigosList = fri
            })
        };
    }
    func stopListening() {
        let user_id = UserDefaults.standard.string(forKey: "id") ?? ""
        ref.child(user_id).removeAllObservers()
    }
}

struct InviteCollaboratorsScreen_Previews: PreviewProvider {
    static var previews: some View {
        InviteCollaboratorsScreen(id_album: .constant(""), uvm: UsuariosViewModel(), avm:AlbumViewModel(), lenguaje: .constant("es"), colaboradores: .constant([]))
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
    @State var ref: DatabaseReference!
    @ObservedObject var avm:AlbumViewModel
    @ObservedObject var uvm:UsuariosViewModel
    var name: String
    var isRequest: Bool
    var id_user:String
    @Binding var id_album:String
    @Binding var showSnackBar:Bool
    @Binding var mensaje:String
    @Binding var amigosList:[Amigo]
    @State var lenguaje = "es"
    var urlImg:String
    var username:String
    var body: some View {
        HStack {
            WebImage(url: URL(string: urlImg))
                .resizable()
                .placeholder(Image("stickjoyLogo"))
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            VStack(alignment: .leading) {
                //Este texto manda a llamar el archivo ProfileInfo.Swift
                Text(name)
                    .font(.headline)
                //Este texto manda a llamar el archivo ProfileInfo.Swift
                Text((username.replacingOccurrences(of: " ", with: "")))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if isRequest {
                Button(action: {
                    avm.acceptOrReplyColaboratingAlbum(album_id: id_album, user: id_user, accept: 0, responseData: { resp in
                      uvm.getUserOutList()
                        self.ref.child(id_user).setValue(["uuid": UUID().uuidString, "username": username, "evento":"cancelar"])
                    })
                }) {
                    Text("Cancelar")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(isRequest ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            } else {
                Button(action: {
                    avm.sendAlbumRequest(id_album:id_album , user: id_user, responseData: { resp in
                        showSnackBar = true
                        mensaje = resp.message
                        uvm.getUserOutList()
                        let userSend = UserDefaults.standard.string(forKey: "username") ?? ""
                        sendPushNotification(idUser: id_user, titulo: "Solicitud de colaboracion", body: "\(userSend) te invito a colaborar")
                        self.ref.child(id_user).setValue(["uuid": UUID().uuidString, "username": username, "evento":"invitar"])
                    })
                }) {
                    Text(lenguaje == "es" ? "Invitar" : "Invite")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(isRequest ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.vertical, 8)
        .onAppear{
            self.ref = Database.database().reference()
            self.lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
        }
    }
    
    func sendPushNotification(idUser:String, titulo:String, body:String){
        uvm.getDevicesUser(id_user: idUser, devices: { devices in
            for d in devices {
                uvm.sendNotificationPush(titulo: titulo, body: body, token: d)
            }
        })
    }
}
