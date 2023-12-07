//
//  NewFeedScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Nombre en Lista de Requerimientos: 11. Pantalla de Feed de Nuevo Usuario
//  Paulo: Este es el feed que se verá si el usuario no tiene amigos ni albumes colaborativos.
//  ¿Qué falta?: Nada.

import SwiftUI
// Esto es para hacer dos pantallas en una y que dependa de si esta vacío o no.

var Empty: Bool = true

struct EmptyFeedScreen: View {
    @Binding var lenguaje:String
    var body: some View {
        VStack {
            FeedHeader(lenguaje: $lenguaje).frame(height:80)
            ScrollView {
                EmptyFeedBody(lenguaje: $lenguaje)
                Spacer()
            }
        }
    }
}

struct EmptyFeedScreen_Previews: PreviewProvider {
    static var previews: some View {
        EmptyFeedScreen(lenguaje: .constant("es"))
    }
}
