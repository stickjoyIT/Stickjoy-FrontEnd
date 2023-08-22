//
//  InviteCollaboratorsScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Nombre en Lista de Requerimientos: 16. Pop Up Menu - Invitiar Colaboradores
//  Paulo: Esta pantalla, la info esta conectada a ProfileInfo.Swift que es un archivo Foundation. 
//  ¿Qué falta?: Acción de botón de regresar. Conectar Search Bar con info. Acciones de invitar y cancelar. Que al invitar, el usuario pase a pendientes.
//  Nota Importante: recomiendo que toda la info del álbum, esté guardada en el File Model/Profile Info/ProfileInfo.swift.

import SwiftUI

struct InviteCollaboratorsScreen: View {
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading, spacing: 16) {
                    Button(action: {
                        // Añadir ir hacia atrás. Te lleva de vuelta al AdminPanelScreen.
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.title)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        Spacer()
                    }
                    HStack(alignment: .center){
                        
                        Text("Invite Collaborators")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                    }
                    
                    SearchBarView()
                        .padding(.horizontal)
                    Spacer()
                    Divider()
                    
                    //Sección de Solicitudes pendientes.
                    Section(header: Text("Pending Requests")
                        .font(.title2)
                        .bold()
                            
                    ) {
                        //Este texto manda a llamar el archivo ProfileInfo.Swift
                        ForEach(ProfileFriendsAndRequests.pendingCollabRequests, id: \.self) { request in
                            InviteCollaboratorRow(name: request, isRequest: true)
                        }
                    }
                    
                    Divider()
                    
                    //Sección de Lista de amigos.
                    Section(header: Text("Friends List")
                        .font(.title2)
                        .bold()
                            
                    ) {
                        //Este texto manda a llamar el archivo ProfileInfo.Swift
                        ForEach(ProfileFriendsAndRequests.friendsList, id: \.self) { friend in
                            InviteCollaboratorRow(name: friend, isRequest: false)
                        }
                    }
                    Spacer()
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct InviteCollaboratorsScreen_Previews: PreviewProvider {
    static var previews: some View {
        InviteCollaboratorsScreen()
    }
}

struct SearchBarView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search", text: $searchText)
                .foregroundColor(.black)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct InviteCollaboratorRow: View {
    var name: String
    var isRequest: Bool
    
    var body: some View {
        HStack {
            Image("profilePicture")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                //Este texto manda a llamar el archivo ProfileInfo.Swift
                Text(ProfileInfo.profileName)
                    .font(.headline)
                //Este texto manda a llamar el archivo ProfileInfo.Swift
                Text(ProfileInfo.profileUsername)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                if isRequest {
                    // Acción de "Cancelar" invitación va aquí
                } else {
                    // Acción de "Invitar"  a album va aquí
                }
            }) {
                Text(isRequest ? "Cancel" : "Invite")
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(isRequest ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 8)
    }
}
