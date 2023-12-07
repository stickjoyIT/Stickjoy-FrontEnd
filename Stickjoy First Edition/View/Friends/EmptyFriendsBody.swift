//
//  NewFriendsBody.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Este archivo es el body de EmptyFriendsScreen

import SwiftUI

struct EmptyFriendsBody: View {
    @Binding var lenguaje:String
    var body: some View {
        ZStack(alignment: .top){
            VStack(alignment: .center, spacing: 16) {
                Text(lenguaje == "es" ? "¡Hola!" : "Hey!")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                
                Text(lenguaje == "es" ? "Estás en Amigos" : "You are now on Friends")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Text(lenguaje == "es" ? "Aquí podrás:" : "Here you'll be able to:")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Text(lenguaje == "es" ? "Buscar amigos" : "Search for friends and look at your friends profiles")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(lenguaje == "es" ? "Ver solicitudes y notificaciones" : "See Inbox and Outbox requests")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(lenguaje == "es" ? "Anclar tus perfiles favoritos" : "Pin profiles you like")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                
                Text(lenguaje == "es" ? "Los momentos más preciados cobran vida cuando los experimentamos a través de los ojos de quienes más queremos" : "The most precious moments come to life when we experience them through the eyes of those we love the most.")
                    .bold()
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text(lenguaje == "es" ? "¡Comienza creando álbumes y colaborando con tus amigos!" : "Start by creating albums and following your friends!")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 8)
            .frame(width: .infinity)
        }
    }
}

struct EmptyFriendsBody_Previews: PreviewProvider {
    static var previews: some View {
        EmptyFriendsBody(lenguaje: .constant("es"))
    }
}
