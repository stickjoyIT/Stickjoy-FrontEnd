//
//  FriendsScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Nombre en Lista de Requerimientos: 14. Pantalla de Amigos
//  Paulo:
//  ¿Qué falta?: Conectar con info real (Archivo: Model/ProfileInfo/ProfileInfo.swift) aquí no se conecta directamente, si no en los views que están en View/Profile/archivos.swift. Habilitar SearchBar. Acciones de cancelar, aceptar y borrar. Acción de meterese al perfil de las miniaturas de perfil.

import SwiftUI

struct FriendsScreen: View {
    @State private var friendsHeaderHeight: CGFloat = 0

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 16) {
                        // Add the horizontal grid of AnchoredProfileView
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: [GridItem(.fixed(150))], spacing: 16) {
                                ForEach(anchoredprofile) { profile in
                                    AnchoredProfiles(anchoredprofile: profile)
                                }
                            }
                            .padding()
                        }

                        // Add the InboxView section
                        Inbox()
                        
                        //Add the OutboxView section
                        Outbox()
                        
                        //Add the FriendsListView section
                        FriendsList()
                    }
                    .padding(.top, 120) // Adjust this value as needed to add spacing between the header and the sections
                }
                .ignoresSafeArea(.all, edges: .top) // Ignore safe area from the top

                FriendsHeader()
                    .background(GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                friendsHeaderHeight = geometry.size.height
                            }
                    })
                    .frame(height: friendsHeaderHeight)
            }
            .padding(.top, 32)
        }
    }
}

struct FriendsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FriendsScreen()
    }
}
