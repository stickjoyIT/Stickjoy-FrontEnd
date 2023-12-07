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
    @Binding var logueado: Bool
    @Binding var lenguaje:String
    @State var loginView = false
    @State var registerView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.customYellow.edgesIgnoringSafeArea(.all) // Fondo amarillo Stickjoy, el color está en el archivo: Model/Color
                
                VStack {
                    Spacer() // Para empujar título a centro de pantalla
                    Image("Logo_Stick").resizable().frame(width: 134, height: 56).padding()
                    Spacer() // Para añadir espacio entre botones y título
                    
                    Button(action:  {
                        registerView = true
                        
                    }, label: {
                        Text(lenguaje == "es" ? "Primera vez" : "First time")
                            .foregroundColor(.white)
                            .frame(width: 250)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                    })
                    
                    Button(action: {
                        loginView = true
                    }, label: {
                        Text(lenguaje == "es" ? "Iniciar sesión" : "Log In")
                            .foregroundColor(.black) // Set foreground color to black
                            .frame(width: 250)
                            .padding()
                            .background(Color.white) // Set background color to white
                            .cornerRadius(10)
                    }) // Add more spacing at the bottom
                    
                    //Layout horizontal de botones de idioma
                    HStack {
                        //Botón idioma inglés
                        Button(action: {
                            lenguaje = "es"
                            UserDefaults.standard.set("es", forKey: "lenguaje")
                        }) {
                            Text(lenguaje == "es" ? "Español" : "Spanish")
                                .fontWeight(lenguaje == "es" ? .bold : .regular)
                                .frame(width: 80)
                                .padding()
                                .background(lenguaje == "es" ? Color.white : Color.clear)
                                .cornerRadius(10)
                        }
                        .foregroundColor(.black)
                        
                        
                        // Para separar botones
                        Spacer()
                        
                        //Botón idioma inglés
                        Button(action: {
                            lenguaje = "en"
                            UserDefaults.standard.set("en", forKey: "lenguaje")
                        }) {
                            Text(lenguaje == "es" ? "Inglés" : "English")
                                .fontWeight(lenguaje == "en" ? .bold : .regular)
                                .frame(width: 80)
                                .padding()
                                .background(lenguaje == "en" ? Color.white : Color.clear)
                                .cornerRadius(10)
                        }
                        .foregroundColor(.black)
                    }
                    .frame(width: 280)
                    .padding()
                }
                .fullScreenCover(isPresented: $loginView){
                    LogInScreen(logueado:self.$logueado)
                }
                .fullScreenCover(isPresented: $registerView){
                    SignInScreen(logueado: self.$logueado)
                }
            }
        }.onAppear{
            if let leng = UserDefaults.standard.string(forKey: "lenguaje") {
                lenguaje = leng
            } else {
                UserDefaults.standard.set("es",forKey: "lenguaje")
            }
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen(logueado: .constant(false), lenguaje: .constant("es"))
    }
}
