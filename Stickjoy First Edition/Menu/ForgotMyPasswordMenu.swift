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
    @State var password = ""
    @State var confirm_pass = ""
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Recuperar contraseña")
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
            
            UnderlineTextFieldView(text: $password, textFieldView: passwordView, placeholder: "Nueva contraseña").padding(.bottom, 16)
            
            UnderlineTextFieldView(text: $confirm_pass, textFieldView: passwordConfirmView, placeholder: "Confirmar nueva contraseña").padding(.bottom, 16)
            
            Button("Enviar"){
                
            }
            .frame(maxWidth: .infinity).padding(.all, 8)
            .background(.yellow).foregroundColor(.white).cornerRadius(4)
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 20)
        .background(.white)
        .cornerRadius(8)
        .padding(.leading, 4)
        .padding(.trailing, 4)
        //Aquí va proceso de recuperación de contraseña.
    }
}

struct ForgotMyPasswordMenu_Previews: PreviewProvider {
    static var previews: some View {
        ForgotMyPasswordMenu(isPresented: .constant(true))
    }
}
extension ForgotMyPasswordMenu {
    private var passwordView: some View {
        SecureField("", text: $password)
            .foregroundColor(.black)
    }
    private var passwordConfirmView: some View {
        SecureField("", text: $confirm_pass)
            .foregroundColor(.black)
    }
}
