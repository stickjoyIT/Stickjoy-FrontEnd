//
//  SettingsScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 10/08/23.
//  Nombre de Lista de Requerimientos: 3. Pop Up Menu - Configuraciones
//  Paulo: Este pop up se convirtió en pantalla por temas de facilidad de navegación.
//  ¿Qué falta?: Faltan acciones de botones. Que si se apaguen notificaciones, falta que el botón de copiar link, se copie en portapapeles para pegar en donde sea y enviar a tus amigos. 

import SwiftUI

struct SettingsScreen: View {
    @State private var isNotificationsEnabled = true
    @State private var selectedLanguage = "English"
    @State private var isTermsAndConditionsMenuPresented = false // Add this state variable
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            Text("Settings")
                .font(.largeTitle)
                .padding(.top, 32)
            
            Toggle("Notifications", isOn: $isNotificationsEnabled)
                .font(.title3)
                .bold()
                .cornerRadius(8)
                .frame(maxWidth: .infinity, alignment: .leading) // Set frame width to infinity
                .padding()
            
            
            Button(action: {
                
                // Añadir acción de abrir pantalla de Suscripción
                
            }) {
                Text("My Subscription")
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
                Text("Copy Stickjoy Link")
                    .frame(maxWidth: .infinity, alignment: .center) // Set frame width to infinity
                    .padding()
                    .foregroundColor(Color.black)
                    .bold()
                    .background(Color.yellow)
                    .cornerRadius(16)
            }
            
            
            Text("Language")
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading) // Set frame width to infinity
                .padding()
                .cornerRadius(16)
            
            
            
            HStack {
                Button(action: {
                    selectedLanguage = "Español"
                }) {
                    HStack {
                        Text("Español")
                            .fontWeight(selectedLanguage == "Español" ? .bold : .regular)
                            .background(.thinMaterial)
                            .cornerRadius(8)
                            .padding()
                        Spacer()
                        if selectedLanguage == "Español" {
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
                    selectedLanguage = "English"
                }) {
                    HStack {
                        Text("English")
                            .fontWeight(selectedLanguage == "English" ? .bold : .regular)
                            .background(.thinMaterial)
                            .cornerRadius(8)
                            .padding()
                        Spacer()
                        if selectedLanguage == "English" {
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
            
            Button("Terms, Conditions and Privacy Policies") {
                isTermsAndConditionsMenuPresented = true
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Set frame width to infinity
            .padding()
            .background(.thinMaterial)
            .cornerRadius(16)
            
            
            
            Button(action: {
                //Añadir acción de abrir popover: LogOutMenu para cerrar sesión
            }) {
                Text("Log out")
                .frame(maxWidth: .infinity, alignment: .center) // Set frame width to infinity
                .padding()
                .background(.thinMaterial)
                .cornerRadius(16)
            }

            
            Button(action: {
                //Añadir acción de abrir popover: LogOutMenu para cerrar sesión
            }) {
                Text("Delete account")
                .frame(maxWidth: .infinity, alignment: .center) // Set frame width to infinity
                .padding()
                .background(.thinMaterial)
                .cornerRadius(16)
            }



            
            Spacer()
        }
        .padding(24)
        .navigationBarTitle("Settings")
        .sheet(isPresented: $isTermsAndConditionsMenuPresented) {
            TermsAndConditionsMenu(isPresented: $isTermsAndConditionsMenuPresented)
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
