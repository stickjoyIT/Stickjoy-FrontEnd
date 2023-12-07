//
//  ProfileHeader.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 10/08/23.
//

import SwiftUI
import Combine

@available(iOS 16.0, *)
struct ProfileHeader: View {
    //Adopción de Modo claro oscuro
    @Environment (\.colorScheme) var scheme
    @Binding var name:String
    @Binding var username:String
    @Binding var description:String
    @Binding var editor:Bool
    let maxName = 20
    let maxDescrip = 250
    var body: some View {
        
        ZStack(alignment: .top) {
            (scheme == .dark ? Color.black : Color.white) // Ensure the ZStack has a background color
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if editor {
                        TextField(name, text: $name).font(.largeTitle)
                            .fontWeight(.bold)
                            .onReceive(Just(name)) { _ in limitText(maxName) }
                    } else {
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
                }
                Text((username.replacingOccurrences(of: " ", with: "")) )
                    .font(.headline)
                
                if editor {
                    TextField(description, text: $description)
                        .foregroundColor(.secondary)
                        .font(.body)
                        .onReceive(Just(description)) { _ in limitText(maxDescrip) }
                } else {
                    Text(description)
                        .foregroundColor(.secondary)
                        .font(.body)
                }
            }
            .padding(.leading, 24)
            .padding(.trailing, 24)
            .padding(.bottom, 24)
            .padding(.top, 24)
        }
        .edgesIgnoringSafeArea(.horizontal) // Extend the header to the screen edges
    }
    
    //Function to keep text length in limits
        func limitText(_ upper: Int) {
            if name.count > upper {
                name = String(name.prefix(upper))
            }
        }
    //Function to keep text length in limits
        func limitTextDesc(_ upper: Int) {
            if description.count > upper {
                description = String(description.prefix(upper))
            }
        }
}

