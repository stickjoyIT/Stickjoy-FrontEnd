//
//  DefaultProfileHeader.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 15/08/23.
//

import SwiftUI

struct DefaultProfileHeader: View {
    //Adopción de Modo claro oscuro
    @Environment (\.colorScheme) var scheme
    
    var body: some View {
        ZStack(alignment: .leading) {
            (scheme == .dark ? Color.black : Color.white) // Ensure the ZStack has a background color
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(DefaultProfileInfo.profileName)
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
                //Este no es default porque para tener perfil, ya se tiene un nombre de usuario forzosamente.
                Text(ProfileInfo.profileUsername)
                    .font(.headline)
                
                Text(DefaultProfileInfo.profileDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(24)
        }
        .edgesIgnoringSafeArea(.horizontal) // Extend the header to the screen edges
    }
}

struct DefaultProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        DefaultProfileScreen()
    }
}
