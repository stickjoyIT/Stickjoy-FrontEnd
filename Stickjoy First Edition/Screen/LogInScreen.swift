//
//  LogInScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Nombre en Lista de Requerimientos: 3. Pantalla de Inicio de Sesión
//  Paulo: Pantalla de login donde el usuario inicia sesión, los textfield deben regresar el error de información no válida: correo/nombre de usuario y/o contraseña inválido.
//  ¿Qué falta?: Regresar error de información no válida. Proceso de Recuperación de contraseña. 

import SwiftUI
import SwiftUISnackbar
import FirebaseMessaging
import Firebase

struct LogInScreen: View {
    
    enum FocusedField {
        case password, securePass
    }
    
    @State private var showPassword = false
    @ObservedObject var uvm = UsuariosViewModel()
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
    
    @Binding var logueado:Bool
    @State var shorSnack = false
    
    @State var lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
    @FocusState private var focusedField: FocusedField?
    var body: some View {
        Spacer().navigationBarBackButtonHidden(true)
        
        VStack(alignment: .center, spacing: 5) {
            HStack {
                Button{
                    presentationMode.wrappedValue.dismiss()
                }label: {
                    Image(systemName: "arrow.left.circle.fill")
                        .foregroundColor(.gray)
                        .font(.largeTitle)
                }.padding()
                
                Text(lenguaje == "es" ? "Iniciar sesión" : "Log in")
                    .font(.title)
                    .fontWeight(.medium)
                    .padding(.all, 30)
                Spacer()
            }.padding(.trailing)
            ScrollView(.vertical) {
                
                UnderlineTextFieldView(text: $emailOrUsername, textFieldView: textView, placeholder: lenguaje == "es" ? "Correo electrónico" : "Email").padding(25)
                
                UnderlineTextFieldView(text: $password, textFieldView: passwordView, placeholder: lenguaje == "es" ? "Contraseña" : "Password").padding(25).foregroundColor(.white)
                
                HStack {
                    Spacer()
                    Button(action: {
                        isForgotPasswordMenuPresented = true // Show the ForgotMyPasswordMenu
                    }) {
                        Text(lenguaje == "es" ? "Olvidé mi contraseña" : "I forgot my password")
                            .foregroundColor(.gray)
                            .padding(.trailing) // Add trailing padding
                    }
                }
                if uvm.loading{
                    ProgressView().frame(width: 60,height: 60)
                } else {
                    Button(action: {
                        uvm.loginUser(email: emailOrUsername, pass: password, compation: { success in
                            if success {
                                let tokenPush = Messaging.messaging().fcmToken ?? ""
                                print("token Uni:", tokenPush)
                                let idUser = UserDefaults.standard.string(forKey: "id") ?? ""
                                saveIdDevice(id_device: tokenPush, id_user: idUser)
                            }
                            logueado = success
                            shorSnack = !success
                        })
                    }, label: {
                        Text(lenguaje == "es" ? "Continuar" : "Continue")
                            .foregroundColor(scheme == .dark ? Color.black : Color.white)
                            .frame(width: 250)
                            .padding()
                            .background(scheme == .dark ? Color.white : Color.black)
                            .cornerRadius(80)
                            .padding(.top,100)
                            .disabled(uvm.loading)
                    })
                    
                }
                Spacer()
            }
            .padding(.top)
            .fullScreenCover(isPresented: $isForgotPasswordMenuPresented) {
                ForgotMyPasswordMenu(isPresented: $isForgotPasswordMenuPresented, lenguaje: $lenguaje)
            }
            .alert(isPresented: $shorSnack, content: {
                Alert(title: Text("Mensaje"), message:Text(uvm.mensaje))
            })
        }
    }
    
    func getAlert() -> Alert {
        return  Alert(title: Text("Mensaje"), message: Text(mensajeAlerta), dismissButton: .default(Text("ok")))
    }
    
    func saveIdDevice(id_device:String, id_user:String){
        uvm.saveIdNotification(id_device: id_device, id_user: id_user)
    }
}

extension LogInScreen {
    
    private var textView: some View {
        TextField("", text: $emailOrUsername)
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
                .focused($focusedField, equals: .password)
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
                
                UIApplication.shared.endEditing()
            }){
                Image(systemName: showPassword ? "eye" : "eye.slash")
                    .foregroundColor(.secondary)
            }
            
        }
    }
}

struct LogInScreen_Previews: PreviewProvider {
    static var previews: some View {
        LogInScreen(logueado: .constant(false))
    }
}
// Esta extensión te permite ocultar el teclado
extension UIApplication {
    func endEditing() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
