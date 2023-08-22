//
//  UserProfileScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//

import SwiftUI

struct UserProfileScreen: View {
    @State private var isEditingProfile = false // Add this state variable for profile editing
    
    var body: some View {
        VStack {
            if isEditingProfile {
                EditableProfileScreen(isPresented: $isEditingProfile) // Show the EditableProfileScreen when editing profile
            } else {
                Button(action: {
                    // Set the state variable to true when "Edit" button is tapped
                    isEditingProfile = true
                }) {
                    Text("Edit Profile")
                        .font(.largeTitle)
                }
                .foregroundColor(.blue)
                .padding(.top, 20)
            }
            
            Text("User Profile Screen")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // Other content of the profile screen
            
            Spacer()
        }
        .padding(.top, 20)
    }
}


struct UserProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileScreen()
    }
}
