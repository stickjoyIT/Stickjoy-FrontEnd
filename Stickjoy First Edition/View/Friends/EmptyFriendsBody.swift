//
//  NewFriendsBody.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Este archivo es el body de EmptyFriendsScreen

import SwiftUI

struct EmptyFriendsBody: View {
    var body: some View {
        ZStack(alignment: .top){
            VStack(alignment: .center, spacing: 16) {
                Text("¡Hey!")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                
                Text("You are now on Friends")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Text("Here you'll be able to:")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Text("Search for friends and look at your friends profiles")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text("See Inbox and Outbox requests")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text("Pin profiles you like")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                
                Text("The most precious moments come to life when we experience them through the eyes of those we love the most.")
                    .bold()
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Start by creating albums and following your friends!")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 8)
            .frame(width: .infinity)
        }
    }
}

struct EmptyFriendsBody_Previews: PreviewProvider {
    static var previews: some View {
        EmptyFriendsBody()
    }
}
