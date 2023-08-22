//
//  FriendsList.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.


import SwiftUI

struct FriendsList: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Friends List")
                    .font(.title)
                    .padding(.horizontal)

            }

            ScrollView {
                LazyVStack(spacing: 16) {
                    // Display the list of friends here
                    ForEach(friendslist) { friend in
                      FriendRow(friend: friend)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct FriendRow: View {
    var friend: friendsList

    var body: some View {
        HStack {
            Button(action: {
                //Al dar click en la imagen, te lleva a su perfil.
            }) {
                Image(friend.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(16)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.profilename)
                    .font(.headline)
                Text(friend.username)
                    .font(.subheadline)
            }

            Spacer()

            HStack(spacing: 16) {
                Button(action: {
                    
                }) {
                    Text("Delete")
                    .foregroundColor(.white)
                    .font(.caption)
                    .padding(.vertical, 10)
                    .padding (.horizontal, 8)
                    .background(.red)
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
        FriendsScreen()
    }
}
