//
//  ProfileHeader.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 10/08/23.
//

import SwiftUI

struct ProfileHeader: View {
    //Adopción de Modo claro oscuro
    @Environment (\.colorScheme) var scheme

    var body: some View {
        ZStack(alignment: .leading) {
            (scheme == .dark ? Color.black : Color.white) // Ensure the ZStack has a background color
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(ProfileInfo.profileName)
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    
                    //Botón para entrar a editor de perfil
                    Button(action: {
                        
                        // Add your action here
                        
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title)
                    }
                }
                Text(ProfileInfo.profileUsername)
                    .font(.headline)
                
                Text(ProfileInfo.profileDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(24)
        }
        .edgesIgnoringSafeArea(.horizontal) // Extend the header to the screen edges
    }
}

struct ProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
