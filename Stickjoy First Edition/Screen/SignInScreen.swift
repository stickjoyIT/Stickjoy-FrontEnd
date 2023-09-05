//
//  SignInScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Nombre en Lista de Requerimientos: 2. Pantalla de Registro
//  Paulo: El usuario coloca su email, nombre, y password. Si la información no es válida o el nombre de usuario no está disponible, regresa el error.
//  ¿Qué falta?: regresar el error del nombre de usuario no disponible, contraseña e email no válido.

import SwiftUI
import SwiftUISnackbar

struct SignInScreen: View {
    
    @State private var showPassword = false
    @State private var showPasswordC = false
    
    @StateObject var uvm = UsuariosViewModel()
    
    @State private var isShowingProfileScreen = false
    
    @State private var showAlert = false
    
    // Para agregar el TermsAndConditionsMenu
    @State private var isTermsAndConditionsMenuPresented = false
    
    @Environment(\.presentationMode) private var presentationMode:Binding<PresentationMode>
    
    // Para adaptacion de dark y light mode
    @Environment (\.colorScheme) var scheme
    
    @Binding var logueado:Bool
    
    @State var showSnack = false

    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var agreedToTerms = false // Estado default del checkbox toggle es falso
    @State private var confirmPass = ""
    let lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
    var body: some View {
            ZStack(alignment: .top) {
                VStack() { // Espacio vertical entre objeto
                    HStack {
                        Button{
                            presentationMode.wrappedValue.dismiss()
                        }label: {
                            Image("btnBack")
                        }.padding()
                        Text(lenguaje == "es" ? "Regístrate" : "Sign In")
                            .font(.title)
                            .fontWeight(.medium)
                            .padding(.leading, 40)
                        Spacer()
                    }.padding(.trailing)
                    ScrollView(.vertical) {
                    
                        UnderlineTextFieldView(text: $email, textFieldView: emailView, placeholder:lenguaje == "es" ? "Correo" : "Email").padding(25)
                        UnderlineTextFieldView(text: $username, textFieldView: userView, placeholder: lenguaje == "es" ? "Usuario" : "Username").padding(25)
                    
                        UnderlineTextFieldView(text: $password, textFieldView: passwordView, placeholder: lenguaje == "es" ? "Contraseña" : "Password").padding(25)
                        
                        UnderlineTextFieldView(text: $confirmPass, textFieldView: passwordConfirmView, placeholder: lenguaje == "es" ? "Confirmar Contraseña" : "Confirm password").padding(25)
                        
                        Text(lenguaje == "es" ? "La contraseña debe incluir: La contraseña debe incluir mínimo 8 caracteres, 1 signo especial y 1 número." : "Password should include at least 8 characters, 1 special symbol and 1 number.")
                        .font(.caption)
                        .foregroundColor(Color.secondary)
                        .padding(.horizontal, 25)
                    
                    HStack {
                        Toggle("", isOn: $agreedToTerms) // Add the Toggle for the checkbox
                            .frame(width: 80, height: 80, alignment: .leading)
                        Text(lenguaje == "es" ? "Al dar click en esta casilla acepto las Políticas de Privacidad, Términos y Condiciones de Stickjoy." : "By checking this box I agree to the  Privacy Policies, Terms and Conditions of Stickjoy. ")
                            .foregroundColor(.secondary)
                            .padding()
                            .font(.system(size: 10))
                    }
                    
                    if uvm.loading {
                        ProgressView()
                    } else {
                        Button(action: {
                            uvm.registrarUsuario(name: username, correo: email, pass: password, confirm_pass: confirmPass){ success in
                                logueado = success
                                showSnack = !success
                            }
                        }, label: {
                            Text(lenguaje == "es" ? "Continuar" : "Continue")
                                .foregroundColor(agreedToTerms && scheme == .dark ? Color.black : Color.white)
                                .frame(width: 250)
                                .padding()
                                .background(agreedToTerms ? Color.primary : Color.secondary) // Set background color based on toggle state
                                .cornerRadius(80)
                                .padding()
                                .fullScreenCover(isPresented: $isShowingProfileScreen, content: {
                                    //ContentView()
                                })
                            
                        }).disabled((!agreedToTerms || uvm.loading)) // Disable the button if agreedToTerms is false
                        
                        
                    }
                    
                        Button(lenguaje == "es" ? "Leer Términos, Condiciones de Uso y Políticas de Privacidad" : "Read Terms, Conditions of Use, and Privacy Policies") {
                        isTermsAndConditionsMenuPresented = true // Show the TermsAndConditionsMenu
                    }
                    .foregroundColor(.blue)
                    .padding()
                    .font(.system(size: 12))
                    
                    
                } // Add top padding to create space for the keyboard
                .sheet(isPresented: $isTermsAndConditionsMenuPresented) {
                    TermsAndConditionsMenu(isPresented: $isTermsAndConditionsMenuPresented)
                }
                .alert(isPresented: $showSnack, content: {
                    Alert(title: Text(lenguaje == "es" ? "Mensaje" : "Message"), message:Text(uvm.mensaje))
                })
            }
        }
    }
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen(logueado: .constant(false))
    }
}

extension SignInScreen {
    private var emailView: some View {
        TextField("", text: $email)
            .foregroundColor(scheme == .dark ? .white : .black)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
    }
    
    private var userView: some View {
        TextField("", text: $username)
            .foregroundColor(scheme == .dark ? .white : .black)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
    }
    
    private var passwordView: some View {
        HStack {
            if showPassword {
                TextField("",
                          text: $password)
                .foregroundColor(scheme == .dark ? .white : .black)
                .colorScheme(.dark)
            } else {
                SecureField("", text: $password)
                    .foregroundColor(scheme == .dark ? .white : .black)
                    .colorScheme(.dark)
            }
            Button(action: {
                self.showPassword.toggle()
            }){
                Image(systemName: showPassword ? "eye" : "eye.slash")
                    .foregroundColor(.secondary)
            }
            
        }
    }
    
    private var passwordConfirmView: some View {
        HStack {
            if showPasswordC {
                TextField("",
                          text: $confirmPass)
                .foregroundColor(scheme == .dark ? .white : .black)
                .colorScheme(.dark)
            } else {
                SecureField("", text: $confirmPass)
                    .foregroundColor(scheme == .dark ? .white : .black)
                    .colorScheme(.dark)
            }
            Button(action: {
                self.showPasswordC.toggle()
            }){
                Image(systemName: showPasswordC ? "eye" : "eye.slash")
                    .foregroundColor(.secondary)
            }
            
        }
    }
}
