//
//  LogInScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Nombre en Lista de Requerimientos: 3. Pantalla de Inicio de Sesión
//  Paulo: Pantalla de login donde el usuario inicia sesión, los textfield deben regresar el error de información no válida: correo/nombre de usuario y/o contraseña inválido.
//  ¿Qué falta?: Regresar error de información no válida. Proceso de Recuperación de contraseña. 

import SwiftUI

struct LogInScreen: View {
    @State private var isShowingUserProfile = false
    @Environment(\.presentationMode) private var presentationMode:Binding<PresentationMode>
    // Para adapatación a dark y light mode
    @Environment (\.colorScheme) var scheme
    
    //Text fields de info
    @State private var emailOrUsername = ""
    @State private var password = ""
    @State private var isForgotPasswordMenuPresented = false // Add this state variable
    @State private var showAlert = false
    @State private var mensajeAlerta = ""
    var body: some View {
        Spacer().navigationBarBackButtonHidden(true)
        VStack(alignment: .center, spacing: 5) {
            HStack {
                Button{
                    presentationMode.wrappedValue.dismiss()
                }label: {
                    Image("btnBack")
                }.padding()
                
                Text("Iniciar sesion")
                    .font(.title)
                    .fontWeight(.medium)
                    .padding(.all, 30)
                Spacer()
            }.padding(.trailing)
            
            UnderlineTextFieldView(text: $emailOrUsername, textFieldView: textView, placeholder: "@nombreusuario/correo electronico").padding(25)
            
            UnderlineTextFieldView(text: $password, textFieldView: passwordView, placeholder: "Contrasena").padding(25)
            
            HStack {
                Spacer()
                Button(action: {
                    isForgotPasswordMenuPresented = true // Show the ForgotMyPasswordMenu
                }) {
                    Text("Olvide mi contrasena")
                        .foregroundColor(.gray)
                        .padding(.trailing) // Add trailing padding
                }
            }
            Button("Continuar") {
                if emailOrUsername.isEmpty{
                    showAlert = true
                    mensajeAlerta = "Debe agregar un usuario"
                    return
                }
                if password.isEmpty{
                    mensajeAlerta = "Debe gregar una contrasena"
                    showAlert = true
                    
                    return
                }
                isShowingUserProfile = true
            }
            .alert(isPresented: $showAlert, content: {
                getAlert()
            })
            .foregroundColor(scheme == .dark ? Color.black : Color.white)
            .frame(width: 250)
            .padding()
            .background(scheme == .dark ? Color.white : Color.black)
            .cornerRadius(80)
            .padding(.top,100)
            .fullScreenCover(isPresented: $isShowingUserProfile, content: {
                ProfileScreen()
            })
            
            Spacer()
        }
        .padding(.top)
        .sheet(isPresented: $isForgotPasswordMenuPresented) {
            ForgotMyPasswordMenu(isPresented: $isForgotPasswordMenuPresented)
        }
    }
    
    func getAlert() -> Alert {
        return  Alert(title: Text("Mensaje"), message: Text(mensajeAlerta), dismissButton: .default(Text("ok")))
    }
}

extension LogInScreen {
    private var textView: some View {
            TextField("", text: $emailOrUsername)
                .foregroundColor(.black)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
        }
        
        private var passwordView: some View {
            SecureField("", text: $password)
                .foregroundColor(.black)
        }
}

struct LogInScreen_Previews: PreviewProvider {
    static var previews: some View {
        LogInScreen()
    }
}
