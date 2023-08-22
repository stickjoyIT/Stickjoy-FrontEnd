//
//  ElsesProfileHeader.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Paulo: Este es el header de perfil ajeno. El botón de Add tiene 3 variantes: Add, Pending y Friend. El de friend no está porque depende de back (es tu amigo o no). Dtm, el diseño lo pongo en comentario más abajo.

import SwiftUI

struct ElsesProfileHeader: View {
    //Adopción de Modo claro oscuro
    @Environment (\.colorScheme) var scheme
    
    //Para que el botón de agregar o cancelar solicitud cambie de estado
    @State private var isAddedButtonClicked = false
    
    //Para que el botón de anclar perfil cambie de estado. Debe leer si se ha anclado anteriormente el perfil, en este caso sería "true"
    @State private var isPinProfileButtonClicked = false

    var body: some View {
        ZStack(alignment: .leading) {
            (scheme == .dark ? Color.black : Color.white) // Ensure the ZStack has a background color
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 16) {
                    
                    //Botón para Regresar
                    Button(action: {
                        //Acción de regresar
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    //Botón para anclar perfil
                    Button(action: {
                        isPinProfileButtonClicked.toggle()
                        //Añadir acción de anclar perfil
                    }) {
                        Image(systemName: isPinProfileButtonClicked ? "pin.fill" : "pin.slash.fill")
                            .font(.title)
                            .foregroundColor(.secondary)
                    }
                    
                    
                    //Botón para entrar a editor de perfil
                    Button(action: {
                        isAddedButtonClicked.toggle()
                        // Add your action here
                    
                    }) {
                        Image(systemName: isAddedButtonClicked ? "person.badge.plus" : "clock")
                            .foregroundColor(.black)
                            .font(.title3)
                        Text(isAddedButtonClicked ? "Add" : "Pend")
                            .foregroundColor(.black)
                            .font(.headline)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(isAddedButtonClicked ? Color.customYellow : Color.customBlue)
                    .cornerRadius(16)
                    
                    //Si es amigo el botón debe tener las siguiente caracterísitcas: Image(systemName: "check.mark.circle") del mismo tamaño que los que ya existen, y el texto diría Text("Friend")
                    
                }
                HStack {
                    Text(ElsesProfileInfo.profileName)
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                Text(ElsesProfileInfo.profileUsername)
                    .font(.headline)
                
                Text(ElsesProfileInfo.profileDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(24)
        }
        .edgesIgnoringSafeArea(.horizontal) // Extend the header to the screen edges
    }
}

struct ElsesProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ElsesProfileScreen()
    }
}
