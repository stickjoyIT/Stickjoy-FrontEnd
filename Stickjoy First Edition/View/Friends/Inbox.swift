//
//  Inbox.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//

import SwiftUI

struct Inbox: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Inbox")
                .font(.title)
                .padding(.horizontal)

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(inboxNotifications) { notification in
                        NotificationRow(notification: notification)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct NotificationRow: View {
    var notification: Notification

    var body: some View {
        switch notification.type {
        case let .friendRequest(profilename, username, image):
            FriendRequestRow(profilename: profilename, username: username, image: image)

        case let .collaborationRequest(albumAdmin, albumName, image):
            CollaborationRequestRow(albumAdmin: albumAdmin, albumName: albumName, image: image)
        }
    }
}

//Notificaciones de Solicitudes de Amistad Recibidas
struct FriendRequestRow: View {
    var profilename: String
    var username: String
    var image: String

    var body: some View {
        HStack {
            Button(action: {
                //Al dar click en la imagen te debe llevar al perfil
            }) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(16)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(profilename)")
                    .font(.headline) // Set the font size to caption
                    Text("sent you a friend request")
                                    .font(.body)
            }

            Spacer()

            HStack(spacing: 12) {
                Button(action: {
                    
                }) {
                    Text("Accept")
                    .font(.caption)
                    .foregroundColor(.black)
                    .padding(.vertical, 10)
                    .padding (.horizontal, 8)
                    .background(Color.customYellow)
                    .cornerRadius(16)
                }

                Button(action: {
                    
                }) {
                    Text("Cancel")
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

// Notificacione de Solicitud de Colaboración de Álbum Recibidas
struct CollaborationRequestRow: View {
    var albumAdmin: String
    var albumName: String
    var image: String

    var body: some View {
        HStack {
            Button(action: {
                //Al dar click en la imagen debe llevarte al perfil
            }){
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(16)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(albumAdmin) invited you to")
                    .font(.body) // Set the font size to caption
                    Text(albumName)
                                    .font(.headline)
            }

            Spacer()

            HStack(spacing: 12) {
                Button(action: {
                    
                }) {
                    Text("Accept")
                    .font(.caption)
                    .foregroundColor(.black)
                    .padding(.vertical, 10)
                    .padding (.horizontal, 8)
                    .background(Color.customYellow)
                    .cornerRadius(16)
                }

                Button(action: {
                    
                }) {
                    Text("Cancel")
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
struct Inbox_Previews: PreviewProvider {
    static var previews: some View {
        FriendsScreen(lenguaje: .constant("es"))
    }
}
