//
//  NewFriendsScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Nombre en Lista de Requerimientos: 13. Pantalla de Amigos de Nuevo Usuario
//  Paulo: Esta pantalla es la que ve el usuario que no ha tenido ninguna actividad, no tiene amigos, ni perfiles anclados, ni solicitudes. A partir de la primera solicitud, o perfil anclado o amigo, deja de aparecer así.

import SwiftUI

struct EmptyFriendsScreen: View {
    var body: some View {
        ZStack(alignment: .top){
            VStack{
                //Contenido en View/Friends/EmptyFriendsBody.swift
                EmptyFriendsBody()
            }
        }
    }
}

struct EmptyFriendsScreen_Previews: PreviewProvider {
    static var previews: some View {
        EmptyFriendsScreen()
    }
}
