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
    let name = UserDefaults.standard.string(forKey: "nombre") ?? "User Name"
    
    @Binding var editor:Bool
    
    var body: some View {
        
        ZStack(alignment: .top) {
            (scheme == .dark ? Color.black : Color.white) // Ensure the ZStack has a background color
            
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        editor = true
                        // Add your action here
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title).foregroundColor(.blue)
                    }
                    //Añadí este frame para que el nombre de album quepa
                    .frame(width: 20, height: 20)
                }
                Text("@"+(name.replacingOccurrences(of: " ", with: "")) )
                    .font(.headline)
                
                Text(ProfileInfo.profileDescription)
                    .foregroundColor(.secondary)
                    .font(.body)
            }
            .padding(.leading, 24)
            .padding(.trailing, 24)
            .padding(.bottom, 24)
            .padding(.top, 24)
        }
        .edgesIgnoringSafeArea(.horizontal) // Extend the header to the screen edges
    }
}

struct ProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(lenguaje: .constant("es"))
    }
}
