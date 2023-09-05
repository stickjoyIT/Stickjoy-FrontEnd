//
//  FriendsList.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.


import SwiftUI

struct FriendsList: View {
    
    @Binding var amigos:[Amigo]
    @ObservedObject var uvm = UsuariosViewModel()
    @Binding var id_usuario:String
    
    @Binding var isActive:Bool
    
    @Binding var isFriend:Bool
    @Binding var isPinet:Bool
    @Binding var isPend:Bool
    
    @Binding var name:String
    @Binding var username:String
    @Binding var descrip:String
    let lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(lenguaje == "es" ? "Amigos" : "Friends List")
                    .font(.title)
                    .padding(.horizontal)

            }

            ScrollView {
                LazyVStack(spacing: 16) {
                    // Display the list of friends here
                    ForEach(amigos, id: \.user_id) { friend in
                        
                        Button(action: {
                            id_usuario = friend.user_id
                            uvm.getUserPinetOrFriend(id_elseuser: friend.user_id) { result in
                                isFriend = result.frined
                                isPinet  = result.pinned
                                isPend = result.pend
                                isActive = true
                                name = friend.name
                                username = friend.username
                                descrip = friend.album_description
                            }
                            
                        }, label: {
                            FriendRow(friend: friend)
                        })
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct FriendRow: View {
    let lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
    var friend: Amigo

    var body: some View {
        HStack {
            Button(action: {
                //Al dar click en la imagen, te lleva a su perfil.
            }) {
                Image(friend.user_url.isEmpty ? "stickjoyLogoBlue" : friend.user_url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(16)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.headline)
                Text("@"+friend.username)
                    .font(.subheadline)
            }
            Spacer()

            HStack(spacing: 16) {
                Button(action: {
                    
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
        .padding(.vertical, 8)
    }
}

struct FriendsList_Previews: PreviewProvider {
    static var previews: some View {
        FriendsScreen(lenguaje: .constant("es"))
    }
}
