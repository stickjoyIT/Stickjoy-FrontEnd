//
//  ElsesProfileHeader.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Paulo: Este es el header de perfil ajeno. El botón de Add tiene 3 variantes: Add, Pending y Friend. El de friend no está porque depende de back (es tu amigo o no). Dtm, el diseño lo pongo en comentario más abajo.

import SwiftUI
import Firebase
struct ElsesProfileHeader: View {
    @State var ref: DatabaseReference!
    //Adopción de Modo claro oscuro
    @Environment (\.colorScheme) var scheme
    
    @ObservedObject var uvm = UsuariosViewModel()
    
    //Para que el botón de agregar o cancelar solicitud cambie de estado
    @Binding var isFriend:Bool
    
    //Para que el botón de anclar perfil cambie de estado. Debe leer si se ha anclado anteriormente el perfil, en este caso sería "true"
    @Binding var isPinned:Bool
    
    @Binding var pend:Bool
    
    @Binding var userInfo:ElsesProfileInfo
    
    @Binding var id_usuario:String
    
    @State var isSnack = false
    @State var message = ""
    
    @Binding var name:String
    @Binding var descrip:String
    @Binding var username:String
    @Binding var devicesSend:[String]
    @State var lenguaje = "es"
    
    @Environment (\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .leading) {
            (scheme == .dark ? Color.black : Color.white) // Ensure the ZStack has a background color
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 16) {
                    
                    //Botón para Regresar
                    Button(action: {
                        //Acción de regresar
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    //Botón para anclar perfil
                    Button(action: {
                        if isPinned {
                            uvm.unPinUser(id_usuario: id_usuario, responseReturn: { resp in
                                if resp.status == 200 {
                                    isPinned = false
                                    message = resp.message
                                    isSnack = true
                                } else {
                                    message = resp.message
                                    isSnack = false
                                }
                            })
                        } else {
                            uvm.pinUser(id_usuario: id_usuario, responseReturn: { resp in
                                if resp.status == 200 {
                                    isPinned = true
                                    message = resp.message
                                    isSnack = true
                                } else {
                                    message = resp.message
                                    isSnack = false
                                }
                            })
                        }
                        //Añadir acción de anclar perfil
                        uvm.getUserDetails(user_id: id_usuario, imgP: { img in
                            
                        })
                    }) {
                        Image(systemName: isPinned ? "pin.slash.fill" : "pin.fill")
                            .font(.title)
                            .foregroundColor(.secondary)
                    }
                    //Botón para entrar a editor de perfil
                    Button(action: {
                        if pend {
                            uvm.sendFriendReply(id_usuario: id_usuario, responseReturn: { resp in
                                if resp.status == 200 {
                                    pend = false
                                    isFriend = false
                                    message = lenguaje == "es" ? "Solicitud de amistad cancelada" : "Friend request canceled"
                                    isSnack = true
                                    
                                } else {
                                    message = resp.message
                                    isSnack = false
                                }
                            })
                        }
                        if isFriend{
                            uvm.deleteFriend(friend_id: id_usuario, responseReturn: { resp in
                                if resp.status == 200 {
                                    pend = false
                                    isFriend = false
                                    message = lenguaje == "es" ? resp.message : "Friend deleted"
                                    isSnack = true
                                } else {
                                    message = resp.message
                                    isSnack = false
                                }
                            })
                        } else {
                            uvm.sendFriendReq(id_usuario: id_usuario, responseReturn: { resp in
                                if resp.status == 200 {
                                    pend = true
                                    message = lenguaje == "es" ? "Tu solicitud de amistad se ha enviado" : "Your friend request has been sent"
                                    isSnack = true
                                    let userSend = UserDefaults.standard.string(forKey: "username") ?? ""
                                    sendPushNotification(titulo: "Solicitud de amistad", body: "\(userSend) te ha enviado una solicitud de amistad", devices: devicesSend)
                                    self.ref.child(id_usuario).setValue(["uuid": UUID().uuidString, "username": username, "evento":"invitar"])
                                } else {
                                    message = resp.message
                                    isSnack = false
                                }
                            })
                        }
                        // Add your action here
                    
                    }) {
                        if pend {
                            Image(systemName:"clock")
                                .foregroundColor(.black)
                                .font(.title3)
                            Text(lenguaje == "es" ? "Pendiente" : "Pend")
                                .foregroundColor(.black)
                                .font(.headline)
                        } else {
                            let add = lenguaje == "es" ? "Agregar" : "Add"
                            let del = lenguaje == "es" ? "Eliminar" : "Delete"
                            Image(systemName: isFriend ? "trash" : "person.badge.plus")
                                .foregroundColor(.black)
                                .font(.title3)
                            Text(isFriend ? del : add)
                                .foregroundColor(.black)
                                .font(.headline)
                        }
                        
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(isFriend ? Color.customYellow : Color.customBlue)
                    .cornerRadius(16)
                    
                    //Si es amigo el botón debe tener las siguiente caracterísitcas: Image(systemName: "check.mark.circle") del mismo tamaño que los que ya existen, y el texto diría Text("Friend")
                    
                }
                HStack {
                    Text(name)
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                Text(username.replacingOccurrences(of: " ", with: ""))
                    .font(.headline)
                
                Text(userInfo.profileDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(24)
        }
        .edgesIgnoringSafeArea(.horizontal) // Extend the header to the screen edges
        .alert(isPresented: $isSnack, content: {
            Alert(title: Text(lenguaje == "es" ? "Solicitud de amistad" : "Friend request"), message: Text(message))
        })
        .onAppear{
            self.ref = Database.database().reference()
            self.lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
        }
        .onDisappear{
            stopListening()
        }
    }
    
    func sendPushNotification(titulo:String, body:String, devices:[String]){
        for d in devices {
            uvm.sendNotificationPush(titulo: titulo, body: body, token: d)
        }
    }
    func stopListening() {
        let user_id = UserDefaults.standard.string(forKey: "id") ?? ""
        ref.child(user_id).removeAllObservers()
    }
}

/*struct ElsesProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ElsesProfileScreen(uvm: UsuariosViewModel(), id_usuario: .constant(""), isPinet: .constant(false), isFriend: .constant(false), pend: .constant(false), name: .constant(""), username: .constant(""), descrip: .constant(""), FriendAlbums: .constant([]), imgPortada: .constant(""))
    }
}*/
