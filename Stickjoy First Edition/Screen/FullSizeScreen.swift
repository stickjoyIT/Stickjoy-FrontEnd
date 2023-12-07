//
//  FullSizeScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//  Nombre en Lista de Requerimientos: 10. Pantalla de Full Size
//  Paulo: Falta lo del botón que oculta y muestra la información.
//  ¿Qué falta?: Corregir lo de que se ve gris la info.

import SwiftUI

struct FullSizeScreen: View {
    @Binding var img:String
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                    AsyncImage(url: URL(string: img), content: { img in
                            img
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                    }, placeholder: {
                            Image("")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }).edgesIgnoringSafeArea(.all)
                
                Text("Hello, FullScreen!")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.green)
                            .cornerRadius(8)
                            
                
            }
        }
        
    }
}

struct FullSizeScreen_Previews: PreviewProvider {
    static var previews: some View {
        FullSizeScreen(img:.constant("https://media.sproutsocial.com/uploads/2022/06/profile-picture.jpeg"))
    }
}
