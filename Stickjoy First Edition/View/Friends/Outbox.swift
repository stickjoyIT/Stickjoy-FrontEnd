//
//  Outbox.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//

import SwiftUI

struct Outbox: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Outbox")
                .font(.title)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(outboxRequest) { request in
                        RequestRow(outboxRequests: request)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct RequestRow: View {
    var outboxRequests: Request
    
    var body: some View {
        switch outboxRequests.type {
        case let .friendRequestSent(profilename, username, image):
            friendRequestSentRow(profilename: profilename, username: username, image: image)
            
        case let .collaborationRequestSent(userInvited, albumName, image):
            collaborationRequestSentRow(userInvited: userInvited, albumName: albumName, image: image)
        }
    }
}

// Solicitudes de Amistad Enviadas
struct friendRequestSentRow: View {
    var profilename: String
    var username: String
    var image: String
    
    var body: some View {
        HStack {
            Button(action: {
                //la imagen de perfil debe llevarte a su perfil
            }) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(16)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("You sent a friend request to")
                    .font(.body) // Set the font size to caption
                Text("\(profilename)")
                    .font(.headline)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    
                }) {
                    Text("Cancel")
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

//Solicitudes de Colaboración a Álbum Enviadas
struct collaborationRequestSentRow: View {
    var userInvited: String
    var albumName: String
    var image: String
    
    var body: some View {
        HStack{
            Button(action: {
                //La imagen del perfil debe llevarte a su perfil
            }) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(16)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("You invited  \(userInvited) to")
                    .font(.body) // Set the font size to caption
                Text(albumName)
                    .font(.headline)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    
                }) {
                    Text("Cancel")
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
struct Outbox_Previews: PreviewProvider {
    static var previews: some View {
        FriendsScreen(lenguaje:.constant("es"))
    }
}
