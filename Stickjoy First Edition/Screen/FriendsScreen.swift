//
//  FriendsScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Nombre en Lista de Requerimientos: 14. Pantalla de Amigos
//  Paulo:
//  ¿Qué falta?: Conectar con info real (Archivo: Model/ProfileInfo/ProfileInfo.swift) aquí no se conecta directamente, si no en los views que están en View/Profile/archivos.swift. Habilitar SearchBar. Acciones de cancelar, aceptar y borrar. Acción de meterese al perfil de las miniaturas de perfil.

import SwiftUI
import SDWebImageSwiftUI
import Firebase
struct FriendsScreen: View {
    @State private var friendsHeaderHeight: CGFloat = 0
    @ObservedObject var uvm = UsuariosViewModel()
    @ObservedObject var avm = AlbumViewModel()
    
    @State var textSearch = ""
    
    @State var isActive = false
    
    @State var id_usuario = ""
    
    @State var amigos = [Amigo]()
    
    @State var amigosSearch = [Amigo]()
    
    @State var loading = false
    
    @State var nombre = ""
    @State var userName = ""
    @State var descrip = ""
    
    @Binding var lenguaje:String
    
    @State var amigosTT = ""
    @State var amgSarch = ""
    @State var imgPortadaAmigo = ""
    @State var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    var body: some View {
        VStack() {
            FriendsHeader(textSearch: $textSearch, amigos: $amigosSearch, loading: $loading, lenguaje: $lenguaje)
                .background()
                .frame(height: 80)
                .padding(.top, 7)
            
            if loading {
                ProgressView()
            }
            
            if amigos.count == 0 && amigosSearch.count == 0 && uvm.amigoListPin.count == 0 && uvm.inboxList.count == 0 && uvm.outList.count == 0{
                    ScrollView {
                        EmptyFriendsScreen()
                    }
                } else {
                    NavigationView {
                        ZStack(alignment: .top) {
                            ScrollView {
                                if amigosSearch.count > 0 {
                                    //Add the FriendsListView section
                                    FriendsList(amigos: $amigosSearch, id_usuario: $id_usuario, isActive: $isActive, isFriend: $uvm.isFriend, isPinet: $uvm.isPinet, isPend: $uvm.isPending, name: $uvm.name, username: $uvm.username, descrip: $uvm.descrip, title: $amgSarch, busqueda: .constant(true), imgPortadaAmigo: $imgPortadaAmigo).padding()
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    // Add the horizontal grid of AnchoredProfileView
                                    if uvm.amigoListPin.count > 0 {
                                        Text(lenguaje == "es" ? "Perfiles anclados" : "Pinned Profiles")
                                            .font(.title)
                                        ScrollView(.horizontal) {
                                            LazyHGrid(rows: [GridItem(.fixed(160))], spacing: 16) {
                                                ForEach(uvm.amigoListPin, id: \.id) { profile in
                                                    Button(action: {
                                                        id_usuario = profile.user_id
                                                        uvm.getUserPinetOrFriend(id_elseuser: profile.user_id) { result in
                                                            print("mi friend",result)
                                                            print("mi usser",profile.user_id)
                                                            uvm.isFriend = result.frined
                                                            uvm.isPinet  = result.pinned
                                                            uvm.isPending = result.pend
                                                            isActive = true
                                                            uvm.name = profile.name
                                                            uvm.username = profile.username
                                                            uvm.descrip = profile.album_description
                                                            imgPortadaAmigo = profile.user_url
                                                        }
                                                    }, label: {
                                                        AnchoredProfiles(anchoredprofile: profile)
                                                    })
                                                }
                                            }
                                            .padding(.vertical, 10)
                                        }
                                    }
                                    if uvm.inboxList.count > 0 || uvm.inboxAlbums.count > 0 {
                                        // Add the InboxView section
                                        VStack(alignment: .leading) {
                                            Text(lenguaje == "es" ? "Solicitudes recibidas" : "Inbox" )
                                                .font(.title).padding(.vertical)
                                            ScrollView {
                                                LazyVStack(spacing: 16) {
                                                    ForEach(uvm.inboxList, id: \.id) { amigo in
                                                        HStack {
                                                            Button(action: {
                                                                //Al dar click en la imagen te debe llevar al perfil
                                                            }) {
                                                                WebImage(url: URL(string: amigo.user_url))
                                                                    .resizable()
                                                                    .placeholder(Image("stickjoyLogo"))
                                                                    .aspectRatio(contentMode: .fill)
                                                                    .frame(width: 80, height: 80)
                                                                    .cornerRadius(16)
                                                            }
                                                            VStack(alignment: .leading, spacing: 4) {
                                                                Text("\(amigo.username.replacingOccurrences(of: " ", with: ""))")
                                                                    .font(.headline) // Set the font size to caption
                                                                Text(lenguaje == "es" ? "te mando una solicitud de amistad" : "sent you a friend request").font(.body)
                                                                
                                                                HStack(spacing: 12) {
                                                                    Button(action: {
                                                                        print(amigo.user_id)
                                                                        uvm.sendFriendAcept(id_usuario: amigo.user_id, responseReturn: { resp in
                                                                            let username = UserDefaults.standard.string(forKey: "username") ?? ""
                                                                            sendPushNotification(idUser: amigo.user_id, titulo: "Solicitud de amistad", body: "\(username) acepto tu solicitud de amistad")
                                                                            uvm.getUserOutList()
                                                                            uvm.getUserInBoxList()
                                                                            uvm.getFriends(amigos: { amg in
                                                                                amigos = amg
                                                                            })
                                                                        })
                                                                    }) {
                                                                        Text(lenguaje == "es" ? "Aceptar" : "Accept")
                                                                            .frame(maxWidth: .infinity)
                                                                            .font(.caption)
                                                                            .foregroundColor(.black)
                                                                            .padding(.vertical, 10)
                                                                            .padding (.horizontal, 8)
                                                                            .background(Color.customYellow)
                                                                            .cornerRadius(16)
                                                                        
                                                                    }
                                                                    Button(action: {
                                                                        uvm.sendFriendReply(id_usuario: amigo.user_id, responseReturn: { resp in
                                                                            uvm.getUserOutList()
                                                                            uvm.getUserInBoxList()
                                                                        })
                                                                    }) {
                                                                        Text(lenguaje == "es" ? "Rechazar" : "Cancel")
                                                                            .frame(maxWidth: .infinity)
                                                                            .font(.caption)
                                                                            .foregroundColor(.black)
                                                                            .padding(.vertical, 10)
                                                                            .padding (.horizontal, 8)
                                                                            .background(Color.customBlue)
                                                                            .cornerRadius(16)
                                                                    }
                                                                }
                                                            }
                                                            Spacer()
                                                        }
                                                        .padding(.vertical, 4)
                                                    }
                                                }
                                            }
                                            ScrollView {
                                                LazyVStack(spacing: 16) {
                                                    ForEach(uvm.inboxAlbums, id: \.id) { album in
                                                        HStack {
                                                            Button(action: {
                                                                //Al dar click en la imagen te debe llevar al perfil
                                                            }) {
                                                                AsyncImage(url: URL(string: album.url)) {img in
                                                                    img
                                                                        .resizable()
                                                                        .aspectRatio(contentMode: .fill)
                                                                        .frame(width: 80, height: 80)
                                                                        .cornerRadius(16)
                                                                } placeholder: {
                                                                    Image("stickjoyLogoBlue")
                                                                        .resizable()
                                                                        .aspectRatio(contentMode: .fill)
                                                                        .frame(width: 80, height: 80)
                                                                        .cornerRadius(16)
                                                                }
                                                            }
                                                            VStack(alignment: .leading, spacing: 4) {
                                                                HStack {
                                                                    Text("\(album.owner_id.replacingOccurrences(of: " ", with: ""))")
                                                                        .font(.headline) // Set the font size to caption
                                                                    Text(lenguaje == "es" ? "te invitó a colaborar en" : "Invited you to")
                                                                        .font(.body)
                                                                    Text(album.name)
                                                                        .fontWeight(.bold)
                                                                }
                                                                HStack(spacing: 12) {
                                                                    Button(action: {
                                                                        avm.acceptOrReplyColaboratingAlbum(album_id: album.id_alb, user: album.user_id, accept: 1, responseData: {resp in
                                                                            let username = UserDefaults.standard.string(forKey: "username") ?? ""
                                                                            sendPushNotification(idUser: album.user_id, titulo: "Solicitud de amistad", body: "\(username) aceptó tu solicitud de colaboración")
                                                                            uvm.getUserInBoxList()
                                                                            uvm.getUserInBoxListAlbum()
                                                                            uvm.getFriends(amigos: { amg in
                                                                                amigos = amg
                                                                            })
                                                                            sendEvent(evento: "aceptar", username: "", id_user: album.user_id)
                                                                        })
                                                                    }) {
                                                                        Text(lenguaje == "es" ? "Aceptar" : "Accept")
                                                                            .frame(maxWidth:.infinity)
                                                                            .font(.caption)
                                                                            .foregroundColor(.black)
                                                                            .padding(.vertical, 10)
                                                                            .padding (.horizontal, 8)
                                                                            .background(Color.customYellow)
                                                                            .cornerRadius(16)
                                                                    }

                                                                    Button(action: {
                                                                        avm.acceptOrReplyColaboratingAlbum(album_id: album.id_alb, user: album.user_id, accept: 0, responseData: {resp in
                                                                            uvm.getUserInBoxList()
                                                                            uvm.getUserInBoxListAlbum()
                                                                            uvm.getFriends(amigos: { amg in
                                                                                amigos = amg
                                                                            })
                                                                            sendEvent(evento: "cancelar", username: "", id_user: album.user_id)
                                                                        })
                                                                    }) {
                                                                        Text(lenguaje == "es" ? "Rechazar" : "Cancel")
                                                                            .frame(maxWidth:.infinity)
                                                                            .font(.caption)
                                                                            .foregroundColor(.black)
                                                                            .padding(.vertical, 10)
                                                                            .padding (.horizontal, 8)
                                                                            .background(Color.customBlue)
                                                                            .cornerRadius(16)
                                                                    }
                                                                }
                                                            }

                                                            Spacer()
                                                        }
                                                        .padding(.vertical, 8)
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    if uvm.outList.count > 0 {
                                        //Add the OutboxView section
                                        VStack(alignment: .leading) {
                                            Text(lenguaje == "es" ? "Solicitudes enviadas" : "Outbox")
                                                .font(.title)
                                            ScrollView {
                                                LazyVStack(spacing: 16) {
                                                    ForEach(uvm.outList, id: \.id) { amigo in
                                                        HStack {
                                                            if amigo.album_id.isEmpty {
                                                                Button(action: {
                                                                    //la imagen de perfil debe llevarte a su perfil
                                                                }) {
                                                                    WebImage(url: URL(string:amigo.user_url))
                                                                        .resizable()
                                                                        .placeholder(Image("stickjoyLogo"))
                                                                        .aspectRatio(contentMode: .fill)
                                                                        .frame(width: 80, height: 80)
                                                                        .cornerRadius(16)
                                                                }
                                                            } else {
                                                                Button(action: {
                                                                    //la imagen de perfil debe llevarte a su perfil
                                                                }) {
                                                                    WebImage(url: URL(string:amigo.album_url))
                                                                        .resizable()
                                                                        .placeholder(Image("stickjoyLogo"))
                                                                        .aspectRatio(contentMode: .fill)
                                                                        .frame(width: 80, height: 80)
                                                                        .cornerRadius(16)
                                                                }
                                                            }
                                                            VStack(alignment: .leading, spacing: 4) {
                                                                if amigo.album_id.isEmpty {
                                                                    Text(lenguaje == "es" ? "Enviaste una solicitud de amistad a" : "You sent a friend request to")
                                                                        .font(.body) // Set the font size to caption
                                                                    Text("\(amigo.username.replacingOccurrences(of: " ", with: ""))")
                                                                        .font(.headline)
                                                                } else {
                                                                    Text(lenguaje == "es" ? "Invitaste a \(amigo.username) a " : "You invited \(amigo.username) to ")
                                                                        .font(.body) // Set the font size to caption
                                                                    Text("\(amigo.album_name)")
                                                                        .font(.headline)
                                                                }
                                                            }
                                                            Spacer()
                                                            HStack(spacing: 16) {
                                                                Button(action: {
                                                                    if amigo.album_id.isEmpty {
                                                                        uvm.sendFriendReply(id_usuario: amigo.user_id, responseReturn: { resp in
                                                                            //uvm.getUserPineds()
                                                                            uvm.getUserOutList()
                                                                            //uvm.getUserInBoxList()
                                                                        })
                                                                    } else {
                                                                        avm.acceptOrReplyColaboratingAlbum(album_id: amigo.album_id, user: amigo.user_id, accept: 0, responseData: { resp in
                                                                            uvm.getUserOutList()
                                                                        })
                                                                    }
                                                                }) {
                                                                    Text(lenguaje == "es" ? "Cancelar" : "Cancel")
                                                                        .foregroundColor(.black)
                                                                        .font(.caption)
                                                                        .padding(.vertical, 10)
                                                                        .padding (.horizontal, 8)
                                                                        .background(Color.customBlue)
                                                                        .cornerRadius(16)
                                                                        .padding(.horizontal, 8)
                                                                }
                                                            }
                                                        }
                                                        .padding(.vertical, 4)
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                    //Add the FriendsListView section
                                    FriendsList(amigos: $amigos, id_usuario: $id_usuario, isActive: $isActive, isFriend: $uvm.isFriend, isPinet: $uvm.isPinet, isPend: $uvm.isPending, name: $uvm.name, username: $uvm.username, descrip: $uvm.descrip, title: $amigosTT, busqueda: .constant(false), imgPortadaAmigo: $imgPortadaAmigo)
                                }.padding(.horizontal) // Adjust this value as needed to add spacing between the header and the sections
                            }.ignoresSafeArea(.all, edges: .top) // Ignore safe area from the top
                        }
                    }
                }
        }.fullScreenCover(isPresented: $isActive, onDismiss: {
            uvm.getUserPineds()
            uvm.getUserOutList()
            uvm.getUserInBoxList()
            uvm.getFriends(amigos: { amg in
                amigos = amg
            })
        },content: {
            ElsesProfileScreen(uvm: uvm, id_usuario: $id_usuario, isPinet: $uvm.isPinet, isFriend: $uvm.isFriend, pend:$uvm.isPending, name: $uvm.name, username: $uvm.username,  descrip: $uvm.descrip, FriendAlbums: $avm.albumsFriend, imgPortada: $imgPortadaAmigo, proceso: .constant(false), album_up: .constant(""), porcentaje:.constant(0.0), items_up:.constant(0))
        }).onAppear{
            amigosTT = lenguaje == "es" ? "Amigos" : "Friends"
            amgSarch = lenguaje == "es" ? "Buscar amigo" : "Search Friends"
            self.ref = Database.database().reference()
            observedEvents()
        }.onTapGesture{
            self.hideKeyboard()
        }
        .onDisappear{
            stopListening()
        }
    }
    
    func observedEvents(){
        stopListening()
        print("observa amigos")
        let user_id = UserDefaults.standard.string(forKey: "id") ?? ""
        ref.child(user_id).observe(.value){ snapshot in
            uvm.getUserPineds()
            uvm.getUserOutList()
            uvm.getUserInBoxList()
            uvm.getUserInBoxListAlbum()
            uvm.getFriends(amigos: { amg in
                amigos = amg
            })
        };
    }
    func stopListening() {
        let user_id = UserDefaults.standard.string(forKey: "id") ?? ""
        ref.child(user_id).removeAllObservers()
    }
    func sendEvent(evento:String, username:String, id_user:String){
        self.ref.child(id_user).setValue(["uuid": UUID().uuidString, "username": username, "evento":evento])
    }
    
    func sendPushNotification(idUser:String, titulo:String, body:String){
        uvm.getDevicesUser(id_user: idUser, devices: { devices in
            for d in devices {
                uvm.sendNotificationPush(titulo: titulo, body: body, token: d)
            }
        })
    }
}

struct FriendsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FriendsScreen(lenguaje: .constant("es"))
    }
}
