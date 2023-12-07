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
import Combine

struct SignInScreen: View {
    
    enum FocusedField {
        case password, securePass, secureConfimPass, confirmPass
    }
    @FocusState private var focusedField: FocusedField?
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
    
    let textLimit = 25 //Your limit
    let textMin = 6

    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var agreedToTerms = false // Estado default del checkbox toggle es falso
    @State private var confirmPass = ""
    @State var pincode = false
    @State var lenguaje = "es"
    @State var id_user = ""
    @State var policy = false
    @State var termsEn = false
    var body: some View {
            ZStack(alignment: .top) {
                VStack() { // Espacio vertical entre objeto
                    HStack {
                        Button{
                            presentationMode.wrappedValue.dismiss()
                        }label: {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        }.padding()
                        Text(lenguaje == "es" ? "Regístrate" : "Sign In")
                            .font(.title)
                            .fontWeight(.medium)
                            .padding(.leading, 40)
                        Spacer()
                    }.padding(.trailing)
                    ScrollView(.vertical) {
                    
                        UnderlineTextFieldView(text: $email, textFieldView: emailView, placeholder:lenguaje == "es" ? "Correo electrónico" : "Email").padding(25)
                        VStack {
                            UnderlineTextFieldView(text: $username, textFieldView: userView, placeholder: lenguaje == "es" ? "      Nombre de usuario" : "      Username")
                            Text( lenguaje == "es" ? "Mínimo 6 caracteres, máximo 25, solo letras minúsculas, números, guión bajo y punto." : "Minimum 6 characters, maximum 25, only lowercase letters, numbers, underscore, and period allowed.")
                                .font(.caption)
                                .foregroundColor(Color.secondary)
                        }.padding(25)
                    
                        UnderlineTextFieldView(text: $password, textFieldView: passwordView, placeholder: lenguaje == "es" ? "Contraseña" : "Password").padding(25)
                        
                        UnderlineTextFieldView(text: $confirmPass, textFieldView: passwordConfirmView, placeholder: lenguaje == "es" ? "Confirmar contraseña" : "Confirm password").padding(25)
                        
                        Text(lenguaje == "es" ? "La contraseña debe incluir mínimo 8 caracteres, 1 signo especial y 1 número." : "Password should include at least 8 characters, 1 special symbol and 1 number.")
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
                            if username.count < 6 {
                                showSnack = true
                                uvm.mensaje = "el usuario debe ser minimo 6 caracteres"
                            } else {
                                uvm.registrarUsuario(name: "", correo: email, pass: password, confirm_pass: confirmPass, username: username){ success in
                                    if success.status == 200 {
                                        pincode = true
                                        id_user = success.idUser
                                    } else {
                                        showSnack = true
                                    }
                                }
                            }
                        }, label: {
                            Text(lenguaje == "es" ? "Enviar PIN a mi correo" : "Send PIN to my email")
                                .foregroundColor(agreedToTerms && scheme == .dark ? Color.black : Color.white)
                                .frame(width: 250)
                                .padding()
                                .background(agreedToTerms ? Color.primary : Color.secondary) // Set background color based on toggle state
                                .cornerRadius(80)
                                .padding()
                        }).disabled((!agreedToTerms || uvm.loading)) // Disable the button if agreedToTerms is false
                    }
                        Button(lenguaje == "es" ? "Leer Términos, Condiciones de Uso y Políticas de Privacidad" : "Read Terms, Conditions of Use, and Privacy Policies") {
                            if lenguaje == "es" {
                                policy = true
                            } else {
                                termsEn = true
                            }
                    }
                    .foregroundColor(.blue)
                    .padding()
                    .font(.system(size: 12))
                    .sheet(isPresented:$policy,content: {
                        TerminosCondiciones()
                    })
                    .sheet(isPresented:$termsEn,content: {
                        TerminosCondicionesIngles()
                    })
                    
                } // Add top padding to create space for the keyboard
                .alert(isPresented: $showSnack, content: {
                    Alert(title: Text(lenguaje == "es" ? "Mensaje" : "Message"), message:Text(uvm.mensaje))
                })
                .fullScreenCover(isPresented:$pincode, content: {
                    PinCaptureScreen(uvm: uvm, numberOfFields: 4, email: .constant(email), mensajeRegistro: $uvm.mensaje, lenguaje: .constant(lenguaje), idUser: .constant(id_user), logueado: $logueado)
                })
            }
        }
            .onAppear{
               lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
            }
    }
    
    //Function to keep text length in limits
        func limitText(_ upper: Int) {
            if username.count > upper {
                username = String(username.prefix(upper))
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
        HStack {
            Text("@")
            TextField("", text: $username, onEditingChanged: { _ in
                    self.username = self.username.lowercased()
                })
                .foregroundColor(scheme == .dark ? .white : .black)
                .keyboardType(.default)
                .autocapitalization(.none)
                .textInputAutocapitalization(.never)
                .textCase(.lowercase)
            .onReceive(Just(username)) { _ in limitText(textLimit) }
            .onChange(of: username){ newValue in
                //print("Continuar:",newValue.count)
                username = newValue.lowercased().replacingOccurrences(of: " ", with: "")
                if newValue.count > textLimit {
                    username = String(newValue.prefix(textLimit))
                }
            }
        }
    }
    
    private var passwordView: some View {
        HStack {
            if showPassword {
                TextField("",
                          text: $password)
                .foregroundColor(scheme == .dark ? .white : .black)
                .colorScheme(.dark)
                .focused($focusedField, equals: .password)
                .autocapitalization(.none)
            } else {
                SecureField("", text: $password)
                    .foregroundColor(scheme == .dark ? .white : .black)
                    .colorScheme(.dark)
                    .focused($focusedField, equals: .securePass)
            }
            Button(action: {
                self.showPassword.toggle()
                if showPassword {
                    focusedField = .password
                } else {
                    focusedField = .securePass
                }
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
                .focused($focusedField, equals: .confirmPass)
            } else {
                SecureField("", text: $confirmPass)
                    .foregroundColor(scheme == .dark ? .white : .black)
                    .colorScheme(.dark)
                    .focused($focusedField, equals: .secureConfimPass)
            }
            Button(action: {
                self.showPasswordC.toggle()
                if showPassword {
                    focusedField = .confirmPass
                } else {
                    focusedField = .secureConfimPass
                }
            }){
                Image(systemName: showPasswordC ? "eye" : "eye.slash")
                    .foregroundColor(.secondary)
            }
            
        }
    }
    
}


