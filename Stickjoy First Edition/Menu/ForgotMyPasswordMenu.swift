//
//  ForgotMyPasswordMenu.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Nombre en Lista de Requerimientos: 2. Pop Up Menu - Olvidé mi Contraseña
//  Paulo: Aquí se despliega el proceso de recuperación de contraseña que no ha quedado concretado aún.
//  ¿Qué sigue?: Sigue colocar el proceso. 

import SwiftUI

struct ForgotMyPasswordMenu: View {
    @Binding var isPresented: Bool // Add this binding
    @ObservedObject var uvm = UsuariosViewModel()
    @State var email = ""
    @State var confirm_pass = ""
    @Binding var lenguaje:String
    @State var isAlert = false
    @State var message = ""
    
    // Para adapatación a dark y light mode
    @Environment (\.colorScheme) var scheme
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(lenguaje == "es" ? "Recuperar contraseña" : "Forgot password")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .padding(.top, 8)
                Spacer()
                Button(action: {
                    isPresented = false
                }, label: {
                    Image(systemName: "multiply")
                }).font(.system(size: 18)).foregroundColor(Color(hex: "616161"))
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 20)
            
            UnderlineTextFieldView(text: $email, textFieldView: passwordView, placeholder: lenguaje == "es" ? "Correo" : "Email").padding(.bottom, 16)
            
            Button(action: {
                uvm.forGotPassword(email: email, responseReturn: { resp in
                    isAlert = true
                    message = resp.message
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        isPresented = false
                    }
                })
            }, label: {
                Text(lenguaje == "es" ? "Enviar" : "Send")
                    .foregroundColor(scheme == .dark ? Color.black : Color.white)
                    .frame(width: 250)
                    .padding()
                    .background(scheme == .dark ? Color.white : Color.black)
                    .cornerRadius(80)
            })
            
        }
        .padding(.vertical, 20)
        //.background(.white)
        .cornerRadius(8)
        .padding(.leading, 4)
        .padding(.trailing, 4)
        .alert(isPresented: $isAlert, content: {
            Alert(title: Text("Mensaje"), message: Text(message))
        })
        //Aquí va proceso de recuperación de contraseña.
    }
}

struct ForgotMyPasswordMenu_Previews: PreviewProvider {
    static var previews: some View {
        ForgotMyPasswordMenu(isPresented: .constant(true), lenguaje: .constant(""))
    }
}
extension ForgotMyPasswordMenu {
    private var passwordView: some View {
        TextField("", text: $email)
            .foregroundColor(scheme == .dark ? .white : .black)
    }
    private var passwordConfirmView: some View {
        SecureField("", text: $confirm_pass)
            .foregroundColor(scheme == .dark ? .white : .black)
    }
}
