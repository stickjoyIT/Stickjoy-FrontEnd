//
//  SignInScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Nombre en Lista de Requerimientos: 2. Pantalla de Registro
//  Paulo: El usuario coloca su email, nombre, y password. Si la información no es válida o el nombre de usuario no está disponible, regresa el error.
//  ¿Qué falta?: regresar el error del nombre de usuario no disponible, contraseña e email no válido.

import SwiftUI

struct SignInScreen: View {
    @State private var isShowingProfileScreen = false
    
    // Para agregar el TermsAndConditionsMenu
    @State private var isTermsAndConditionsMenuPresented = false
    
    // Para adaptacion de dark y light mode
    @Environment (\.colorScheme) var scheme

    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var agreedToTerms = false // Estado default del checkbox toggle es falso
    
    var body: some View {
        VStack(spacing: 4) { // Espacio vertical entre objetos
            
            Text("Sign In")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Create a username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text("The password must include a minimum of 8 characters, 1 special character, and 1 digit.")
                .font(.caption)
                .foregroundColor(Color.secondary)
            
            HStack {
                Toggle("", isOn: $agreedToTerms) // Add the Toggle for the checkbox
                    .frame(width: 80, height: 80, alignment: .leading)
                Text("By activating this switch, you agree to our Terms, Conditions of Use, and Privacy Policies.")
                    .frame(width: .infinity)
                    .foregroundColor(.secondary)
                    .padding()
            }
            
            Button("Continue") {
                isShowingProfileScreen = true
            }
            .foregroundColor(agreedToTerms ? Color.blue : Color.white)
            .frame(width: 250)
            .padding()
            .background(agreedToTerms ? Color.primary : Color.secondary) // Set background color based on toggle state
            .cornerRadius(10)
            .padding()
            .fullScreenCover(isPresented: $isShowingProfileScreen, content: {
                ContentView()
            })
            .disabled(!agreedToTerms) // Disable the button if agreedToTerms is false
            
            Button("Read Terms, Conditions of Use, and Privacy Policies") {
                isTermsAndConditionsMenuPresented = true // Show the TermsAndConditionsMenu
            }
            .foregroundColor(.blue)
            .padding()
            
            Spacer() // Add spacer to push content to the top
        }
        .padding(.top) // Add top padding to create space for the keyboard
        .sheet(isPresented: $isTermsAndConditionsMenuPresented) {
            TermsAndConditionsMenu(isPresented: $isTermsAndConditionsMenuPresented)
        }
    }
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen()
    }
}
