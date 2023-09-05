//
//  FriendsScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Nombre en Lista de Requerimientos: 14. Pantalla de Amigos
//  Paulo:
//  ¿Qué falta?: Conectar con info real (Archivo: Model/ProfileInfo/ProfileInfo.swift) aquí no se conecta directamente, si no en los views que están en View/Profile/archivos.swift. Habilitar SearchBar. Acciones de cancelar, aceptar y borrar. Acción de meterese al perfil de las miniaturas de perfil.

import SwiftUI

struct FriendsScreen: View {
    @State private var friendsHeaderHeight: CGFloat = 0
    @ObservedObject var uvm = UsuariosViewModel()
    
    @State var textSearch = ""
    
    @State var isActive = false
    
    @State var id_usuario = ""
    
    @State var amigos = [Amigo]()
    
    @State var loading = false
    
    @State var nombre = ""
    @State var userName = ""
    @State var descrip = ""
    @Binding var lenguaje:String
    var body: some View {
        VStack() {
            
                FriendsHeader(textSearch: $textSearch, amigos: $amigos, loading: $loading)
                    .background()
                    .frame(height: 100)
            
            if loading {
                ProgressView()
            }
                
            if amigos.count == 0 && uvm.amigoListPin.count == 0 {
                    ScrollView {
                        EmptyFriendsScreen()
                    }
                } else {
                    NavigationView {
                        ZStack(alignment: .top) {
                            ScrollView {
                                VStack(spacing: 4) {
                                    // Add the horizontal grid of AnchoredProfileView
                                    Text(lenguaje == "es" ? "Perfiles anclados" : "Anchored Profiles")
                                        .font(.title)
                                if uvm.amigoListPin.count > 0 {
                                        ScrollView(.horizontal) {
                                            LazyHGrid(rows: [GridItem(.fixed(150))], spacing: 16) {
                                                ForEach(uvm.amigoListPin, id: \.id) { profile in
                                                    AnchoredProfiles(anchoredprofile: profile)
                                                }
                                            }
                                            .padding()
                                        }
                                    }
                                    if uvm.inboxList.count > 0 {
                                        // Add the InboxView section
                                        VStack(alignment: .leading) {
                                            Text(lenguaje == "es" ? "Inbox" : "Bandeja de entrada")
                                                .font(.title)
                                                .padding(.horizontal)
                                            ScrollView {
                                                LazyVStack(spacing: 16) {
                                                    ForEach(uvm.inboxList, id: \.id) { amigo in
                                                        HStack {
                                                            Button(action: {
                                                                //Al dar click en la imagen te debe llevar al perfil
                                                            }) {
                                                                Image("stickjoyLogoBlue")
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fill)
                                                                    .frame(width: 80, height: 80)
                                                                    .cornerRadius(16)
                                                            }
                                                            
                                                            VStack(alignment: .leading, spacing: 4) {
                                                                Text("\(amigo.name)")
                                                                    .font(.headline) // Set the font size to caption
                                                                Text(lenguaje == "es" ? "te mando una solicitud de amistad" : "sent you a friend request")
                                                                                    .font(.body)
                                                            }

                                                            Spacer()

                                                            HStack(spacing: 12) {
                                                                Button(action: {
                                                                    print(amigo.user_id)
                                                                    uvm.sendFriendAcept(id_usuario: amigo.user_id, responseReturn: { resp in
                                                                        uvm.getUserPineds()
                                                                        uvm.getUserOutList()
                                                                        uvm.getUserInBoxList()
                                                                    })
                                                                }) {
                                                                    Text(lenguaje == "es" ? "Aceptar" : "Accept")
                                                                    .font(.caption)
                                                                    .foregroundColor(.black)
                                                                    .padding(.vertical, 10)
                                                                    .padding (.horizontal, 8)
                                                                    .background(Color.customYellow)
                                                                    .cornerRadius(16)
                                                                }

                                                                Button(action: {
                                                                    uvm.sendFriendReply(id_usuario: amigo.user_id, responseReturn: { resp in
                                                                        uvm.getUserPineds()
                                                                        uvm.getUserOutList()
                                                                        uvm.getUserInBoxList()
                                                                    })
                                                                }) {
                                                                    Text(lenguaje == "es" ? "Cancelar" : "Cancel")
                                                                    .font(.caption)
                                                                    .foregroundColor(.black)
                                                                    .padding(.vertical, 10)
                                                                    .padding (.horizontal, 8)
                                                                    .background(Color.customBlue)
                                                                    .cornerRadius(16)
                                                                }
                                                            }
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
                                                .padding(.horizontal)
                                            ScrollView {
                                                LazyVStack(spacing: 16) {
                                                    ForEach(uvm.outList, id: \.id) { amigo in
                                                        HStack {
                                                            Button(action: {
                                                                //la imagen de perfil debe llevarte a su perfil
                                                            }) {
                                                                Image("stickjoyLogoBlue")
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fill)
                                                                    .frame(width: 80, height: 80)
                                                                    .cornerRadius(16)
                                                            }
                                                            
                                                            VStack(alignment: .leading, spacing: 4) {
                                                                Text(lenguaje == "es" ? "Enviaste una solicitud de amistad a" : "You sent a friend request to")
                                                                    .font(.body) // Set the font size to caption
                                                                Text("\(amigo.name)")
                                                                    .font(.headline)
                                                            }
                                                            
                                                            Spacer()
                                                            
                                                            HStack(spacing: 16) {
                                                                Button(action: {
                                                                    uvm.sendFriendReply(id_usuario: amigo.user_id, responseReturn: { resp in
                                                                        uvm.getUserPineds()
                                                                        uvm.getUserOutList()
                                                                        uvm.getUserInBoxList()
                                                                    })
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
                                                        .padding(.vertical, 8)
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                    
                                    //Add the FriendsListView section
                                    FriendsList(amigos: $amigos, id_usuario: $id_usuario, isActive: $isActive, isFriend: $uvm.isFriend, isPinet: $uvm.isPinet, isPend: $uvm.isPending, name: $uvm.name, username: $uvm.username, descrip: $uvm.descrip)
                                }.padding(.horizontal) // Adjust this value as needed to add spacing between the header and the sections
                            }.ignoresSafeArea(.all, edges: .top) // Ignore safe area from the top
                        }
                    }
                }
        }.fullScreenCover(isPresented: $isActive, onDismiss: {
            uvm.getUserPineds()
            uvm.getUserOutList()
            uvm.getUserInBoxList()
        },content: {
            ElsesProfileScreen(id_usuario: $id_usuario, isPinet: $uvm.isPinet, isFriend: $uvm.isFriend, pend:$uvm.isPending, name: $uvm.name, username: $uvm.username,  descrip: $uvm.descrip)
        }).onAppear{
            uvm.getUserPineds()
            uvm.getUserOutList()
            uvm.getUserInBoxList()
        }
    }
}

struct FriendsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FriendsScreen(lenguaje: .constant("es"))
    }
}
