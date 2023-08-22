//
//  LaunchScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Nombre en Lista de Requerimientos: 2. Pantalla de Lanzamiento
//  Paulo: Aquí el usuario se registra o inicia sesión. Elige el idioma correspondiente que se podrá cambiar posteriomente.
//  ¿Qué falta?: Que los botones de idioma si cambien el idioma. 


import SwiftUI

struct LaunchScreen: View {
    @State private var selectedLanguage: String?
    
    //Idioma seleccionado por default, en este caso, español.
    init() {
        _selectedLanguage = State(initialValue: "Español")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.customYellow.edgesIgnoringSafeArea(.all) // Fondo amarillo Stickjoy, el color está en el archivo: Model/Color
                
                VStack {
                    Spacer() // Para empujar título a centro de pantalla
                    
                    Text("Stickjoy")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    Spacer() // Para añadir espacio entre botones y título
                    
                    NavigationLink(destination: SignInScreen()) {
                        Text("First Time")
                            .foregroundColor(.white)
                            .frame(width: 250)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                    
                    NavigationLink(destination: LogInScreen()) {
                        Text("Log In")
                            .foregroundColor(.black) // Set foreground color to black
                            .frame(width: 250)
                            .padding()
                            .background(Color.white) // Set background color to white
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 16) // Add more spacing at the bottom
                    
                
                    
                    //Layout horizontal de botones de idioma
                    HStack {
                        //Botón idioma inglés
                        Button(action: {
                            selectedLanguage = "Español"
                        }) {
                            Text("Español")
                                .fontWeight(selectedLanguage == "Español" ? .bold : .regular)
                                .frame(width: 80)
                                .padding()
                                .background(selectedLanguage == "Español" ? Color.white : Color.clear)
                                .cornerRadius(10)
                        }
                        .foregroundColor(.black)
                        
                        
                        // Para separar botones
                        Spacer()
                        
                        //Botón idioma inglés
                        Button(action: {
                            selectedLanguage = "English"
                        }) {
                            Text("English")
                                .fontWeight(selectedLanguage == "English" ? .bold : .regular)
                                .frame(width: 80)
                                .padding()
                                .background(selectedLanguage == "English" ? Color.white : Color.clear)
                                .cornerRadius(10)
                        }
                        .foregroundColor(.black)
                    }
                    .frame(width: 280)
                    .padding()
                }
            }
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
