//
//  FriendsList.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.


import SwiftUI
import SDWebImageSwiftUI
struct FriendsList: View {
    
    @Binding var amigos:[Amigo]
    @ObservedObject var uvm = UsuariosViewModel()
    @Binding var id_usuario:String
    @State var id_user_selected = ""
    @Binding var isActive:Bool
    
    @Binding var isFriend:Bool
    @Binding var isPinet:Bool
    @Binding var isPend:Bool
    
    @Binding var name:String
    @Binding var username:String
    @Binding var descrip:String
    @Binding var title:String
    @Binding var busqueda:Bool
    @Binding var imgPortadaAmigo:String
    let lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.title)
            }

            //ScrollView {
                LazyVStack(spacing: 16) {
                    // Display the list of friends here
                    ForEach(amigos, id: \.user_id) { friend in
                        
                        FriendRow(friend: friend, amigos: $amigos, uvm: uvm, busqueda: busqueda, isActive: $isActive, isFriend: $isFriend, isPinet: $isPinet, isPend: $isPend, name: $name, username: $username, descrip: $descrip, title: $title, imgPortadaAmigo: $imgPortadaAmigo, id_usuario: $id_usuario)
                    }
                }
            //}
        }
    }
}

struct FriendRow: View {
    let lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
    var friend: Amigo
    @Binding var amigos:[Amigo]
    @ObservedObject var uvm:UsuariosViewModel
    @State var mensaje = ""
    @State var isAlert = false
    @State var busqueda:Bool
    @Binding var isActive:Bool
    
    @Binding var isFriend:Bool
    @Binding var isPinet:Bool
    @Binding var isPend:Bool
    
    @Binding var name:String
    @Binding var username:String
    @Binding var descrip:String
    @Binding var title:String
    @Binding var imgPortadaAmigo:String
    @Binding var id_usuario:String
    var body: some View {
        HStack {
            
            Button(action: {
                print("ve al usuario")
                id_usuario = friend.user_id
                uvm.getUserPinetOrFriend(id_elseuser: friend.user_id) { result in
                    isFriend = result.frined
                    isPinet  = result.pinned
                    isPend = result.pend
                    isActive = true
                    name = friend.name
                    username = friend.username
                    descrip = friend.album_description
                    imgPortadaAmigo = friend.user_url
                }
                
            }, label: {
                WebImage(url: URL(string:friend.user_url))
                    .resizable()
                    .placeholder(Image("stickjoyLogo"))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(16)
            })
            
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name == "" ? friend.username : friend.name)
                    .font(.headline)
                Text(friend.username)
                    .font(.subheadline)
            }
            Spacer()
            if !busqueda {
                HStack(spacing: 16) {
                    Button(action: {
                        uvm.deleteFriend(friend_id: friend.user_id, responseReturn: { resp in
                            mensaje = resp.message
                            isAlert = true
                            uvm.getFriends(amigos: { amg in
                                amigos = amg
                            })
                        })
                    }) {
                        Text(lenguaje == "es" ? "Eliminar" : "Delete")
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding(.vertical, 10)
                        .padding (.horizontal, 8)
                        .background(.blue)
                        .cornerRadius(16)
                        .padding(.horizontal, 8)

                    }
                }
            }
            
        }
        .padding(.vertical, 8)
        .alert(isPresented: $isAlert, content: {
            Alert(title: Text(lenguaje == "es" ? "Mensaje" : "Message"), message: Text(mensaje))
        })
    }
}

struct FriendsList_Previews: PreviewProvider {
    static var previews: some View {
        FriendsScreen(lenguaje: .constant("es"))
    }
}
