//
//  SubscriptionScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 10/08/23.
//  Nombre de Lista de Requerimientos: 18. Pantalla de Suscripción
//  Paulo: Tiene un pop up menu ya conectado, solo falta poner la info dentro.
//  ¿Qué falta?: Acción de botón de continuar. Llenar el menú de términos de suscripción.

import SwiftUI

struct SubscriptionScreen: View {
    @State private var isTermsMenuPresented = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.customYellow // Replace with your desired background color
                    .frame(width: geometry.size.width, height: geometry.size.height)
                VStack(alignment: .center, spacing: 8) {
                    Text("Subscription")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical)
                        .foregroundColor(.black)
                    
                    SubscriptionBenefitsSection()
                    
                    
                    Button(action: {
                        //Añadir acción de abrir API de pago de App Store
                    }) {
                        Text("Continue")
                            .frame(width: 250)
                            .padding()
                            .background(Color.customBlue)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                    
                    Text("By clicking continue you accept our subscription terms.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    
                    Text("Subscription Terms")
                        .foregroundColor(.black)
                        .onTapGesture {
                            isTermsMenuPresented.toggle()
                        }
                        .sheet(isPresented: $isTermsMenuPresented) {
                            SubscriptionTermsMenu(isPresented: $isTermsMenuPresented)
                        }
                }
                .padding(.horizontal, 24)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}


struct SubscriptionBenefitsSection: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            Text("Subscription Benefits")
                .foregroundColor(.black)
                .font(.headline)
            VStack(alignment: .leading, spacing: 24) {
                HStack{
                    Image("stickjoyLogoBlue")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .cornerRadius(32)
                    Text("Higher quality of your album's content")
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                }
                
                HStack{
                    Image("stickjoyLogoBlue")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .cornerRadius(32)
                    Text("No more adds inside your albums")
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                }
                
                HStack{
                    Text("$3.90 USD")
                        .foregroundColor(.black)
                        .font(.title2)
                        .bold()
                    Text("monthly")
                        .foregroundColor(.black)
                        .font(.title3)
                }
                .frame(width: 250, height: 80)
                .background(Color.white)
                .cornerRadius(64)
                
            }
            .frame(width: 250)
            .padding(.horizontal)
            .padding(.vertical, 50)
        }
    }
}

struct SubscriptionScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SubscriptionScreen()
        }
    }
}
