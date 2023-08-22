//
//  ProfileHeader.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 10/08/23.
//  Encabezado de EditableProfileScreen

import SwiftUI

struct EditableProfileHeader: View {
    //Adopción de Modo claro oscuro
    @Environment (\.colorScheme) var scheme
    
    // Editable text fields
    @State private var editedProfileName: String = ProfileInfo.profileName
    @State private var editedProfileDescription: String = ProfileInfo.profileDescription
    
    var body: some View {
        ZStack(alignment: .leading) {
            (scheme == .dark ? Color.black : Color.white) // Ensure the ZStack has a background color
            
            VStack(alignment: .leading, spacing: 8) {
                
                //Layout de botones de guardar y cancelar
                HStack {
                    //Botón de guardar
                    Button(action: {
                        
                        // Add your action here
                        
                    }) {
                        Text("Save")
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title)
                    }
                    
                    Spacer()
                    //Botón de cancelar
                    Button(action: {
                        
                        // Add your action here
                        
                    }) {
                        Text("Cancel")
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                    }
                }
                
                HStack {
                    //Se convierte en text field
                    TextField("Profile Name", text: $editedProfileName)
                        .font(.largeTitle)
                        .bold()
                }
                Text(ProfileInfo.profileUsername)
                    .font(.headline)
                
                //Se convierte en text field
                TextField("Profile Description", text: $editedProfileDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(24)
        }
        .edgesIgnoringSafeArea(.horizontal) // Extend the header to the screen edges
    }
}

struct EditableProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        EditableProfileScreen()
    }
}
