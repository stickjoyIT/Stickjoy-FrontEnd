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
    @ObservedObject var avm = AlbumViewModel()
    @State private var selectedPrivacy: PrivacyOption?
    @Environment (\.dismiss) var dismiss
    @Binding var lenguaje:String
    @Binding var privacy:Int
    @State var privacySelect = 0
    @Binding var id_album:String
    @State var isAlert = false
    @State var mensaje = ""
    enum PrivacyOption: String {
        case privateAlbum = "Private"
        case publicAlbum = "Public"
        case justFriendsAlbum = "Friends"
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading){
                HStack {
                    Button(action: {
                        // Añadir ir hacia atrás. Te lleva de vuelta al AdminPanelScreen.
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.title)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(lenguaje == "es" ? "Privacidad de álbum" : "Album Privacy")
                        .font(.title)
                        .bold()
                    .padding()
                    Spacer()
                }.padding()
            }
            VStack(alignment: .center, spacing: 16) {
                    PrivacyOptionsView(selectedPrivacy: $selectedPrivacy, lenguaje: $lenguaje, privacy: $privacySelect)
                    
                    Spacer()
                    
                    Button(action: {
                        // Añadir acción de guardar cambios.
                        avm.changeStatusPrivacy(idalbum: id_album, newPrivacy: privacySelect, nombre: "", descrip: "", urlImg: "", responseData: { resp in
                            if resp.status == 200 {
                                privacy = privacySelect
                            }
                            isAlert = true
                            mensaje = resp.message
                        })
                    }) {
                        Text(lenguaje == "es" ? "Guardar" : "Save")
                        .frame(width: 250)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)                }
                    
                }
                .padding(.vertical, 16)
                .onAppear{
                    privacySelect = privacy
                    switch privacySelect {
                    case 0:
                        selectedPrivacy = .privateAlbum
                    case 1:
                        selectedPrivacy = .justFriendsAlbum
                    case 2:
                        selectedPrivacy = .publicAlbum
                    default:
                        selectedPrivacy = .publicAlbum
                    }
                }.alert(isPresented: $isAlert, content: {
                    Alert(title: Text("Mensaje"), message: Text(mensaje))
            })
        }
    }
    }


struct AlbumPrivacyScreen_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPrivacyScreen(lenguaje: .constant(""), privacy: .constant(1), id_album: .constant(""))
    }
}

struct PrivacyOptionsView: View {
    @Binding var selectedPrivacy: AlbumPrivacyScreen.PrivacyOption?
    @Binding var lenguaje:String
    @Binding var privacy:Int
    var body: some View {
        VStack(spacing: 24) {
            PrivacyOptionButton(lenguaje: $lenguaje, option: .privateAlbum, selectedPrivacy: $selectedPrivacy, privacy: $privacy)
            
            Text(lenguaje == "es" ? "Privado: solo tú y tus colaboradores pueden verlo." : "Private: Only you and your collaborators can see it.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            PrivacyOptionButton(lenguaje: $lenguaje, option: .justFriendsAlbum, selectedPrivacy: $selectedPrivacy, privacy: $privacy)
            
            Text(lenguaje == "es" ? "Amigos: solo tú, tus amigos, tus colaboradores, y los amigos de tus colaboradores pueden verlo." :"Just friends: Only you, your friends, your collaborators, and your collaborator's friends can see it.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            
            PrivacyOptionButton(lenguaje: $lenguaje, option: .publicAlbum, selectedPrivacy: $selectedPrivacy, privacy: $privacy)
            
            Text(lenguaje == "es" ? "Público: Todos pueden verlo." : "Public: Everyone can see it.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

        }
        .padding(.horizontal)
    }
}

struct PrivacyOptionButton: View {
    @Binding var lenguaje:String
    var option: AlbumPrivacyScreen.PrivacyOption
    @Binding var selectedPrivacy: AlbumPrivacyScreen.PrivacyOption?
    @Binding var privacy: Int
    var body: some View {
        Button(action: {
            selectedPrivacy = option
            
            switch option {
            case .publicAlbum:
                privacy = 2
            case .justFriendsAlbum:
                privacy = 1
            case .privateAlbum:
                privacy = 0
            }
            
        }) {
            VStack(spacing: 4) {
                
                switch option {
                case .publicAlbum:
                    Text(lenguaje == "es" ? "Público" : "Public")
                        .font(.headline)
                        .foregroundColor(.white)
                case .justFriendsAlbum:
                    Text(lenguaje == "es" ? "Amigos" : "Friends")
                        .font(.headline)
                        .foregroundColor(.white)
                case .privateAlbum:
                    Text(lenguaje == "es" ? "Privado" : "Private")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .frame(width: 150)
            .background(selectedPrivacy == option ? Color.blue : Color.gray)
            .cornerRadius(32)
        }
    }
}
