//
//  NewFeedBody.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Este archivo es el body de EmptyFeedScreen

import SwiftUI

struct EmptyFeedBody: View {
    var body: some View {
        ZStack (alignment: .top){
            VStack(alignment: .center, spacing: 18) {
                Text("¡Hey!")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                
                Text("You are now on Feed")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Text("Here you'll see:")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Text("Photos and videos from your friends' albums ('public' and 'friends only')")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text("Photos and videos from albums you've collaborated in")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text("If the most cherished corner of memories is our mind, why not create a real refuge for them?")
                    .bold()
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Start by creating albums and following your friends!")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 16)
            .frame(width: .infinity)
        }
    }
}

struct EmptyFeedBody_Previews: PreviewProvider {
    static var previews: some View {
        EmptyFeedBody()
    }
}
