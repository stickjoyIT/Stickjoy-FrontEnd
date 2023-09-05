//
//  SettingsScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 10/08/23.
//  Nombre de Lista de Requerimientos: 3. Pop Up Menu - Configuraciones
//  Paulo: Este pop up se convirtió en pantalla por temas de facilidad de navegación.
//  ¿Qué falta?: Faltan acciones de botones. Que si se apaguen notificaciones, falta que el botón de copiar link, se copie en portapapeles para pegar en donde sea y enviar a tus amigos. 

import SwiftUI

@available(iOS 16.0, *)
struct SettingsScreen: View {
    @State private var isNotificationsEnabled = true
    @State private var selectedLanguage = "English"
    @State private var isTermsAndConditionsMenuPresented = false // Add this state variable
    @Binding var logueado:Bool
    @Binding var lenguaje:String
    @State var isAlert = false
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                Text(lenguaje == "es" ? "Configuraciones" : "Settings")
                    .font(.largeTitle)
                    .padding(.top, 32)
                Toggle(lenguaje == "es" ? "Notificaciones" : "Notifications", isOn: $isNotificationsEnabled)
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading) // Set frame width to infinity
                    .padding()
                Button(action: {
                    
                    // Añadir acción de abrir pantalla de Suscripción
                    
                }) {
                    Text(lenguaje == "es" ? "Mi subscripcion" : "My subscription")
                        .frame(maxWidth: .infinity, alignment: .center) // Set frame width to infinity
                        .padding()
                        .foregroundColor(Color.white)
                        .bold()
                        .background(Color.blue)
                        .cornerRadius(16)
                }
                
                Button(action: {
                    
                    // Añadir acción de abrir pantalla de Suscripción
                    
                }) {
                    Text(lenguaje == "es" ? "Copiar enlace de Stickjoy" : "Copy Stickjoy Link")
                        .frame(maxWidth: .infinity, alignment: .center) // Set frame width to infinity
                        .padding()
                        .foregroundColor(Color.black)
                        .bold()
                        .background(Color.yellow)
                        .cornerRadius(16)
                }
                
                
                Text(lenguaje == "es" ? "Lenguaje" : "Language")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading) // Set frame width to infinity
                    .padding()
                    .cornerRadius(16)
                
                HStack {
                    Button(action: {
                        lenguaje = "es"
                        UserDefaults.standard.set(lenguaje, forKey: "lenguaje")
                    }) {
                        HStack {
                            Text("Español")
                                .fontWeight(lenguaje == "es" ? .bold : .regular)
                                .background(.thinMaterial)
                                .cornerRadius(8)
                                .padding()
                            Spacer()
                            if lenguaje == "es" {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Set frame width to infinity
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(16)
                    
                    
                    
                    Button(action: {
                        lenguaje = "en"
                        UserDefaults.standard.set(lenguaje, forKey: "lenguaje")
                    }) {
                        HStack {
                            Text("English")
                                .fontWeight(lenguaje == "en" ? .bold : .regular)
                                .background(.thinMaterial)
                                .cornerRadius(8)
                                .padding()
                            Spacer()
                            if lenguaje == "en" {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Set frame width to infinity
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(16)
                    
                    
                }
                
                Button(lenguaje == "es" ? "Términos, Condiciones y Políticas de Privacidad" : "Terms, Conditions and Privacy Policies") {
                    isTermsAndConditionsMenuPresented = true
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Set frame width to infinity
                .padding()
                .background(.thinMaterial)
                .cornerRadius(16)
                
                
                
                Button(action: {
                    //Añadir acción de abrir popover: LogOutMenu para cerrar sesión
                    //logueado = false
                    isAlert = true
                }) {
                    Text(lenguaje == "es" ? "Cerrar sesion" : "Log Out")
                    .frame(maxWidth: .infinity, alignment: .center) // Set frame width to infinity
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(16)
                }.confirmationDialog(lenguaje == "es" ? "Cerrar sesion" : "Log Out", isPresented: $isAlert){
                    Button("Aceptar", role: .destructive) {
                        UserDefaults.standard.set(false,forKey: "login")
                        logueado = false
                    }
                    Button("Cancel", role: .cancel) {
                    }
                } message : {
                    Text("Esta seguro de cerrar sesion").font(.largeTitle)
                }
                
                Button(action: {
                    //Añadir acción de abrir popover: LogOutMenu para cerrar sesión
                }) {
                    Text(lenguaje == "es" ? "Eliminar cuenta" : "Delete account")
                    .frame(maxWidth: .infinity, alignment: .center) // Set frame width to infinity
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(16)
                }



                
                Spacer()
            }
            .padding(24)
            .navigationBarTitle(lenguaje == "es" ? "Configuraciones" : "Settings")
            .sheet(isPresented: $isTermsAndConditionsMenuPresented) {
                TermsAndConditionsMenu(isPresented: $isTermsAndConditionsMenuPresented)
        }
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            SettingsScreen(logueado: .constant(false), lenguaje: .constant("es"))
        } else {
            // Fallback on earlier versions
        }
    }
}
