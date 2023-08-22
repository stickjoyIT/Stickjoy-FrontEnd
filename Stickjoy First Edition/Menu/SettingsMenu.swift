//
//  SettingsMenu.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//

import SwiftUI

struct SettingsMenu: View {
    @State private var isShowingLogOutConfirmation = false // Add this state variable

    var body: some View {
        VStack(spacing: 10) {
            Text("Settings")
                .font(.headline)
            
            Text("Notifications")
                .font(.subheadline)
            
            Button("Subscription") {
                // Implement the action for subscription button
            }
            .font(.subheadline)
            
            Button("Stickjoy Link") {
                // Implement the action for Stickjoy Link button
            }
            .font(.subheadline)
            
            Menu("Language") {
                Button("Español") {
                    // Implement the action for Español button
                }
                
                Button("English") {
                    // Implement the action for English button
                }
            }
            .font(.subheadline)
            
            Button("Terms and Conditions") {
                // Implement the action for Terms and Conditions button
            }
            .font(.subheadline)
            
            Button("Log out") {
                isShowingLogOutConfirmation = true // Show the confirmation
            }
            .font(.subheadline)
            
            Button("Delete account") {
                // Implement the action for Delete account button
            }
            .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .actionSheet(isPresented: $isShowingLogOutConfirmation) {
            ActionSheet(
                title: Text("Are you sure you want to log out?"),
                buttons: [
                    .default(Text("Cancel")),
                    .destructive(Text("Log Out"), action: {
                        // Implement the action to log out here
                    })
                ]
            )
        }
    }
}

struct SettingsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu()
    }
}
