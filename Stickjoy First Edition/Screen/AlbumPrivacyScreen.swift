//
//  AlbumPrivacyScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//  Nombre en Lista de Requerimientos: 13. Pop Up Menu - Privacidad del Álbum
//  Paulo: se convierte en pantalla por temas de navegación.
//  ¿Qué falta?: Falta que haya un estado de privacidad seleccionado, y que sea el último elegido por el usuario. Falta que al dar save, se guarden los cambios. Falta que el private, sea el botón default. Falta que Save guarde cambios. No tiene de back porque entras desde un tab. 
//  Nota Importante: recomiendo que toda la info del álbum, esté guardada en el File Model/Album Info/AlbumContent.swift.

import SwiftUI

struct AlbumPrivacyScreen: View {
    @State private var selectedPrivacy: PrivacyOption?
    
    enum PrivacyOption: String {
        case privateAlbum = "Private"
        case publicAlbum = "Public"
        case justFriendsAlbum = "Just Friends"
    }
    
    var body: some View {
            VStack(alignment: .center, spacing: 16) {
                Text("Album Privacy")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Spacer()
                
                PrivacyOptionsView(selectedPrivacy: $selectedPrivacy)
                
                Spacer()
                
                Button(action: {
                    // Añadir acción de guardar cambios.
                }) {
                    Text("Save")
                    .frame(width: 250)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)                }
                
            }
            .padding(.vertical, 16)
        }
    }


struct AlbumPrivacyScreen_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPrivacyScreen()
    }
}

struct PrivacyOptionsView: View {
    @Binding var selectedPrivacy: AlbumPrivacyScreen.PrivacyOption?
    
    var body: some View {
        VStack(spacing: 24) {
            PrivacyOptionButton(option: .privateAlbum, selectedPrivacy: $selectedPrivacy)
            
            Text("Private: Only you and your collaborators can see it.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            PrivacyOptionButton(option: .publicAlbum, selectedPrivacy: $selectedPrivacy)
            
            Text("Just friends: Only you, your friends, your collaborators, and your collaborator's friends can see it.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            
            PrivacyOptionButton(option: .justFriendsAlbum, selectedPrivacy: $selectedPrivacy)
            
            Text("Public: Everyone can see it.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

        }
        .padding(.horizontal)
    }
}

struct PrivacyOptionButton: View {
    var option: AlbumPrivacyScreen.PrivacyOption
    @Binding var selectedPrivacy: AlbumPrivacyScreen.PrivacyOption?
    
    var body: some View {
        Button(action: {
            selectedPrivacy = option
        }) {
            VStack(spacing: 4) {
                Text(option.rawValue)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(width: 150)
            .background(selectedPrivacy == option ? Color.blue : Color.gray)
            .cornerRadius(32)
        }
    }
}
