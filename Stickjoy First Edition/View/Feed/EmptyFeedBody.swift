//
//  NewFeedBody.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Este archivo es el body de EmptyFeedScreen

import SwiftUI

struct EmptyFeedBody: View {
    @Binding var lenguaje:String
    var body: some View {
        ZStack (alignment: .top){
            VStack(alignment: .center, spacing: 18) {
                Text(lenguaje == "es" ? "¡Hola!" : "¡Hey!")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                
                Text(lenguaje == "es" ? "Estás en Feed" : "You are now on Feed")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Text(lenguaje == "es" ? "Aquí podrás ver:" : "Here you'll see:")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Text(lenguaje == "es" ? "Fotos y vídeos de los álbumes de tus amigos ('públicos' y 'solo amigos')" : "Photos and videos from your friend's albums ('public' and 'friends only')")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(lenguaje == "es" ? "Fotos y vídeos de álbumes en los que has colaborado" : "Photos and videos from albums you've collaborated in")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(lenguaje == "es" ? "Los momentos más preciados cobran vida cuando los experimentamos a través de los ojos de quienes más queremos" : "If the most cherished corner of memories is our mind, why not create a real refuge for them?")
                    .bold()
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text(lenguaje == "es" ? "¡Empieza por crear álbumes y seguir a sus amigos!" : "Start by creating albums and following your friends!")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 16)
            .frame(width: .infinity)
        }
    }
}

struct EmptyFeedBody_Previews: PreviewProvider {
    static var previews: some View {
        EmptyFeedBody(lenguaje: .constant("es"))
    }
}
